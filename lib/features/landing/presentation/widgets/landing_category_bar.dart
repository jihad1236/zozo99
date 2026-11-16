import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zozo99/core/common/styles/global_text_style.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/core/utils/constants/icon_path.dart';
import 'package:zozo99/core/utils/constants/sizer.dart';
import 'package:zozo99/features/landing/controllers/landing_controller.dart';

class LandingCategoryBar extends StatelessWidget {
  final LandingController controller;

  const LandingCategoryBar({super.key, required this.controller});

  static final List<Map<String, dynamic>> categories = [
    {
      'name': 'Popular',
      'asset': IconPath.vip,
      'fallbackIcon': Icons.workspace_premium_rounded,
      'color': AppColors.gold,
    },
    {
      'name': 'Crash',
      'asset': IconPath.aviator,
      'fallbackIcon': Icons.rocket_launch_rounded,
      'color': AppColors.aviatorRed,
    },
    {
      'name': 'Slots',
      'asset': IconPath.diamond,
      'fallbackIcon': Icons.casino_rounded,
      'color': AppColors.gold,
    },
    {
      'name': 'Casino',
      'asset': IconPath.fortuneWheel,
      'fallbackIcon': Icons.style_rounded,
      'color': AppColors.neonCyan,
    },
    {
      'name': 'Arcade',
      'asset': IconPath.joystick,
      'fallbackIcon': Icons.sports_esports_rounded,
      'color': AppColors.neonPurple,
    },
    {
      'name': 'Table',
      'asset': IconPath.coin,
      'fallbackIcon': Icons.album_rounded,
      'color': AppColors.neonGreen,
    },
    {
      'name': 'Sports',
      'asset': null,
      'fallbackIcon': Icons.sports_cricket_rounded,
      'color': Colors.orangeAccent,
    },
    {
      'name': 'Fishing',
      'asset': null,
      'fallbackIcon': Icons.phishing_rounded,
      'color': Colors.lightBlueAccent,
    },
    {
      'name': 'Lottery',
      'asset': null,
      'fallbackIcon': Icons.confirmation_number_rounded,
      'color': Colors.pinkAccent,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final name = cat['name'] as String;
          final asset = cat['asset'] as String?;
          final fallbackIcon = cat['fallbackIcon'] as IconData;
          final iconColor = cat['color'] as Color;

          return Obx(() {
            final isSelected = controller.selectedCategory.value == name;

            return InkWell(
              onTap: () => controller.selectCategory(name),
              borderRadius: BorderRadius.circular(12.r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 66.w,
                padding: EdgeInsets.symmetric(vertical: 6.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.emeraldGreen : const Color(0xFF141923),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSelected ? AppColors.emeraldGreen : const Color(0xFF1E2533),
                    width: isSelected ? 1.5 : 1.0,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.emeraldGreen.withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (asset != null)
                      SizedBox(
                        width: 22.sp,
                        height: 22.sp,
                        child: Image.asset(
                          asset,
                          fit: BoxFit.contain,
                        ),
                      )
                    else
                      Icon(
                        fallbackIcon,
                        color: isSelected ? Colors.black : iconColor,
                        size: 22.sp,
                      ),
                    SizedBox(height: 4.h),
                    Text(
                      name,
                      style: AppTextStyle().boldTextStyle(
                        fontSize: 10.sp,
                        color: isSelected ? Colors.black : const Color(0xFFBAC5D5),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
