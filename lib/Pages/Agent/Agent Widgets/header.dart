
import 'package:flutter/cupertino.dart';


class AgentHead extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width * 0.35, size.height * 0.60, size.width * 0.5, size.height * 0.65);
    path.quadraticBezierTo(size.width * 0.70, size.height * 0.75, size.width, 0);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

