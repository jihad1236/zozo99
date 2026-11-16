import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zozo99/core/common/styles/global_text_style.dart';
import 'package:zozo99/core/models/betting_models.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/core/utils/constants/icon_path.dart';
import 'package:zozo99/core/utils/constants/sizer.dart';
import 'package:zozo99/features/landing/controllers/landing_controller.dart';
import 'package:zozo99/features/wallet/presentation/screens/deposit_screen.dart';
import 'package:zozo99/routes/app_routes.dart';

class LandingHeader extends StatelessWidget {
  final LandingController controller;

  const LandingHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: const BoxDecoration(
        color: Color(0xFF0C1017),
        border: Border(bottom: BorderSide(color: Color(0xFF1E2533), width: 1)),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Brand Logo
            Row(
              children: [
                SizedBox(
                  width: 32.w,
                  height: 32.w,
                  child: Image.asset(IconPath.appLogo, fit: BoxFit.contain),
                ),
                SizedBox(width: 8.w),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'zozo',
                      style: AppTextStyle().boldTextStyle(
                        fontSize: 20.sp,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      '99',
                      style: AppTextStyle().boldTextStyle(
                        fontSize: 20.sp,
                        color: const Color(0xFFFF3B30),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),

            // Auth State: Guest buttons vs Logged-in controls
            StreamBuilder<UserModel?>(
              stream: controller.userStream,
              initialData: controller.currentUser,
              builder: (context, userSnapshot) {
                final user = userSnapshot.data;

                if (user == null) {
                  // Guest: "Log in" and "Sign up"
                  return Row(
                    children: [
                      OutlinedButton(
                        onPressed: () => Get.toNamed(AppRoute.loginScreen),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF2C3545)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                        ),
                        child: Text(
                          'Log in',
                          style: AppTextStyle().boldTextStyle(fontSize: 12.sp, color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      ElevatedButton(
                        onPressed: () => Get.toNamed(AppRoute.loginScreen),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.emeraldGreen,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                        ),
                        child: Text(
                          'Sign up',
                          style: AppTextStyle().boldTextStyle(fontSize: 12.sp, color: Colors.black),
                        ),
                      ),
                    ],
                  );
                }

                // Logged in: Credits pill + Quick Deposit
                return StreamBuilder<WalletModel?>(
                  stream: controller.walletStream,
                  initialData: controller.currentWallet,
                  builder: (context, walletSnapshot) {
                    final credits = walletSnapshot.data?.creditBalance ?? 0.0;
                    return Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF161C26),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.bolt_rounded, color: AppColors.gold, size: 16.sp),
                              SizedBox(width: 4.w),
                              Text(
                                '${credits.toInt()}',
                                style: AppTextStyle().boldTextStyle(fontSize: 12.sp, color: Colors.white),
                              ),
                              SizedBox(width: 6.w),
                              InkWell(
                                onTap: () => Get.to(() => const DepositScreen()),
                                child: Container(
                                  padding: EdgeInsets.all(3.r),
                                  decoration: const BoxDecoration(
                                    color: AppColors.emeraldGreen,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.add, color: Colors.black, size: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10.w),
                        CircleAvatar(
                          radius: 16.r,
                          backgroundColor: AppColors.aviatorRed,
                          child: Text(
                            user.username.isNotEmpty ? user.username[0].toUpperCase() : 'U',
                            style: AppTextStyle().boldTextStyle(fontSize: 12.sp, color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
