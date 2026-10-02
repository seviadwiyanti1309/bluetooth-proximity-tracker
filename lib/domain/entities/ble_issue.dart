enum BleIssue {
  unsupported('Perangkat tidak mendukung Bluetooth'),
  permissionDenied('Izin Bluetooth ditolak'),
  permissionPermanentlyDenied(
      'Izin ditolak permanen, aktifkan lewat pengaturan aplikasi'),
  bluetoothOff('Bluetooth sedang nonaktif');

  final String message;
  const BleIssue(this.message);
}