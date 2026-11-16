import 'dart:math';
import 'package:flutter/material.dart';
import 'package:zozo99/core/models/betting_models.dart';
import 'package:zozo99/core/utils/constants/colors.dart';

class AviatorCanvasPainter extends CustomPainter {
  final double multiplier;
  final RoundStatus status;

  AviatorCanvasPainter({
    required this.multiplier,
    required this.status,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Radiant Sunburst Background Rays (from bottom-left origin)
    final origin = Offset(0, size.height);
    final rayPaint = Paint()
      ..color = const Color(0xFF131722).withValues(alpha: 0.75)
      ..style = PaintingStyle.fill;

    final rayCount = 14;
    final maxRadius = sqrt(size.width * size.width + size.height * size.height) * 1.2;

    for (int i = 0; i < rayCount; i++) {
      if (i % 2 == 0) {
        final startAngle = (i / rayCount) * (pi / 2);
        final endAngle = ((i + 1) / rayCount) * (pi / 2);

        final path = Path()
          ..moveTo(origin.dx, origin.dy)
          ..lineTo(origin.dx + maxRadius * cos(startAngle), origin.dy - maxRadius * sin(startAngle))
          ..lineTo(origin.dx + maxRadius * cos(endAngle), origin.dy - maxRadius * sin(endAngle))
          ..close();

        canvas.drawPath(path, rayPaint);
      }
    }

    // 2. Dotted Axis Markers along bottom and left
    final dotPaint = Paint()
      ..color = const Color(0xFF2E3A52)
      ..style = PaintingStyle.fill;

    for (double x = 30; x < size.width; x += 36) {
      canvas.drawCircle(Offset(x, size.height - 8), 1.8, dotPaint);
    }
    for (double y = size.height - 30; y > 20; y -= 36) {
      canvas.drawCircle(Offset(8, y), 1.8, dotPaint);
    }

    if (status == RoundStatus.waiting) {
      return;
    }

    // 3. Flight Curve Coordinates
    // Normalized progress based on multiplier
    final progress = ((multiplier - 1.0) / 7.5).clamp(0.08, 0.92);

    final startPoint = Offset(12, size.height - 12);
    final endX = 12 + (size.width - 55) * progress;
    final endY = (size.height - 24) - (size.height - 65) * pow(progress, 0.78);
    final endPoint = Offset(endX, endY);

    final controlPoint = Offset(
      startPoint.dx + (endPoint.dx - startPoint.dx) * 0.52,
      startPoint.dy - (startPoint.dy - endPoint.dy) * 0.12,
    );

    // 4. Fill Area Under Curve (Rich Crimson Translucent Area)
    final fillPath = Path()
      ..moveTo(startPoint.dx, startPoint.dy)
      ..quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(endPoint.dx, size.height - 12)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFE51438).withValues(alpha: 0.55),
          const Color(0xFFE51438).withValues(alpha: 0.15),
          Colors.transparent,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // 5. Glowing Flight Line Trajectory
    final linePaint = Paint()
      ..color = status == RoundStatus.crashed
          ? const Color(0xFF555E70)
          : const Color(0xFFE51438)
      ..strokeWidth = 3.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final curvePath = Path()
      ..moveTo(startPoint.dx, startPoint.dy)
      ..quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);

    canvas.drawPath(curvePath, linePaint);

    // 6. Draw Crash Explosion or Trailing Flight Jet Flare
    if (status == RoundStatus.crashed) {
      final blastPaint = Paint()
        ..color = const Color(0xFFE51438).withValues(alpha: 0.7)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(endPoint, 16, blastPaint);

      final blastBorder = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2;
      canvas.drawCircle(endPoint, 24, blastBorder);
    } else {
      // High-glow flare behind the airplane
      final flarePaint = Paint()
        ..color = const Color(0xFFE51438).withValues(alpha: 0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);
      canvas.drawCircle(endPoint, 18, flarePaint);

      // Yellow core exhaust dot
      final corePaint = Paint()
        ..color = AppColors.gold
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(endPoint.dx - 10, endPoint.dy + 6), 4.5, corePaint);
    }
  }

  @override
  bool shouldRepaint(covariant AviatorCanvasPainter oldDelegate) {
    return oldDelegate.multiplier != multiplier || oldDelegate.status != status;
  }
}
