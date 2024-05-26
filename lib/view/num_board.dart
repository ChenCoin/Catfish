import 'package:flutter/material.dart';

import '../ux.dart';
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
      painter: _MyPainter(size.width, widget.data),
    );
  }
}

class _MyPainter extends CustomPainter {
  final double width;

  final GridData data;

  late NumberDrawer drawer;

  _MyPainter(this.width, this.data) {
    double grid = width / (UX.col);
    drawer = NumberDrawer(grid);
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < UX.row; i++) {
      var list = data.grids[i];
      for (int j = 0; j < UX.col; j++) {
        var content = list[j];
        if (content == 0) {
          continue;
        }
        drawer.drawDirect(canvas, j.toDouble(), i.toDouble(), content);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
