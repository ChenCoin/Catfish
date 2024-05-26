import 'package:flutter/material.dart';

import '../ux.dart';

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
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFC1802E);
    // 画棕黄色的底
    canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(8)), paint);

    // 画墨绿色的底
    paint.color = const Color(0xFF1E7F56);
    Rect innerBox = rectMap(rect, 10);
    canvas.drawRRect(
        RRect.fromRectAndRadius(innerBox, const Radius.circular(8)), paint);

    // 画黄褐色的最外圈边框
    paint.style = PaintingStyle.stroke;
    paint.color = const Color(0xFF4E3111);
    paint.strokeWidth = 2;
    canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(8)), paint);

    // 画深绿色的内圈边框
    paint.color = const Color(0xFF0A412A);
    paint.strokeWidth = 3;
    Rect innerRect = rectMap(rect, 9);
    canvas.drawRRect(
        RRect.fromRectAndRadius(innerRect, const Radius.circular(8)), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  void drawBackground(Canvas canvas, Rect rect, double grid) {
    var paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFF56B293)
      ..strokeWidth = 1.0;

    // 画横线
    for (int i = 1; i < UX.row; i++) {
      double dy = rect.top + grid * i;
      canvas.drawLine(Offset(rect.left, dy), Offset(rect.right, dy), paint);
    }

    // 画竖线
    for (int i = 1; i < UX.col; i++) {
      double dx = rect.left + grid * i;
      canvas.drawLine(Offset(dx, rect.top), Offset(dx, rect.bottom), paint);
    }
  }

  Rect rectMap(Rect src, int diff) {
    return Rect.fromLTRB(
        src.left + diff, src.top + diff, src.right - diff, src.bottom - diff);
  }
}
