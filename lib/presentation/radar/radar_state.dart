import 'dart:math';
import 'package:equatable/equatable.dart';
import '../../core/utils/rssi_helper.dart';
import '../../data/models/ble_device_model.dart';
import '../../domain/entities/signal_zone.dart';

class RadarState extends Equatable {
  final BleDeviceModel device;
  final double smoothedRssi;
  final int rawRssi;
  final List<int> history; // RSSI mentah terakhir
  final bool isLost;

  const RadarState({
    required this.device,
    required this.smoothedRssi,
    required this.rawRssi,
    this.history = const [],
    this.isLost = false,
  });

  factory RadarState.initial(BleDeviceModel d) => RadarState(
        device: d,
        smoothedRssi: d.rssi.toDouble(),
        rawRssi: d.rssi,
        history: [d.rssi],
      );

  int get rssi => smoothedRssi.round();
  SignalZone get zone => isLost ? SignalZone.lost : RssiHelper.zoneOf(rssi);
  String get distanceText => isLost ? 'Terputus' : RssiHelper.formatDistance(rssi);

  /// 0.0 = sangat dekat (tengah radar), 1.0 = batas jangkauan.
  double get proximity =>
      isLost ? 1.0 : ((-10 - smoothedRssi) / 80).clamp(0.0, 1.0);

  /// Stabilitas dari simpangan baku RSSI mentah.
  String get stability {
    if (history.length < 5) return 'Mengukur...';
    final mean = history.reduce((a, b) => a + b) / history.length;
    final variance =
        history.map((r) => pow(r - mean, 2)).reduce((a, b) => a + b) /
            history.length;
    final sd = sqrt(variance);
    if (sd < 3) return 'Stabil';
    if (sd < 6) return 'Cukup stabil';
    return 'Fluktuatif';
  }

  RadarState copyWith({
    double? smoothedRssi,
    int? rawRssi,
    List<int>? history,
    bool? isLost,
  }) {
    return RadarState(
      device: device,
      smoothedRssi: smoothedRssi ?? this.smoothedRssi,
      rawRssi: rawRssi ?? this.rawRssi,
      history: history ?? this.history,
      isLost: isLost ?? this.isLost,
    );
  }

  @override
  List<Object?> get props => [device, smoothedRssi, rawRssi, history, isLost];
}