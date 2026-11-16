import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zozo99/core/common/styles/global_text_style.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/core/utils/constants/icon_path.dart';
import 'package:zozo99/core/utils/constants/sizer.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Back Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => Get.back(),
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.emeraldGreen.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: AppColors.emeraldGreen.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6.w,
                    height: 6.w,
                    decoration: const BoxDecoration(
                      color: AppColors.emeraldGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    '256-BIT SSL SECURE',
                    style: TextStyle(
                      color: AppColors.emeraldGreen,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // Glowing App Logo
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.4),
                blurRadius: 30,
                spreadRadius: 4,
              ),
              BoxShadow(
                color: AppColors.emeraldGreen.withValues(alpha: 0.2),
                blurRadius: 45,
                spreadRadius: 6,
              ),
            ],
          ),
          child: Image.asset(IconPath.appLogo, fit: BoxFit.contain),
        ),
        SizedBox(height: 12.h),

        // Brand Name
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ZOZO',
              style: AppTextStyle().boldTextStyle(
                fontSize: 26.sp,
                color: Colors.white,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              '99',
              style: AppTextStyle().boldTextStyle(
                fontSize: 26.sp,
                color: const Color(0xFFFF3B30),
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          'Play with live credits & unlock VIP rewards',
          style: TextStyle(
            color: Colors.white60,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
