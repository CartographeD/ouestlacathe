import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/scheduler.dart';

import '../services/compass_service.dart';
import '../services/location_service.dart';

import '../utils/angle.dart';
import '../utils/bearing.dart';
import '../utils/cathedral.dart';
import '../utils/distance.dart';

import '../widgets/compass_widget.dart';
import '../theme/app_colors.dart';

import 'about_screen.dart';
import 'arrival_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool skipArrivalCheck;

  const HomeScreen({
    super.key,
    this.skipArrivalCheck = false,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final LocationService locationService = LocationService();
  final CompassService compassService = CompassService();

  Position? position;

  bool _arrived = false;
  bool _canCheckArrival = true;
  bool _locationError = false;

  double heading = 0;
  double bearing = 0;
  double currentAngle = 0;
  double targetAngle = 0;

  late final Ticker _ticker;

  StreamSubscription<Position>? _positionSubscription;
  StreamSubscription<double>? _headingSubscription;

  @override
  void initState() {
    super.initState();

    _canCheckArrival = !widget.skipArrivalCheck;

    _ticker = createTicker((_) {
      final diff = ((targetAngle - currentAngle + 180) % 360) - 180;

      if (diff.abs() > 0.05) {
        setState(() {
          currentAngle += diff * 0.15;
        });
      }
    });

    _ticker.start();

    _initLocation();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _positionSubscription?.cancel();
    _headingSubscription?.cancel();
    super.dispose();
  }

  void _updateAngle() {
    targetAngle = normalizeAngle(
      currentAngle,
      bearing - heading,
    );
  }

  void _checkArrival(double distance) {
    // Après un retour depuis l'écran d'arrivée,
    // on attend d'être à plus de 30 m pour réarmer l'arrivée.
    if (!_canCheckArrival) {
      if (distance > 30) {
        _canCheckArrival = true;
      }
      return;
    }

    if (_arrived || distance > 15 || !mounted) {
      return;
    }

    _arrived = true;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, animation, __) {
          return FadeTransition(
            opacity: animation,
            child: ArrivalScreen(
              distance: distance,
            ),
          );
        },
      ),
    );
  }

  Future<void> _initLocation() async {
    try {
      final firstPosition = await locationService.getCurrentPosition();

      if (!mounted) return;

      await compassService.setLocation(
        firstPosition.latitude,
        firstPosition.longitude,
      );

      setState(() {
        position = firstPosition;

        bearing = calculateBearing(
          position!.latitude,
          position!.longitude,
          cathedralLat,
          cathedralLng,
        );

        _updateAngle();
      });

      final distance = distanceToCathedral(
        firstPosition.latitude,
        firstPosition.longitude,
        cathedralLat,
        cathedralLng,
      );

      _checkArrival(distance);

      _positionSubscription =
          locationService.getPositionStream().listen((newPosition) async {
        if (!mounted || _arrived) return;

        await compassService.setLocation(
          newPosition.latitude,
          newPosition.longitude,
        );

        if (!mounted || _arrived) return;

        setState(() {
          position = newPosition;

          bearing = calculateBearing(
            position!.latitude,
            position!.longitude,
            cathedralLat,
            cathedralLng,
          );

          _updateAngle();
        });

        final distance = distanceToCathedral(
          newPosition.latitude,
          newPosition.longitude,
          cathedralLat,
          cathedralLng,
        );

        _checkArrival(distance);
      });

      _headingSubscription =
          compassService.getHeading().listen((value) {
        if (!mounted || _arrived) return;

        setState(() {
          heading = value;

          if (heading < 0) {
            heading += 360;
          }

          _updateAngle();
          });
      });
    } catch (e) {
        debugPrint(e.toString());

        if (!mounted) return;

        setState(() {
          _locationError = true;
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    double? distance;

    if (position != null) {
      distance = distanceToCathedral(
        position!.latitude,
        position!.longitude,
        cathedralLat,
        cathedralLng,
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 20,
          ),
          child: Column(
            children: [
              //------------------------------------
              // Logo
              //------------------------------------

              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        transitionDuration:
                            const Duration(milliseconds: 350),
                        reverseTransitionDuration:
                            const Duration(milliseconds: 250),
                        pageBuilder: (_, animation, __) {
                          return FadeTransition(
                            opacity: animation,
                            child: const AboutScreen(),
                          );
                        },
                      ),
                    );
                  },
                  child: Hero(
                    tag: "cathedral_logo",
                    child: Transform.translate(
                      offset: const Offset(30, 0),
                        child: Image.asset(
                          "assets/logo.png",
                          height: 80,
                        ),
                    ),
                  ),
                ),
              ),

              const Spacer(),

              //------------------------------------
              // Flèche
              //------------------------------------

              CompassWidget(
                angle: currentAngle,
              ),

              const SizedBox(height: 40),

              //------------------------------------
              // Distance
              //------------------------------------

              if (_locationError) ...[
                Text(
                  "Localisation nécessaire",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text(context),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Active la localisation pour utiliser la boussole.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.secondary(context),
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _locationError = false;
                    });

                    _initLocation();
                  },
                  child: const Text("Réessayer"),
                ),
              ] else ...[
                Text(
                  position == null
                      ? "Recherche..."
                      : distance! >= 1000
                          ? "${(distance / 1000).toStringAsFixed(1)} km"
                          : "${distance.round()} m",
                  style: TextStyle(
                    fontSize: position == null ? 42 : 54,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text(context),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  _message(distance),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.secondary(context),
                    fontSize: 20,
                  ),
                ),
              ],

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  String _message(double? distance) {
    if (distance == null) {
      return "Recherche du GPS...";
    }

    if (distance > 20000) {
      return "Tu es très loin.";
    }

    if (distance > 5000) {
      return "Tu te rapproches.";
    }

    if (distance > 2000) {
      return "Continue comme ça.";
    }

    if (distance > 500) {
      return "Tu chauffes.";
    }

    if (distance > 50) {
      return "Lève les yeux.";
    }

    return "Tu y es.";
  }
}