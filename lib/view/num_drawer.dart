import 'package:flutter/material.dart';

class NumberDrawer {
  final gridPaint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.fill
    ..color = Colors.white;

  final paint = TextPainter()
    ..textAlign = TextAlign.center
    ..textDirection = TextDirection.ltr;

  double grid;

  int p = 0;

  double fontSize = 0;

  var style = const TextStyle();

  NumberDrawer(this.grid) {
    p = (grid / 6).floor();
    fontSize = grid - p * 2 - 5;
    style = TextStyle(
      color: Colors.black,
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    );
  }

  void drawNumber(Canvas canvas, int i, int j, int content) {
    // 画小白块
    var left = grid * j + p;
    var top = grid * i + p;
    var right = left + grid - p * 2;
    var bottom = top + grid - p * 2;
    var rect = Rect.fromLTRB(left, top, right, bottom);
    RRect whiteGrid = RRect.fromRectAndRadius(rect, const Radius.circular(2));
    canvas.drawRRect(whiteGrid, gridPaint);
    // 画数字
    paint.text = TextSpan(text: content.toString(), style: style);
    paint.layout(minWidth: grid);
    // -2是将文字上移一点
    var dy = grid * i + (grid - fontSize) / 2 - 2;
    paint.paint(canvas, Offset(grid * j, dy));
  }

  void drawDirect(Canvas canvas, double x, double y, int content) {
    _drawRaw(canvas, x, y, content, p);
  }

  void drawDirectBold(Canvas canvas, double x, double y, int content) {
    _drawRaw(canvas, x, y, content, (p * 2 / 3).ceil());
  }

  void _drawRaw(Canvas canvas, double x, double y, int content, int border) {
    // 画小白块
    var left = grid * x + border;
    var top = grid * y + border;
    var right = left + grid - border * 2;
    var bottom = top + grid - border * 2;
    var rect = Rect.fromLTRB(left, top, right, bottom);
    RRect whiteGrid = RRect.fromRectAndRadius(rect, const Radius.circular(2));
    canvas.drawRRect(whiteGrid, gridPaint);
    // 画数字
    paint.text = TextSpan(text: content.toString(), style: style);
    paint.layout(minWidth: grid);
    // -2是将文字上移一点
    var dy = grid * y + (grid - fontSize) / 2 - 2;
    paint.paint(canvas, Offset(grid * x, dy));
  }
}
