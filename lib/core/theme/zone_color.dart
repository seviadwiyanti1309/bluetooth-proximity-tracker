import 'package:flutter/material.dart';
import '../../domain/entities/signal_zone.dart';

extension SignalZoneColor on SignalZone {
  Color get color => switch (this) {
        SignalZone.veryStrong => Colors.green,
        SignalZone.strong => Colors.lightGreen,
        SignalZone.fair => Colors.amber,
        SignalZone.weak => Colors.orange,
        SignalZone.veryWeak => Colors.deepOrange,
        SignalZone.lost => Colors.grey,
      };
}