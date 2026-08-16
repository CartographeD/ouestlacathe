import 'package:geolocator/geolocator.dart';

double distanceToCathedral(
  double latitude,
  double longitude,
  double cathedralLat,
  double cathedralLng,
) {
  return Geolocator.distanceBetween(
    latitude,
    longitude,
    cathedralLat,
    cathedralLng,
  );
}