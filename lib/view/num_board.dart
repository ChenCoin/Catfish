import 'package:flutter/material.dart';

import '../data/grid_data.dart';
import 'num_drawer.dart';

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
      painter: MyPainter(size.width, widget.data),
    );
  }
}

class MyPainter extends CustomPainter {
  final double width;

  final GridData data;

  late NumberDrawer drawer;

  MyPainter(this.width, this.data) {
    double grid = width / (GridData.col);
    drawer = NumberDrawer(grid);
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < GridData.row; i++) {
      var list = data.grids[i];
      for (int j = 0; j < GridData.col; j++) {
        var content = list[j];
        if (content == 0) {
          continue;
        }
        drawer.drawNumber(canvas, i, j, content);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
