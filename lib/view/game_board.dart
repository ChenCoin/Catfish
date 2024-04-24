import 'package:flutter/material.dart';
import '../data/grid_data.dart';
import 'effect_board.dart';
import 'gesture_box.dart';
import 'num_board.dart';

class GameBoard extends StatefulWidget {
  // 画布宽度
  final Size size;

  final void Function() callback;

  final GridData data;

  const GameBoard({
    super.key,
    required this.size,
    required this.callback,
    required this.data,
  });

  @override
  State<StatefulWidget> createState() => _DrawBoard();
}

class _DrawBoard extends State<GameBoard> {
  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    return Stack(
      alignment: Alignment.center,
      children: [
        RepaintBoundary(
          child: NumBoard(
            size: size,
            data: widget.data,
          ),
        ),
        RepaintBoundary(
          child: SizedBox.fromSize(
            size: size,
            child: EffectBoard(size: size),
          ),
        ),
        RepaintBoundary(
          child: SizedBox.fromSize(
            size: size,
            child: GestureBox(size: size, callback: (rect) => onGesture(rect)),
          ),
        )
      ],
    );
  }

  void onGesture(Rect rect) {
    int left = rect.left.floor();
    int top = rect.top.floor();
    int right = rect.right.floor();
    int bottom = rect.bottom.floor();
    var pointList = widget.data.onGridDrag(left, top, right, bottom);
    for (var value in pointList) {
      debugPrint("point $value");
    }
    if (pointList.isNotEmpty) {
      widget.callback();
    }
  }
}
