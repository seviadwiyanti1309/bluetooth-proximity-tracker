import 'package:flutter/material.dart';
import 'core/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDi();
  runApp(const MaterialApp(
    home: Scaffold(body: Center(child: Text('BLE Proximity Tracker'))),
  ));
}