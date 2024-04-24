import 'package:flutter/material.dart';
import '../data/grid_data.dart';

class GestureBox extends StatefulWidget {
  final void Function(Rect rect) callback;

  final Size size;

  const GestureBox({super.key, required this.size, required this.callback});

  @override
  State<StatefulWidget> createState() => _GestureBoxState();
}

class _GestureBoxState extends State<GestureBox> {
  Offset start = Offset.zero;

  Rect rect = Rect.zero;

  @override
  Widget build(BuildContext context) {
    return Listener(
        onPointerDown: (e) {
          start = e.localPosition;
          setState(() {});
        },
        onPointerMove: (e) {
          rect = Rect.fromPoints(start, e.localPosition);
          setState(() {});
        },
        onPointerUp: (e) {
          rect = Rect.zero;
          setState(() {});
          widget.callback(mapRect(Rect.fromPoints(start, e.localPosition)));
        },
        child: CustomPaint(
          size: widget.size,
          painter: _CanvasPaint(rect: rect),
        ));
  }

  Rect mapRect(Rect src) {
    var grid = widget.size.width / (GridData.col);
    return Rect.fromLTRB(
        src.left / grid, src.top / grid, src.right / grid, src.bottom / grid);
  }
}

class _CanvasPaint extends CustomPainter {
  final Rect rect;

  const _CanvasPaint({required this.rect});

  @override
  void paint(Canvas canvas, Size size) {
    final thePaint = Paint()
      ..color = const Color(0x403030D9)
      ..strokeCap = StrokeCap.round;
    thePaint.style = PaintingStyle.fill;
    canvas.drawRect(rect, thePaint);

    thePaint.strokeWidth = 2;
    thePaint.color = Colors.white60;
    thePaint.style = PaintingStyle.stroke;
    canvas.drawRect(rect, thePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
