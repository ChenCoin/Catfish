import 'package:flutter/material.dart';

import '../UX.dart';
import '../data/grid_data.dart';
import 'num_drawer.dart';

class SceneBoard extends StatefulWidget {
  final Size size;

  final GridData data;

  const SceneBoard({super.key, required this.size, required this.data});

  @override
  State<StatefulWidget> createState() => _SceneBoardState();
}

class _SceneBoardState extends State<SceneBoard> with TickerProviderStateMixin {
  late AnimationController controller;

  late Animation<double> anim;

  @override
  void initState() {
    super.initState();
    Duration duration = const Duration(milliseconds: UX.enterSceneDuration);
    controller = AnimationController(duration: duration, vsync: this);
    // animation用于获取数值
    var curve =
        CurvedAnimation(parent: controller, curve: Curves.linearToEaseOut);
    anim = Tween(begin: 100.0, end: 0.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    var size = widget.size;
    return CustomPaint(
      size: size,
      painter: _MyPainter(size.width, widget.data, anim),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class _MyPainter extends CustomPainter {
  final double width;

  final GridData data;

  final Animation<double> anim;

  late NumberDrawer drawer;

  double grid = 0;

  _MyPainter(this.width, this.data, this.anim) {
    grid = width / (UX.col);
    drawer = NumberDrawer(grid);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (data.gameState == 3) {
      for (int i = 0; i < UX.row; i++) {
        var list = data.grids[i];
        for (int j = 0; j < UX.col; j++) {
          var content = list[j];
          if (content == 0) {
            continue;
          }
          double dy = i.toDouble() - (1 + content * 0.3) * anim.value / 100;
          drawer.drawDirect(canvas, j.toDouble(), dy, content);
        }
      }
      debugPrint('anim $grid ${grid * 2 * anim.value / 100}');
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
