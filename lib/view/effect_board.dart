import 'package:flutter/material.dart';

import '../data/draw_data.dart';
import '../data/grid_data.dart';
import 'num_drawer.dart';

class EffectBoard extends StatefulWidget {
  final Size size;

  final DrawData drawData;

  const EffectBoard({super.key, required this.size, required this.drawData});

  @override
  State<StatefulWidget> createState() => _EffectBoardState();
}

class _EffectBoardState extends State<EffectBoard>
    with TickerProviderStateMixin {
  var allController = <AnimationController>[];

  @override
  void initState() {
    super.initState();
    widget.drawData.initBoard(addEffect);
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
    for (var element in allController) {
      element.dispose();
    }
    super.dispose();
    allController.clear();
    widget.drawData.dispose();
  }

  void addEffect(List<EffectPoint> item) {
    Duration duration = const Duration(milliseconds: 800);
    var controller = AnimationController(duration: duration, vsync: this);
    // animation用于获取数值
    var curve = CurvedAnimation(parent: controller, curve: Curves.easeOutQuad);
    Animation<double> anim = Tween(begin: 0.0, end: 250.0).animate(curve)
      ..addListener(() => setState(() {}));
    var effectGrids = EffectGrids(item, anim);
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        allController.remove(controller);
        widget.drawData.remove(effectGrids);
      }
    });
    widget.drawData.add(effectGrids);
    allController.add(controller);
    controller.forward();
  }
}

class _EffectBoardPaint extends CustomPainter {
  List<EffectGrids> _allItem;

  late NumberDrawer drawer;

  _EffectBoardPaint(this._allItem, double width) {
    double grid = width / (GridData.col);
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
