import 'package:flutter/material.dart';

class NumberDrawer {
  final gridPaint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.fill
    ..color = Colors.white;

  final yellowGridPaint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.fill
    ..color = Colors.amber;

  final paint = TextPainter()
    ..textAlign = TextAlign.center
    ..textDirection = TextDirection.ltr;

  double grid;

  int p = 0;

  double fontSize = 0;

  var style = const TextStyle();

  var whiteStyle = const TextStyle();

  NumberDrawer(this.grid) {
    p = (grid / 6).floor();
    fontSize = grid - p * 2 - 5;
    style = TextStyle(
      color: Colors.black,
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    );
    whiteStyle = TextStyle(
      color: Colors.white,
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    );
  }

  void drawDirect(Canvas canvas, double x, double y, int content) {
    _draw(canvas, x, y, content, false);
  }

  void drawDirectBold(Canvas canvas, double x, double y, int content) {
    _draw(canvas, x, y, content, true);
  }

  void _draw(Canvas canvas, double x, double y, int num, bool bold) {
    // 画小白块
    var border = bold ? (p / 2).ceil() : p;
    var left = grid * x + border;
    var top = grid * y + border;
    var right = left + grid - border * 2;
    var bottom = top + grid - border * 2;
    var rect = Rect.fromLTRB(left, top, right, bottom);
    Radius radius = Radius.circular(bold ? 6 : 4);
    RRect whiteGrid = RRect.fromRectAndRadius(rect, radius);
    canvas.drawRRect(whiteGrid, bold ? yellowGridPaint : gridPaint);
    // 画数字
    paint.text =
        TextSpan(text: num.toString(), style: bold ? whiteStyle : style);
    paint.layout(minWidth: grid);
    // -2是将文字上移一点
    var dy = grid * y + (grid - fontSize) / 2 - 2;
    paint.paint(canvas, Offset(grid * x, dy));
  }
}
