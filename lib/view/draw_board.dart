import 'package:flutter/material.dart';
import '../data/GridData.dart';
import 'gesture_box.dart';
import 'num_board.dart';

class CustomPaintRoute extends StatefulWidget {
  // 画布宽度
  final Size size;

  final void Function() callback;

  final GridData data;

  const CustomPaintRoute({
    super.key,
    required this.size,
    required this.callback,
    required this.data,
  });

  @override
  State<StatefulWidget> createState() => _DrawBoard();
}

class _DrawBoard extends State<CustomPaintRoute> {
  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    return Stack(
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
            child: GestureBox(size: size, callback: (rect) => onGesture(rect)),
          ),
        )
      ],
    );
  }

  void onGesture(Rect rect) {
    int left = rect.left.floor() - 1;
    int top = rect.top.floor() - 1;
    int right = rect.right.floor() - 1;
    int bottom = rect.bottom.floor() - 1;
    bool change = widget.data.onGridDrag(left, top, right, bottom);
    if (change) {
      setState(() {});
      widget.callback();
    }
  }
}
