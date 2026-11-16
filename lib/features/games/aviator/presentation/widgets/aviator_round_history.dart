import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zozo99/core/utils/constants/sizer.dart';
import 'package:zozo99/features/games/aviator/controllers/aviator_controller.dart';

class AviatorRoundHistory extends StatelessWidget {
  final AviatorController controller;

  const AviatorRoundHistory({super.key, required this.controller});

  Color _getMultiplierColor(double val) {
    if (val < 2.0) {
      return const Color(0xFF1E88E5); // Blue
    } else if (val < 10.0) {
      return const Color(0xFF9C27B0); // Purple
    } else if (val < 50.0) {
      return const Color(0xFFE91E63); // Hot Pink
    } else {
      return const Color(0xFFFFB300); // Gold
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFF121620),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF1E2533)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with "ROUND HISTORY" & Clock icon
          Row(
            children: [
              Text(
                'ROUND HISTORY',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
              const Spacer(),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Icon(Icons.history_rounded, size: 16.sp, color: Colors.white54),
                  Container(
                    width: 6.w,
                    height: 6.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE51438),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 6.h),

          // Horizontal scrollable history chips
          Obx(() {
            final list = controller.recentCrashMultipliers;
            return SizedBox(
              height: 26.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: list.length,
                separatorBuilder: (context, index) => SizedBox(width: 6.w),
                itemBuilder: (context, index) {
                  final m = list[index];
                  final color = _getMultiplierColor(m);

                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: color.withValues(alpha: 0.5), width: 1.0),
                    ),
                    child: Center(
                      child: Text(
                        '${m.toStringAsFixed(2)}x',
                        style: TextStyle(
                          color: color,
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
