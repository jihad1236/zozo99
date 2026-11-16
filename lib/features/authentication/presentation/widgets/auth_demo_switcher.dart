import 'package:flutter/material.dart';
import 'package:zozo99/core/common/styles/global_text_style.dart';
import 'package:zozo99/core/models/betting_models.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/core/utils/constants/sizer.dart';
import 'package:zozo99/features/authentication/controllers/auth_controller.dart';
import 'package:zozo99/features/authentication/presentation/widgets/auth_glass_card.dart';

class AuthDemoSwitcher extends StatelessWidget {
  final AuthController controller;

  const AuthDemoSwitcher({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AuthGlassCard(
      padding: EdgeInsets.all(14.w),
      borderRadius: 18.r,
      opacity: 0.45,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(4.r),
                decoration: const BoxDecoration(
                  color: AppColors.gold,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.flash_on_rounded,
                  size: 12.sp,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'QUICK DEMO ACCESS',
                style: AppTextStyle().boldTextStyle(
                  fontSize: 11.sp,
                  color: AppColors.gold,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: _buildRolePill(
                  label: 'Player Demo',
                  sub: 'AlexRider (Gold VIP)',
                  icon: Icons.person_rounded,
                  color: AppColors.emeraldGreen,
                  onTap: () {
                    controller.emailController.text = 'user@zozo99.com';
                    controller.passwordController.text = 'password123';
                    controller.switchDemoAccount(UserRole.customer);
                  },
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _buildRolePill(
                  label: 'Admin Demo',
                  sub: 'ChiefAdmin (Master)',
                  icon: Icons.admin_panel_settings_rounded,
                  color: const Color(0xFFFF4D4D),
                  onTap: () {
                    controller.emailController.text = 'admin@zozo99.com';
                    controller.passwordController.text = 'password123';
                    controller.switchDemoAccount(UserRole.admin);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRolePill({
    required String label,
    required String sub,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color.withValues(alpha: 0.35), width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18.sp),
            SizedBox(width: 6.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    sub,
                    style: TextStyle(color: Colors.white54, fontSize: 8.5.sp),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
