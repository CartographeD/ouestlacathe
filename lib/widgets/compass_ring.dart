import 'dart:math';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CompassRing extends StatelessWidget {
  final double angle;

  const CompassRing({
    super.key,
    required this.angle,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(280, 280),
      painter: CompassRingPainter(
        angle: angle,
        context: context,
      ),
    );
  }
}

class CompassRingPainter extends CustomPainter {
  final double angle;
  final BuildContext context;

  CompassRingPainter({
    required this.angle,
    required this.context,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final dark =
        Theme.of(context).brightness == Brightness.dark;

    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    const radius = 138.0;

    //-------------------------
    // Graduations
    //-------------------------

    final highlighted =
        (((angle % 360) + 360) % 360 / 15).round() % 24;

    for (int i = 0; i < 24; i++) {
      final a = (-90 + i * 15) * pi / 180;

      final isCardinal = i % 6 == 0;

      final start =
          radius - (isCardinal ? 26 : 16);

      Color color = dark
          ? Colors.white.withOpacity(.38)
          : Colors.grey.shade300;

      if (i == highlighted) {
        color = const Color(0xffD64045);
      } else if (
          i == (highlighted + 1) % 24 ||
          i == (highlighted + 23) % 24) {
        color = dark
            ? Colors.white.withOpacity(.70)
            : Colors.grey.shade500;
      }

      final paint = Paint()
        ..color = color
        ..strokeWidth = isCardinal ? 1.8 : 0.8
        ..strokeCap = StrokeCap.round;

      final p1 = Offset(
        center.dx + cos(a) * start,
        center.dy + sin(a) * start,
      );

      final p2 = Offset(
        center.dx + cos(a) * radius,
        center.dy + sin(a) * radius,
      );

      canvas.drawLine(
        p1,
        p2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant CompassRingPainter oldDelegate,
  ) {
    return oldDelegate.angle != angle;
  }
}