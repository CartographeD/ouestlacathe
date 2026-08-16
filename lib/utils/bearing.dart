import 'dart:math';

double calculateBearing(
  double startLat,
  double startLng,
  double endLat,
  double endLng,
) {
  final lat1 = startLat * pi / 180;
  final lon1 = startLng * pi / 180;

  final lat2 = endLat * pi / 180;
  final lon2 = endLng * pi / 180;

  final dLon = lon2 - lon1;

  final y = sin(dLon) * cos(lat2);

  final x = cos(lat1) * sin(lat2) -
      sin(lat1) * cos(lat2) * cos(dLon);

  final bearing = atan2(y, x);

  return (bearing * 180 / pi + 360) % 360;
}