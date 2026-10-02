import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/ble_repository.dart';
import '../../domain/entities/ble_issue.dart';
import 'scanner_state.dart';

class ScannerCubit extends Cubit<ScannerState> {
  final BleRepository _repo;
  late final StreamSubscription _devicesSub;
  late final StreamSubscription _scanningSub;
  late final StreamSubscription _adapterSub;

  ScannerCubit(this._repo) : super(const ScannerState()) {
    _devicesSub = _repo.devices.listen(
      (list) => emit(state.copyWith(devices: list)),
    );
    _scanningSub = _repo.isScanning.listen(
      (scanning) => emit(state.copyWith(isScanning: scanning)),
    );
    _adapterSub = _repo.adapterOn.listen(_onAdapterChanged);
  }

  Future<void> startScan() async {
    final issue = await _repo.checkPrerequisites();
    if (issue != null) {
      emit(state.copyWith(issue: issue));
      return;
    }
    emit(state.copyWith(clearIssue: true));
    try {
      await _repo.startScan();
    } catch (_) {
      emit(state.copyWith(issue: BleIssue.bluetoothOff));
    }
  }

  Future<void> stopScan() => _repo.stopScan();

  void setQuery(String value) => emit(state.copyWith(query: value));

  void setMinRssi(int value) => emit(state.copyWith(minRssi: value));

  Future<void> openSettings() => _repo.openSettings();

  /// Bluetooth dimatikan user saat scan berjalan.
  void _onAdapterChanged(bool on) {
    if (!on) {
      emit(state.copyWith(issue: BleIssue.bluetoothOff, isScanning: false));
    } else if (state.issue == BleIssue.bluetoothOff) {
      emit(state.copyWith(clearIssue: true));
    }
  }

  @override
  Future<void> close() {
    _devicesSub.cancel();
    _scanningSub.cancel();
    _adapterSub.cancel();
    _repo.stopScan();
    return super.close();
  }
}