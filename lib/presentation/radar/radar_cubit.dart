import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/ble_device_model.dart';
import '../../data/repositories/ble_repository.dart';
import 'radar_state.dart';

class RadarCubit extends Cubit<RadarState> {
  static const _alpha = 0.3; // makin kecil makin halus
  static const _lostAfter = Duration(seconds: 6);
  static const _maxHistory = 20;

  final BleRepository _repo;
  late final StreamSubscription _sub;
  late final Timer _timer;
  DateTime _lastHeard = DateTime.now();

  RadarCubit(this._repo, BleDeviceModel device)
      : super(RadarState.initial(device)) {
    _sub = _repo.devices.listen(_onDevices);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _checkLost());
  }

  void _onDevices(List<BleDeviceModel> list) {
    final matches = list.where((d) => d.id == state.device.id);
    if (matches.isEmpty) return;

    final raw = matches.first.rssi;
    _lastHeard = DateTime.now();

    // Exponential moving average
    final smoothed = state.isLost
        ? raw.toDouble()
        : _alpha * raw + (1 - _alpha) * state.smoothedRssi;

    final history = [...state.history, raw];
    if (history.length > _maxHistory) history.removeAt(0);

    emit(state.copyWith(
      smoothedRssi: smoothed,
      rawRssi: raw,
      history: history,
      isLost: false,
    ));
  }

  void _checkLost() {
    if (!state.isLost && DateTime.now().difference(_lastHeard) > _lostAfter) {
      emit(state.copyWith(isLost: true));
    }
  }

  @override
  Future<void> close() {
    _sub.cancel();
    _timer.cancel();
    return super.close();
  }
}