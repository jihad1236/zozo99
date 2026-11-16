import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zozo99/core/common/common_button/common_button.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/core/utils/constants/sizer.dart';
import 'package:zozo99/features/authentication/controllers/auth_controller.dart';
import 'package:zozo99/features/authentication/presentation/widgets/auth_text_field.dart';

class AuthLoginForm extends StatelessWidget {
  final AuthController controller;

  const AuthLoginForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthTextField(
          controller: controller.emailController,
          label: 'Email Address or Phone',
          hint: 'e.g. user@zozo99.com',
          prefixIcon: Iconsax.sms,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 14.h),
        Obx(
          () => AuthTextField(
            controller: controller.passwordController,
            label: 'Password',
            hint: '••••••••••••',
            prefixIcon: Iconsax.lock,
            isPassword: true,
            isPasswordVisible: controller.isPasswordVisible.value,
            onTogglePassword: controller.togglePasswordVisibility,
          ),
        ),
        SizedBox(height: 10.h),

        // Forgot Password Link
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () {
              Get.snackbar(
                'Password Reset',
                'Demo reset link sent to registered email address.',
                backgroundColor: AppColors.info.withValues(alpha: 0.9),
                colorText: Colors.white,
              );
            },
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                color: AppColors.gold,
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(height: 20.h),

        // Reusable ProElevatedButton with Emerald Gradient & Glass Shadow
        Obx(
          () => ProElevatedButton(
            text: 'Sign In to Play',
            leadingIcon: Iconsax.login,
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
            onPressed: controller.login,
          ),
        ),
      ],
    );
  }
}
