import 'package:flutter/material.dart';

class HexagonButton extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.amber[600]!
      ..style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(size.width * 0, size.height * 0.5);
    path.lineTo(size.width * 0.25, size.height);
    path.lineTo(size.width * 0.75, size.height);
    path.lineTo(size.width, size.height * 0.5);
    path.lineTo(size.width * 0.75, 0);
    path.lineTo(size.width * 0.25, 0);

    path.close();
    canvas.drawPath(
      path,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
