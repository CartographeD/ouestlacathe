import 'package:flutter/services.dart';

class CompassService {
  static const EventChannel _compassChannel =
      EventChannel('ouestlacathe/compass_stream');

  static const MethodChannel _methodChannel =
      MethodChannel('ouestlacathe/compass');

  Stream<double> getHeading() {
    return _compassChannel
        .receiveBroadcastStream()
        .map((value) => (value as num).toDouble());
  }

  Future<void> setLocation(
    double latitude,
    double longitude,
  ) async {
    await _methodChannel.invokeMethod(
      'setLocation',
      {
        'latitude': latitude,
        'longitude': longitude,
      },
    );
  }
}