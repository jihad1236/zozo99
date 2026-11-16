import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:zozo99/core/common/styles/global_text_style.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/core/utils/constants/icon_path.dart';
import 'package:zozo99/core/utils/constants/sizer.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080B10),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Splash Background Artwork
          Image.asset(
            IconPath.splashBg,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF160A10), Color(0xFF080B10)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // 2. Luxury Dark Vignette Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.35),
                  Colors.black.withValues(alpha: 0.70),
                  const Color(0xFF080B10).withValues(alpha: 0.96),
                ],
                stops: const [0.0, 0.55, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // 3. Central Animated Logo & Brand Typography
          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1100),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value.clamp(0.0, 1.0),
                  child: Transform.scale(
                    scale: 0.85 + (0.15 * value),
                    child: child,
                  ),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // High-Res App Logo with Golden Glow
                  Container(
                    width: 135.w,
                    height: 135.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.gold.withValues(alpha: 0.35),
                          blurRadius: 40,
                          spreadRadius: 6,
                        ),
                        BoxShadow(
                          color: AppColors.emeraldGreen.withValues(alpha: 0.25),
                          blurRadius: 60,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      IconPath.appLogo,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF141923),
                        ),
                        child: Icon(Icons.sports_esports_rounded, size: 54.sp, color: AppColors.gold),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Brand Name: ZOZO 99
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'ZOZO',
                        style: AppTextStyle().boldTextStyle(
                          fontSize: 34.sp,
                          color: Colors.white,
                          letterSpacing: 3.5,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '99',
                        style: AppTextStyle().boldTextStyle(
                          fontSize: 34.sp,
                          color: const Color(0xFFFF3B30),
                          letterSpacing: 3.5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),

                  // Tagline
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141923).withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      'PREMIER ONLINE GAMING & CASINO',
                      style: AppTextStyle().mediumTextStyle(
                        fontSize: 10.sp,
                        color: AppColors.gold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. Bottom Loading Spinner & Regulatory Notice
          Positioned(
            left: 0,
            right: 0,
            bottom: 36.h,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LoadingAnimationWidget.staggeredDotsWave(
                  color: AppColors.emeraldGreen,
                  size: 34.w,
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(color: Colors.red.withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        '18+',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Official Licensed • Provably Fair Gaming',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 10.sp,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
