import 'package:flutter/material.dart';

class ArrowPainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final double horizontalOffset;

  ArrowPainter(
      {required this.start, required this.end, this.horizontalOffset = 50.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 206, 202, 202)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    Path path = Path();
    path.moveTo(start.dx, start.dy); // Start point (top of the child)
    path.lineTo(start.dx, end.dy); // Vertical segment
    path.lineTo(
        horizontalOffset, end.dy); // Horizontal segment to the child card

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
