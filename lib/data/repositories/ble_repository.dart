import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/entities/ble_issue.dart';
import '../models/ble_device_model.dart';

class BleRepository {
  /// Status adapter Bluetooth (true = menyala). Dipakai untuk mendeteksi
  /// Bluetooth dimatikan user saat scan berjalan.
  Stream<bool> get adapterOn => FlutterBluePlus.adapterState
      .map((state) => state == BluetoothAdapterState.on);

  /// Status scan (true = sedang scanning).
  Stream<bool> get isScanning => FlutterBluePlus.isScanning;

  /// Hasil scan, sudah dipetakan ke model kita.
  Stream<List<BleDeviceModel>> get devices =>
      FlutterBluePlus.scanResults.map((results) => results.map(_toModel).toList());

  /// Cek semua syarat sebelum scan. Return null jika aman.
  Future<BleIssue?> checkPrerequisites() async {
    if (!await FlutterBluePlus.isSupported) return BleIssue.unsupported;

    final statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse, // dibutuhkan Android 11 ke bawah
    ].request();

    final scan = statuses[Permission.bluetoothScan]!;
    if (scan.isPermanentlyDenied) return BleIssue.permissionPermanentlyDenied;
    if (!scan.isGranted) return BleIssue.permissionDenied;

    final state = await FlutterBluePlus.adapterState.first;
    if (state != BluetoothAdapterState.on) return BleIssue.bluetoothOff;

    return null;
  }

  Future<void> startScan() async {
    await FlutterBluePlus.startScan(
      androidScanMode: AndroidScanMode.lowLatency,
      continuousUpdates: true, // RSSI terus diperbarui
      removeIfGone: const Duration(seconds: 5), // hilang dari list jika tak terdengar
    );
  }

  Future<void> stopScan() => FlutterBluePlus.stopScan();

  Future<void> openSettings() => openAppSettings();

  BleDeviceModel _toModel(ScanResult r) {
    final advName = r.advertisementData.advName;
    return BleDeviceModel(
      id: r.device.remoteId.str,
      name: advName.isNotEmpty ? advName : r.device.platformName,
      rssi: r.rssi,
      lastSeen: DateTime.now(),
    );
  }
}