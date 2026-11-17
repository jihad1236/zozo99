import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zozo99/core/common/styles/global_text_style.dart';
import 'package:zozo99/core/models/betting_models.dart';
import 'package:zozo99/core/repositories/betting_repository.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/core/utils/constants/icon_path.dart';
import 'package:zozo99/core/utils/constants/sizer.dart';
import 'package:zozo99/features/games/spin/controllers/spin_controller.dart';

class SpinScreen extends StatelessWidget {
  const SpinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<SpinController>()
        ? Get.find<SpinController>()
        : Get.put(SpinController());
    final repository = Get.find<BettingRepository>();

    return Scaffold(
      backgroundColor: const Color(0xFF0C0E14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF131722),
        elevation: 0,
        title: Row(
          children: [
            Image.asset(IconPath.fortuneWheel, width: 22.sp, height: 22.sp, fit: BoxFit.contain),
            SizedBox(width: 8.w),
            Text(
              'Lucky Fortune Wheel',
              style: AppTextStyle().boldTextStyle(fontSize: 18.sp, color: Colors.white),
            ),
          ],
        ),
        actions: [
          StreamBuilder<WalletModel?>(
            stream: repository.walletStream,
            initialData: repository.currentWallet,
            builder: (context, snapshot) {
              final credits = snapshot.data?.creditBalance ?? 0.0;
              return Container(
                margin: EdgeInsets.only(right: 14.w),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.darkSurface,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.bolt_rounded, color: AppColors.gold, size: 16.sp),
                    SizedBox(width: 4.w),
                    Text(
                      '${credits.toInt()} ⚡',
                      style: AppTextStyle().boldTextStyle(fontSize: 12.sp, color: Colors.white),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: ResponsiveLayout(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 16.h),
              Text(
                'SPIN & WIN JACKPOT',
                style: AppTextStyle().boldTextStyle(
                  fontSize: 18.sp,
                  color: AppColors.gold,
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Win free credits, multipliers and VIP points!',
                style: AppTextStyle().regularTextStyle(fontSize: 12.sp, color: AppColors.darkTextSecondary),
              ),
              SizedBox(height: 24.h),

              // Rotating Wheel Stack with Pointer wrapped in RepaintBoundary
              Center(
                child: RepaintBoundary(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer Glow Ring
                      Container(
                        width: 300.w,
                        height: 300.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.gold.withValues(alpha: 0.25),
                              blurRadius: 32,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),

                      // Animated Rotating Canvas
                      Obx(
                        () => Transform.rotate(
                          angle: controller.currentRotation.value,
                          child: CustomPaint(
                            size: Size(280.w, 280.w),
                            painter: _WheelPainter(segments: controller.segments),
                          ),
                        ),
                      ),

                      // Center Spin Button / Cap
                      Container(
                        width: 60.w,
                        height: 60.w,
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2C344A), Color(0xFF141724)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(color: AppColors.gold, width: 2.5),
                        ),
                        child: Center(
                          child: Image.asset(IconPath.fortuneWheel, fit: BoxFit.contain),
                        ),
                      ),

                      // Top Indicator Arrow
                      Positioned(
                        top: 0,
                        child: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                          size: 44.sp,
                          shadows: const [
                            Shadow(color: Colors.black, blurRadius: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 32.h),

            // Stake & Spin Action
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF161924),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: AppColors.darkBorder),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Spin Price',
                          style: AppTextStyle().mediumTextStyle(fontSize: 13.sp, color: AppColors.darkTextSecondary),
                        ),
                        Row(
                          children: [
                            Icon(Icons.bolt_rounded, color: AppColors.gold, size: 18.sp),
                            SizedBox(width: 4.w),
                            Obx(
                              () => Text(
                                '${controller.stake.value.toInt()} Credits',
                                style: AppTextStyle().boldTextStyle(fontSize: 14.sp, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Big Spin Button
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: ElevatedButton(
                        onPressed: controller.isSpinning.value ? null : controller.spinWheel,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.gold,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                          elevation: 8,
                          shadowColor: AppColors.gold.withValues(alpha: 0.5),
                        ),
                        child: controller.isSpinning.value
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    'SPINNING...',
                                    style: AppTextStyle().boldTextStyle(fontSize: 15.sp, color: Colors.black),
                                  ),
                                ],
                              )
                            : Text(
                                'SPIN WHEEL FOR ${controller.stake.value.toInt()} ⚡',
                                style: AppTextStyle().boldTextStyle(
                                  fontSize: 15.sp,
                                  color: Colors.black,
                                  letterSpacing: 1.2,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }
}

class _WheelPainter extends CustomPainter {
  final List<SpinSegment> segments;

  _WheelPainter({required this.segments});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final arcAngle = (2 * pi) / segments.length;

    for (int i = 0; i < segments.length; i++) {
      final startAngle = (i * arcAngle) - (pi / 2);
      final segment = segments[i];

      final paint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        arcAngle,
        true,
        paint,
      );

      final borderPaint = Paint()
        ..color = Colors.white24
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        arcAngle,
        true,
        borderPaint,
      );

      // Label Text
      canvas.save();
      final textAngle = startAngle + (arcAngle / 2);
      final textX = center.dx + (radius * 0.65) * cos(textAngle);
      final textY = center.dy + (radius * 0.65) * sin(textAngle);

      canvas.translate(textX, textY);
      canvas.rotate(textAngle + (pi / 2));

      final textSpan = TextSpan(
        text: segment.label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
