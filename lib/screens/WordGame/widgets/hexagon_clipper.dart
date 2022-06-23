import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width * 0, size.height * 0.5);
    path.lineTo(size.width * 0.25, size.height);
    path.lineTo(size.width * 0.75, size.height);
    path.lineTo(size.width, size.height * 0.5);
    path.lineTo(size.width * 0.75, 0);
    path.lineTo(size.width * 0.25, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
