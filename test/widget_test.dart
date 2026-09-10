import 'package:flutter_test/flutter_test.dart';
import 'package:ou_est_la_cathe/utils/angle.dart';
import 'package:ou_est_la_cathe/utils/bearing.dart';
import 'package:ou_est_la_cathe/utils/cathedral.dart';
import 'package:ou_est_la_cathe/utils/distance.dart';

void main() {
  group('Orientation vers la cathédrale', () {
    test('normalise la rotation par le chemin le plus court', () {
      expect(normalizeAngle(350, 10), 370);
      expect(normalizeAngle(10, 350), -10);
    });

    test('calcule le relèvement depuis le sud de la cathédrale', () {
      final bearing = calculateBearing(
        cathedralLat - 0.01,
        cathedralLng,
        cathedralLat,
        cathedralLng,
      );

      expect(bearing, closeTo(0, 0.1));
    });

    test('retourne une distance nulle aux coordonnées de la cathédrale', () {
      final distance = distanceToCathedral(
        cathedralLat,
        cathedralLng,
        cathedralLat,
        cathedralLng,
      );

      expect(distance, 0);
    });
  });
}
