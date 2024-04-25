import 'package:flutter/material.dart';

class EffectBoard extends StatefulWidget {
  final Size size;

  const EffectBoard({super.key, required this.size});

  @override
  State<StatefulWidget> createState() => _EffectBoardState();
}

class _EffectBoardState extends State<EffectBoard>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: widget.size,
      painter: _EffectBoardPaint(),
    );
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
  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
