import 'package:flutter/material.dart';

import '../data/GridData.dart';

class NumBoard extends StatefulWidget {
  final Size size;

  final GridData data;

  const NumBoard({super.key, required this.size, required this.data});

  @override
  State<StatefulWidget> createState() => _NumBoardState();
}

class _NumBoardState extends State<NumBoard> {
  @override
  Widget build(BuildContext context) {
    var size = widget.size;
    return CustomPaint(
      size: size,
      painter: MyPainter(width: size.width, data: widget.data),
    );
  }
}

// 绘制数字
void drawPieces(Canvas canvas, Rect rect, double grid, GridData data) {
  int p = 7;
  var gridPaint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.fill
    ..color = Colors.white;
  var paint = TextPainter()
    ..textAlign = TextAlign.center
    ..textDirection = TextDirection.ltr;
  const style = TextStyle(
    color: Colors.black,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  for (int i = 0; i < GridData.row; i++) {
    var list = data.grids[i];
    for (int j = 0; j < GridData.col; j++) {
      var content = list[j];
      if (content == 0) {
        continue;
      }
      var left = grid * j + p;
      var top = grid * i + p;
      var right = left + grid - p * 2;
      var bottom = top + grid - p * 2;
      var gridRect = Rect.fromLTRB(left, top, right, bottom);
      canvas.drawRect(gridRect, gridPaint);
      paint.text = TextSpan(text: content.toString(), style: style);
      paint.layout(minWidth: grid);
      paint.paint(canvas, Offset(grid * j, grid * i + 4));
    }
  }
}

class MyPainter extends CustomPainter {
  final double width;

  final GridData data;

  double grid = 0;

  double gridHeight = 0;

  MyPainter({required this.width, required this.data}) {
    grid = width / (GridData.col);
    gridHeight = grid * (GridData.row);
  }

  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & Size(size.width, gridHeight);
    drawPieces(canvas, rect, grid, data);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
