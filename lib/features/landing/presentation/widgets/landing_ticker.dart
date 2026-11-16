import 'package:flutter/material.dart';
import 'package:zozo99/core/common/styles/global_text_style.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/core/utils/constants/sizer.dart';

class LandingTicker extends StatelessWidget {
  const LandingTicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFF10151E),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF1E2533)),
      ),
      child: Row(
        children: [
          Icon(Icons.volume_up_rounded, color: AppColors.emeraldGreen, size: 18.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'Available 24/7. You can deposit money anytime, day or night—easily, quickly, and securely. Instant credit conversions.',
              style: AppTextStyle().regularTextStyle(
                fontSize: 11.sp,
                color: const Color(0xFFBAC5D5),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
