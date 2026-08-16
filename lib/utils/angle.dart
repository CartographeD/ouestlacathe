double normalizeAngle(double current, double target) {
  double diff = target - current;

  while (diff > 180) {
    diff -= 360;
  }

  while (diff < -180) {
    diff += 360;
  }

  return current + diff;
}