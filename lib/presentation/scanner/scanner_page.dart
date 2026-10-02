import 'package:bluetooth_proximity_tracker/presentation/radar/radar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/ble_issue.dart';
import 'scanner_cubit.dart';
import 'scanner_state.dart';
import 'widgets/device_tile.dart';

class ScannerPage extends StatelessWidget {
  const ScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ScannerCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('BLE Scanner')),
      body: Column(
        children: [
          const _IssueBanner(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              onChanged: cubit.setQuery,
              decoration: const InputDecoration(
                hintText: 'Cari nama atau MAC address',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          const _RssiFilter(),
          const Expanded(child: _DeviceList()),
        ],
      ),
      floatingActionButton: BlocBuilder<ScannerCubit, ScannerState>(
        buildWhen: (p, c) => p.isScanning != c.isScanning,
        builder: (context, state) => FloatingActionButton.extended(
          onPressed: state.isScanning ? cubit.stopScan : cubit.startScan,
          icon: Icon(state.isScanning ? Icons.stop : Icons.play_arrow),
          label: Text(state.isScanning ? 'Stop' : 'Start'),
        ),
      ),
    );
  }
}

class _IssueBanner extends StatelessWidget {
  const _IssueBanner();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScannerCubit, ScannerState>(
      buildWhen: (p, c) => p.issue != c.issue,
      builder: (context, state) {
        final issue = state.issue;
        if (issue == null) return const SizedBox.shrink();
        final cubit = context.read<ScannerCubit>();
        return MaterialBanner(
          content: Text(issue.message),
          leading: const Icon(Icons.warning_amber_rounded),
          actions: [
            if (issue == BleIssue.permissionPermanentlyDenied)
              TextButton(
                  onPressed: cubit.openSettings,
                  child: const Text('Buka Pengaturan'))
            else if (issue != BleIssue.unsupported)
              TextButton(
                  onPressed: cubit.startScan, child: const Text('Coba Lagi')),
          ],
        );
      },
    );
  }
}

class _RssiFilter extends StatelessWidget {
  const _RssiFilter();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScannerCubit, ScannerState>(
      buildWhen: (p, c) => p.minRssi != c.minRssi,
      builder: (context, state) {
        final off = state.minRssi <= ScannerState.noFilter;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(off ? 'Sinyal: semua' : 'Sinyal ≥ ${state.minRssi} dBm'),
              Expanded(
                child: Slider(
                  min: -100,
                  max: -30,
                  divisions: 70,
                  value: state.minRssi.toDouble(),
                  onChanged: (v) =>
                      context.read<ScannerCubit>().setMinRssi(v.round()),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DeviceList extends StatelessWidget {
  const _DeviceList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScannerCubit, ScannerState>(
      builder: (context, state) {
        final devices = state.visibleDevices;
        if (devices.isEmpty) {
          return Center(
            child: Text(state.isScanning
                ? 'Mencari perangkat...'
                : 'Tekan Start untuk memindai'),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.only(bottom: 88),
          itemCount: devices.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, i) => DeviceTile(
            device: devices[i],
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RadarPage(device: devices[i]),
              ),
            ),
          ),
        );
      },
    );
  }
}