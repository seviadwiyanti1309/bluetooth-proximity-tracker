import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/injection.dart';
import '../../core/theme/zone_color.dart';
import '../../data/models/ble_device_model.dart';
import 'radar_cubit.dart';
import 'radar_painter.dart';
import 'radar_state.dart';

class RadarPage extends StatelessWidget {
  final BleDeviceModel device;
  const RadarPage({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RadarCubit>(param1: device),
      child: Scaffold(
        appBar: AppBar(title: Text(device.displayName)),
        body: const _RadarBody(),
      ),
    );
  }
}

class _RadarBody extends StatelessWidget {
  const _RadarBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RadarCubit, RadarState>(
      builder: (context, state) {
        final color = state.zone.color;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(end: state.proximity),
                  duration: const Duration(milliseconds: 400),
                  builder: (_, value, _) => CustomPaint(
                    painter: RadarPainter(
                      proximity: value,
                      color: color,
                      lost: state.isLost,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Chip(
                backgroundColor: color.withValues(alpha: 0.2),
                label: Text(state.zone.label,
                    style: TextStyle(
                        color: color, fontWeight: FontWeight.bold)),
              ),
              Text(state.distanceText,
                  style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    _row('ID / MAC', state.device.id),
                    _row('RSSI (halus)', '${state.rssi} dBm'),
                    _row('RSSI (mentah)', '${state.rawRssi} dBm'),
                    _row('Rentang zona', state.zone.rangeText),
                    _row('Stabilitas', state.stability),
                    _row('Status', state.isLost ? 'Terputus' : 'Terhubung'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _row(String k, String v) => ListTile(
        dense: true,
        title: Text(k),
        trailing: Text(v, style: const TextStyle(fontWeight: FontWeight.w600)),
      );
}