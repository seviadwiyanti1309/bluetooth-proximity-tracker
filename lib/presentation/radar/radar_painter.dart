import 'dart:math';
import 'package:flutter/material.dart';

class RadarPainter extends CustomPainter {
  final double proximity; // 0..1
  final Color color;
  final bool lost;

  RadarPainter({
    required this.proximity,
    required this.color,
    required this.lost,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final maxR = size.shortestSide / 2 - 8;

    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = Colors.grey.withValues(alpha: 0.4);
    for (var i = 1; i <= 5; i++) {
      canvas.drawCircle(center, maxR * i / 5, ring);
    }
    canvas.drawLine(Offset(center.dx - maxR, center.dy),
        Offset(center.dx + maxR, center.dy), ring);
    canvas.drawLine(Offset(center.dx, center.dy - maxR),
        Offset(center.dx, center.dy + maxR), ring);

    // Titik "kamu" di tengah
    canvas.drawCircle(center, 6, Paint()..color = Colors.indigo);

    // Posisi target (sudut tetap agar tidak melompat)
    const angle = -pi / 4;
    final r = maxR * proximity;
    final target = center + Offset(cos(angle), sin(angle)) * r;

    if (!lost) {
      canvas.drawLine(
          center,
          target,
          Paint()
            ..color = color.withValues(alpha: 0.5)
            ..strokeWidth = 2);
      canvas.drawCircle(
          target, 22, Paint()..color = color.withValues(alpha: 0.25));
    }
    canvas.drawCircle(target, 10, Paint()..color = color);
  }

  @override
  bool shouldRepaint(RadarPainter old) =>
      old.proximity != proximity || old.color != color || old.lost != lost;
}