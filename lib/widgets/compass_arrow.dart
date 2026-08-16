import 'dart:math';
import 'package:flutter/material.dart';

class CompassArrow extends StatelessWidget {
  final double angle;

  const CompassArrow({
    super.key,
    required this.angle,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle * pi / 180,
      child: CustomPaint(
        size: const Size(80, 80),
        painter: ArrowPainter(),
      ),
    );
  }
}

class ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    final paint = Paint()
      ..color = const Color(0xffD64045)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final path = Path();

    path.moveTo(size.width / 2, 0);

    path.lineTo(size.width, size.height);

    path.lineTo(size.width / 2, size.height * .72);

    path.lineTo(0, size.height);

    path.close();

    canvas.drawShadow(
      path,
      Colors.black26,
      8,
      false,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}