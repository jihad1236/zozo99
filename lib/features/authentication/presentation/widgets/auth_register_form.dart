import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zozo99/core/common/common_button/common_button.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/core/utils/constants/sizer.dart';
import 'package:zozo99/features/authentication/controllers/auth_controller.dart';
import 'package:zozo99/features/authentication/presentation/widgets/auth_text_field.dart';

class AuthRegisterForm extends StatelessWidget {
  final AuthController controller;

  const AuthRegisterForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthTextField(
          controller: controller.usernameController,
          label: 'Username / Nickname',
          hint: 'e.g. LuckyGamer',
          prefixIcon: Iconsax.user,
        ),
        SizedBox(height: 12.h),
        AuthTextField(
          controller: controller.emailController,
          label: 'Email Address',
          hint: 'e.g. gamer@zozo99.com',
          prefixIcon: Iconsax.sms,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 12.h),
        AuthTextField(
          controller: controller.phoneController,
          label: 'Phone Number',
          hint: '+880 1700 000000',
          prefixIcon: Iconsax.call,
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 12.h),
        Obx(
          () => AuthTextField(
            controller: controller.passwordController,
            label: 'Set Password',
            hint: 'Minimum 6 characters',
            prefixIcon: Iconsax.lock,
            isPassword: true,
            isPasswordVisible: controller.isPasswordVisible.value,
            onTogglePassword: controller.togglePasswordVisibility,
          ),
        ),
        SizedBox(height: 14.h),

        // Welcome Bonus Incentive
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.stars_rounded, color: AppColors.gold, size: 18),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Join now & receive 500 Demo Credits + 100% Welcome Bonus on 1st deposit!',
                  style: TextStyle(
                    color: AppColors.gold,
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 18.h),

        // Reusable ProElevatedButton
        Obx(
          () => ProElevatedButton(
            text: 'Create Free Account',
            leadingIcon: Iconsax.user_add,
            isLoading: controller.isLoading.value,
            height: 50.h,
            borderRadius: 14.r,
            fontSize: 14.sp,
            textColor: Colors.black,
            backgroundColor: AppColors.emeraldGreen,
            gradient: const LinearGradient(
              colors: [Color(0xFF00E676), Color(0xFF00B67A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            onPressed: controller.register,
          ),
        ),
      ],
    );
  }
}
