import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'home_screen.dart';

import '../theme/app_colors.dart';

class ArrivalScreen extends StatefulWidget {
  final double distance;

  const ArrivalScreen({
    super.key,
    required this.distance,
  });

  @override
  State<ArrivalScreen> createState() => _ArrivalScreenState();
}

class _ArrivalScreenState extends State<ArrivalScreen>
    with SingleTickerProviderStateMixin {
  static const accent = Color(0xffD64045);

  late final AnimationController _controller;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();

    // Petite vibration à l'arrivée
    HapticFeedback.heavyImpact();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoScale = Tween<double>(
      begin: 0.75,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _logoOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.0,
        0.45,
        curve: Curves.easeOut,
      ),
    );

    _textOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.35,
        0.8,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
  child: Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: 28,
        vertical: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FadeTransition(
            opacity: _logoOpacity,
            child: ScaleTransition(
              scale: _logoScale,
              child: SvgPicture.asset(
                "assets/logo.svg",
                height: 150,
              ),
            ),
          ),

          const SizedBox(height: 42),

          FadeTransition(
            opacity: _textOpacity,
            child: Column(
              children: [
                const Text(
                  "Tu y es.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 46,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  "Tu as trouvé la Cathé !",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    color: AppColors.text(context),
                  ),
                ),

                const SizedBox(height: 28),

                Text(
                  "À quelques mètres de la Cathédrale\n"
                  "Notre-Dame de Strasbourg.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.5,
                    fontSize: 16,
                    color: AppColors.secondary(context),
                  ),
                ),

                const SizedBox(height: 28),

                const Text(
                  "Félicitations ❤️",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: accent,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 24),

                OutlinedButton(
                  onPressed: () {
                     Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const HomeScreen(skipArrivalCheck: true),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: accent,
                    side: const BorderSide(
                      color: accent,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Revenir à la boussole",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ),
      ),
    );
  }
}