import 'package:flutter/material.dart';

import '../data/grid_data.dart';

class LineBoard extends StatelessWidget {
  final Size size;

  const LineBoard({super.key, required this.size});

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: size,
        painter: _LineBoard(),
      );
}

class _LineBoard extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    // 画棋盘线
    var gridSize = (rect.width - 20) / (GridData.col);
    // 加1，是让线条往内部缩进一个像素
    drawBackground(canvas, rectMap(rect, 10 + 1), gridSize);
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
    for (int i = 1; i < GridData.row; i++) {
      double dy = rect.top + grid * i;
      canvas.drawLine(Offset(rect.left, dy), Offset(rect.right, dy), paint);
    }

    // 画竖线
    for (int i = 1; i < GridData.col; i++) {
      double dx = rect.left + grid * i;
      canvas.drawLine(Offset(dx, rect.top), Offset(dx, rect.bottom), paint);
    }
  }

  Rect rectMap(Rect src, int diff) {
    return Rect.fromLTRB(
        src.left + diff, src.top + diff, src.right - diff, src.bottom - diff);
  }
}
