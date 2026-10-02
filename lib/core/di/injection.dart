import 'package:bluetooth_proximity_tracker/data/models/ble_device_model.dart';
import 'package:bluetooth_proximity_tracker/presentation/radar/radar_cubit.dart';
import 'package:get_it/get_it.dart';
import '../../data/repositories/ble_repository.dart';
import '../../presentation/scanner/scanner_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupDi() async {
  getIt.registerLazySingleton<BleRepository>(() => BleRepository());
  getIt.registerFactory<ScannerCubit>(() => ScannerCubit(getIt()));
  getIt.registerFactoryParam<RadarCubit, BleDeviceModel, void>(
    (device, _) => RadarCubit(getIt(), device));
}