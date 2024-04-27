import 'package:flutter/material.dart';

import '../data/draw_data.dart';

class EffectBoard extends StatefulWidget {
  final Size size;

  final DrawData drawData;

  const EffectBoard({super.key, required this.size, required this.drawData});

  @override
  State<StatefulWidget> createState() => _EffectBoardState();
}

class _EffectBoardState extends State<EffectBoard>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.drawData.initBoard();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: widget.size,
      painter: _EffectBoardPaint(widget.drawData.allItem),
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.drawData.dispose();
  }

  void addEffect() {
    Duration duration = const Duration(seconds: 3);
    var controller = AnimationController(duration: duration, vsync: this);
    // animation用于获取数值
    var animation = Tween(begin: 0.0, end: 100.0).animate(controller)
      ..addListener(() {});
    controller.forward();
    // controller.dispose();
  }
}

class _EffectBoardPaint extends CustomPainter {
  List<List<(int, int, int)>> _allItem;

  _EffectBoardPaint(this._allItem);

  @override
  void paint(Canvas canvas, Size size) {
    // 格子对的list
    // 2个(或者更多)格子的位置及数字
    // 或者1个格子
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
