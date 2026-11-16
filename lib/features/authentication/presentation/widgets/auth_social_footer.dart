import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/core/utils/constants/sizer.dart';
import 'package:zozo99/routes/app_routes.dart';

class AuthSocialFooter extends StatelessWidget {
  const AuthSocialFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.12))),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Text(
                'OR QUICK ACCESS',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.12))),
          ],
        ),
        SizedBox(height: 14.h),

        // Continue as Guest Pill Button
        InkWell(
          onTap: () {
            Get.offAllNamed(AppRoute.bottomNavScreen);
          },
          borderRadius: BorderRadius.circular(14.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.explore_rounded, color: AppColors.emeraldGreen, size: 18.sp),
                SizedBox(width: 8.w),
                Text(
                  'Continue Browsing as Guest',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16.h),

        // Compliance Footer
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(color: Colors.red.withValues(alpha: 0.4)),
              ),
              child: Text(
                '18+',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              'Licensed under Curacao eGaming • Gamble Responsibly',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 9.5.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
