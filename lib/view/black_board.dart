import 'package:flutter/material.dart';

class BlackBoard extends StatelessWidget {
  final Size size;

  const BlackBoard({super.key, required this.size});

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: size,
        painter: _BlackBoard(),
      );
}

class _BlackBoard extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    var paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill //填充
      ..color = const Color(0xff1e7f56);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(8)), paint);
  }

  // 返回false, 后面介绍
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
