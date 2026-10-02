import 'package:bluetooth_proximity_tracker/core/utils/rssi_helper.dart';
import 'package:bluetooth_proximity_tracker/domain/entities/signal_zone.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('zoneOf sesuai tabel PDF', () {
    expect(RssiHelper.zoneOf(-20), SignalZone.veryStrong);
    expect(RssiHelper.zoneOf(-40), SignalZone.strong);
    expect(RssiHelper.zoneOf(-60), SignalZone.fair);
    expect(RssiHelper.zoneOf(-75), SignalZone.weak);
    expect(RssiHelper.zoneOf(-85), SignalZone.veryWeak);
    expect(RssiHelper.zoneOf(-95), SignalZone.lost);
  });

  test('estimateDistance di titik tabel', () {
    expect(RssiHelper.estimateDistance(-30), closeTo(1.0, 0.01));
    expect(RssiHelper.estimateDistance(-50), closeTo(3.0, 0.01));
    expect(RssiHelper.estimateDistance(-70), closeTo(10.0, 0.01));
  });
}