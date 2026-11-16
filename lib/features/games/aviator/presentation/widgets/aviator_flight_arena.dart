import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zozo99/core/models/betting_models.dart';
import 'package:zozo99/core/utils/constants/icon_path.dart';
import 'package:zozo99/core/utils/constants/sizer.dart';
import 'package:zozo99/features/games/aviator/controllers/aviator_controller.dart';
import 'package:zozo99/features/games/aviator/presentation/widgets/aviator_canvas_painter.dart';

class AviatorFlightArena extends StatelessWidget {
  final AviatorController controller;

  const AviatorFlightArena({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFF090C12),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFF1B2232), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          return Obx(() {
            final round = controller.round.value;
            final multiplier = controller.liveMultiplier.value;
            final status = round.status;

            // Compute plane position and flight angle
            final progress = ((multiplier - 1.0) / 7.5).clamp(0.08, 0.92);
            final planeX = 12 + (width - 55) * progress;
            final planeY = (height - 24) - (height - 65) * pow(progress, 0.78);

            // Compute tangent angle for natural flight tilt (-15 to -35 degrees)
            final flightAngle = status == RoundStatus.running ? -0.25 - (progress * 0.15) : 0.0;

            return Stack(
              fit: StackFit.expand,
              children: [
                // 1. Radar Ray Canvas & Glowing Path
                CustomPaint(
                  size: Size(width, height),
                  painter: AviatorCanvasPainter(
                    multiplier: multiplier,
                    status: status,
                  ),
                ),

                // 2. Central Big Multiplier / Status
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (status == RoundStatus.running) ...[
                        Text(
                          '${multiplier.toStringAsFixed(2)}x',
                          style: TextStyle(
                            fontSize: 48.sp,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.5,
                            shadows: const [
                              Shadow(color: Colors.black87, blurRadius: 18, offset: Offset(0, 4)),
                            ],
                          ),
                        ),
                      ] else if (status == RoundStatus.crashed) ...[
                        Text(
                          'FLEW AWAY!',
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFFE51438),
                            letterSpacing: 1.5,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '${round.crashMultiplier.toStringAsFixed(2)}x',
                          style: TextStyle(
                            fontSize: 38.sp,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFFE51438),
                            letterSpacing: -0.5,
                          ),
                        ),
                      ] else ...[
                        Text(
                          'WAITING FOR NEXT ROUND',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFFFB800),
                            letterSpacing: 1.0,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        SizedBox(
                          width: 140.w,
                          child: const LinearProgressIndicator(
                            color: Color(0xFFE51438),
                            backgroundColor: Color(0xFF222B3D),
                            minHeight: 4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // 3. Realistic Monoplane Asset (Animated with trajectory)
                if (status == RoundStatus.running)
                  Positioned(
                    left: (planeX - 22.w).clamp(0, width - 48.w),
                    top: (planeY - 22.w).clamp(0, height - 48.w),
                    child: Transform.rotate(
                      angle: flightAngle,
                      child: Container(
                        width: 48.w,
                        height: 48.w,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE51438).withValues(alpha: 0.5),
                              blurRadius: 18,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          IconPath.aviator,
                          color: const Color(0xFFE51438),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          });
        },
      ),
    );
  }
}
