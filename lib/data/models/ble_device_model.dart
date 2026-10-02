import 'package:equatable/equatable.dart';
import '../../core/utils/rssi_helper.dart';
import '../../domain/entities/signal_zone.dart';

class BleDeviceModel extends Equatable {
  final String id; 
  final String name;
  final int rssi;
  final DateTime lastSeen;

  const BleDeviceModel({
    required this.id,
    required this.name,
    required this.rssi,
    required this.lastSeen,
  });

  String get displayName => name.isEmpty ? 'Unknown Device' : name;
  SignalZone get zone => RssiHelper.zoneOf(rssi);
  String get distanceText => RssiHelper.formatDistance(rssi);

  BleDeviceModel copyWith({String? name, int? rssi, DateTime? lastSeen}) {
    return BleDeviceModel(
      id: id,
      name: name ?? this.name,
      rssi: rssi ?? this.rssi,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }

  @override
  List<Object?> get props => [id, name, rssi, lastSeen];
}