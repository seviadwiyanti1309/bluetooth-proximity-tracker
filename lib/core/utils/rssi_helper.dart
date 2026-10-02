import '../../domain/entities/signal_zone.dart';

class RssiHelper {
  RssiHelper._();

  static const List<(int, double)> _points = [
    (-10, 0.1),
    (-30, 1.0),
    (-50, 3.0),
    (-70, 10.0),
    (-80, 20.0),
    (-90, 30.0),
  ];

  static SignalZone zoneOf(int rssi) {
    if (rssi < -90) return SignalZone.lost;
    if (rssi < -80) return SignalZone.veryWeak;
    if (rssi < -70) return SignalZone.weak;
    if (rssi < -50) return SignalZone.fair;
    if (rssi < -30) return SignalZone.strong;
    return SignalZone.veryStrong;
  }

  static double estimateDistance(int rssi) {
    if (rssi >= _points.first.$1) return _points.first.$2;
    if (rssi <= _points.last.$1) return _points.last.$2;

    for (var i = 0; i < _points.length - 1; i++) {
      final (r1, d1) = _points[i];
      final (r2, d2) = _points[i + 1];
      if (rssi <= r1 && rssi >= r2) {
        final t = (r1 - rssi) / (r1 - r2);
        return d1 + t * (d2 - d1);
      }
    }
    return _points.last.$2;
  }

  static String formatDistance(int rssi) {
    if (zoneOf(rssi) == SignalZone.lost) return 'Terputus';
    final m = estimateDistance(rssi);
    if (m > 20) return '> 20 m';
    return '${m.toStringAsFixed(1)} m';
  }
}