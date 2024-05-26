import 'package:flutter/material.dart';

import '../ux.dart';
import '../data/draw_data.dart';
import 'num_drawer.dart';

class EffectBoard extends StatefulWidget {
  final Size size;

  final DrawData drawData;

  const EffectBoard({super.key, required this.size, required this.drawData});

  @override
  State<StatefulWidget> createState() => _EffectBoardState();
}

class _EffectBoardState extends State<EffectBoard>
    with TickerProviderStateMixin
    implements EffectCreator {
  late _CachePair cachePair = _CachePair(() => _Cache(this, sync));

  @override
  void initState() {
    super.initState();
    widget.drawData.initBoard(this);
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: widget.size,
      painter: _EffectBoardPaint(widget.drawData.allItem, widget.size.width),
    );
  }

  @override
  void dispose() {
    super.dispose();
    cachePair.dispose();
    widget.drawData.dispose();
  }

  @override
  bool isEffectEnable() {
    return cachePair.isAnyEnable();
  }

  @override
  void createEffect(List<EffectPoint> item) {
    var cache = cachePair.getAnimationCache();
    cache.using = true;
    var animCache = cache.getAnimationCache();
    var controller = animCache.$1;
    var anim = animCache.$2;

    var effectGrids = EffectGrids(item, anim);
    widget.drawData.add(effectGrids);

    cache.addListener((status) {
      if (status == AnimationStatus.completed) {
        cache.using = false;
        cache.removeListener();
        widget.drawData.remove(effectGrids);
      }
    });
    controller.addStatusListener(cache._cacheListener);
    controller.forward();
  }

  void sync() {
    setState(() {});
  }
}

class _EffectBoardPaint extends CustomPainter {
  final List<EffectGrids> _allItem;

  late NumberDrawer drawer;

  _EffectBoardPaint(this._allItem, double width) {
    double grid = width / (UX.col);
    drawer = NumberDrawer(grid);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // 格子对的list
    // 2个(或者更多)格子的位置及数字
    // 或者1个格子
    for (var grids in _allItem) {
      var anim = grids.anim;
      var center = grids.center;
      for (var item in grids.allItem) {
        if (anim.value < 100) {
          double x = item.x + (center.x - item.x) * anim.value / 100;
          double y = item.y + (center.y - item.y) * anim.value / 100;
          drawer.drawDirect(canvas, x, y, item.number);
        } else {
          drawer.drawDirectBold(canvas, center.x, center.y, center.number);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _Cache {
  bool using = false;

  TickerProviderStateMixin ticker;

  VoidCallback callback;

  (AnimationController, Animation<double>)? _cache;

  AnimationStatusListener _cacheListener = (status) {};

  _Cache(this.ticker, this.callback);

  (AnimationController, Animation<double>) getAnimationCache() {
    if (_cache == null) {
      Duration duration = const Duration(milliseconds: UX.animationDuration);
      var controller = AnimationController(duration: duration, vsync: ticker);
      // animation用于获取数值
      var curve =
          CurvedAnimation(parent: controller, curve: Curves.easeOutQuad);
      var anim = Tween(begin: 0.0, end: 250.0).animate(curve)
        ..addListener(callback);
      _cache = (controller, anim);
    } else {
      _cache!.$1.reset();
    }
    return _cache!;
  }

  void addListener(AnimationStatusListener listener) {
    _cacheListener = listener;
  }

  void removeListener() {
    getAnimationCache().$1.removeStatusListener(_cacheListener);
  }
}

class _CachePair {
  final List<_Cache> _list = <_Cache>[];

  _CachePair(_Cache Function() create) {
    for (int i = 0; i < UX.animationCacheSize; i++) {
      _list.add(create());
    }
  }

  bool isAnyEnable() {
    for (var item in _list) {
      if (!item.using) {
        return true;
      }
    }
    return false;
  }

  // 调用这个接口前，先用isAnyEnable判断存在一个可用的anim，不考虑所有anim都使用中的场景
  _Cache getAnimationCache() {
    for (var item in _list) {
      if (!item.using) {
        return item;
      }
    }
    // 这个返回值会导致异常
    return _list[0];
  }

  void dispose() {
    for (var item in _list) {
      item._cache?.$1.dispose();
    }
  }
}
