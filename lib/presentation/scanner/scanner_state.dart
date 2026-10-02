import 'package:equatable/equatable.dart';
import '../../data/models/ble_device_model.dart';
import '../../domain/entities/ble_issue.dart';

class ScannerState extends Equatable {
  static const int noFilter = -100;

  final List<BleDeviceModel> devices;
  final bool isScanning;
  final String query;
  final int minRssi; // -100 = filter nonaktif
  final BleIssue? issue;

  const ScannerState({
    this.devices = const [],
    this.isScanning = false,
    this.query = '',
    this.minRssi = noFilter,
    this.issue,
  });

  /// Filter (nama / MAC / RSSI minimum), lalu urutkan RSSI terkuat di atas.
  List<BleDeviceModel> get visibleDevices {
    final q = query.trim().toLowerCase();
    final list = devices.where((d) {
      final matchQuery = q.isEmpty ||
          d.displayName.toLowerCase().contains(q) ||
          d.id.toLowerCase().contains(q);
      final matchRssi = minRssi <= noFilter || d.rssi >= minRssi;
      return matchQuery && matchRssi;
    }).toList();
    list.sort((a, b) => b.rssi.compareTo(a.rssi));
    return list;
  }

  ScannerState copyWith({
    List<BleDeviceModel>? devices,
    bool? isScanning,
    String? query,
    int? minRssi,
    BleIssue? issue,
    bool clearIssue = false,
  }) {
    return ScannerState(
      devices: devices ?? this.devices,
      isScanning: isScanning ?? this.isScanning,
      query: query ?? this.query,
      minRssi: minRssi ?? this.minRssi,
      issue: clearIssue ? null : (issue ?? this.issue),
    );
  }

  @override
  List<Object?> get props => [devices, isScanning, query, minRssi, issue];
}