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
  int score = 0;

  @override
  Widget build(BuildContext context) {
    print('number build');
    bool repaint = score == widget.data.score;
    score = widget.data.score;
    var size = widget.size;
    return CustomPaint(
      size: size,
      painter: MyPainter(width: size.width, data: widget.data, repaint: repaint),
    );
  }
}

void drawBackground(Canvas canvas, Rect rect, double grid) {
  //棋盘背景
  var paint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.fill //填充
    ..color = const Color(0xffffffff);
  canvas.drawRect(rect, paint);

  //画棋盘网格
  paint
    ..style = PaintingStyle.stroke //线
    ..color = Colors.black38
    ..strokeWidth = 1.0;

  //画横线
  for (int i = 0; i <= GridData.row; i++) {
    double dy = rect.top + grid * (i + 1);
    canvas.drawLine(
        Offset(rect.left + grid, dy), Offset(rect.right - grid, dy), paint);
  }

  for (int i = 0; i <= GridData.col; i++) {
    double dx = rect.left + grid * (i + 1);
    canvas.drawLine(
        Offset(dx, rect.top + grid), Offset(dx, rect.bottom - grid), paint);
  }
}

// 绘制数字
void drawPieces(Canvas canvas, Rect rect, double grid, GridData data) {
  var paint = TextPainter()
    ..textAlign = TextAlign.center
    ..textDirection = TextDirection.ltr;
  const style = TextStyle(color: Colors.black, fontSize: 20);
  for (int i = 0; i < GridData.row; i++) {
    var list = data.grids[i];
    for (int j = 0; j < GridData.col; j++) {
      var content = list[j];
      if (content == 0) {
        continue;
      }
      paint.text = TextSpan(text: content.toString(), style: style);
      paint.layout(minWidth: grid);
      paint.paint(canvas, Offset(grid * (j + 1), grid * (i + 1) + 6));
    }
  }
}

class MyPainter extends CustomPainter {
  final double width;

  final GridData data;

  double grid = 0;

  double gridHeight = 0;

  final bool repaint;

  MyPainter({required this.width, required this.data, required this.repaint}) {
    grid = width / (GridData.col + 2);
    gridHeight = grid * (GridData.row + 2);
  }

  @override
  void paint(Canvas canvas, Size size) {
    print('draw background and number');
    var rect = Offset.zero & Size(size.width, gridHeight);
    //画棋盘
    drawBackground(canvas, rect, grid);
    //画棋子
    drawPieces(canvas, rect, grid, data);
  }

  // 返回false, 后面介绍
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
