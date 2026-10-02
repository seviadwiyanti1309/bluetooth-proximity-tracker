import 'package:flutter/material.dart';
import '../../../core/theme/zone_color.dart';
import '../../../data/models/ble_device_model.dart';

class DeviceTile extends StatelessWidget {
  final BleDeviceModel device;
  final VoidCallback onTap;

  const DeviceTile({super.key, required this.device, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = device.zone.color;
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.2),
        child: Icon(Icons.bluetooth, color: color),
      ),
      title: Text(device.displayName),
      subtitle: Text('${device.id}\n${device.zone.label} • ${device.distanceText}'),
      isThreeLine: true,
      trailing: Text(
        '${device.rssi} dBm',
        style: TextStyle(fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}