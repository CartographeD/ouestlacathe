import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

import 'compass_arrow.dart';
import 'compass_ring.dart';

class CompassWidget extends StatelessWidget {
  final double angle;

  const CompassWidget({
    super.key,
    required this.angle,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Boussole
          CompassRing(angle: angle),

          // Ombre sous la flèche
          Transform.translate(
            offset: const Offset(0, 3),
            child: Opacity(
              opacity: dark ? .18 : .08,
              child: CompassArrow(
                angle: angle,
              ),
            ),
          ),

          // Flèche
          CompassArrow(
            angle: angle,
          ),
        ],
      ),
    );
  }
}