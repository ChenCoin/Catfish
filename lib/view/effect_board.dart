import 'package:flutter/material.dart';

class EffectBoard extends StatefulWidget {
  final Size size;

  const EffectBoard({super.key, required this.size});

  @override
  State<StatefulWidget> createState() => _EffectBoardState();
}

class _EffectBoardState extends State<EffectBoard> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: widget.size,
      painter: _EffectBoardPaint(),
    );
  }
}

class _EffectBoardPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
