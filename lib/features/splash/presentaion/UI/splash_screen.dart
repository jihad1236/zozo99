import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:zozo99/core/common/styles/global_text_style.dart';
import 'package:zozo99/core/utils/constants/app_texts.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/core/utils/constants/sizer.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1F1018), Color(0xFF0F1117)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            Container(
              padding: EdgeInsets.all(22.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.aviatorRed, AppColors.gold],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.aviatorRed.withValues(alpha: 0.5),
                    blurRadius: 36,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Icon(Icons.sports_esports_rounded, size: 54.sp, color: Colors.white),
            ),
            SizedBox(height: 24.h),
            Text(
              AppText.appName,
              style: AppTextStyle().boldTextStyle(
                fontSize: 38.sp,
                color: Colors.white,
                letterSpacing: 3.0,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              AppText.appDescription,
              style: AppTextStyle().mediumTextStyle(
                fontSize: 13.sp,
                color: AppColors.gold,
                letterSpacing: 1.0,
              ),
            ),
            const Spacer(flex: 2),
            Padding(
              padding: EdgeInsets.only(bottom: 50.h),
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: AppColors.aviatorRed,
                size: 38.w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
