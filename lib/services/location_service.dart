import 'package:geolocator/geolocator.dart';

class LocationService {

  Future<Position> getCurrentPosition() async {

    bool enabled = await Geolocator.isLocationServiceEnabled();

    if (!enabled) {
      throw Exception("GPS désactivé");
    }

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Permission refusée");
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
  }

  Stream<Position> getPositionStream() {

    return Geolocator.getPositionStream(

      locationSettings: const LocationSettings(

        accuracy: LocationAccuracy.best,

        distanceFilter: 2,

      ),

    );

  }

}