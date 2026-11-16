import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zozo99/core/common/styles/global_text_style.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/core/utils/constants/sizer.dart';
import 'package:zozo99/features/wallet/controllers/wallet_controller.dart';

class DepositScreen extends StatelessWidget {
  const DepositScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WalletController>();
    final presets = [20, 50, 100, 250, 500, 1000];

    final methods = [
      {'name': 'Visa/Mastercard', 'icon': Icons.credit_card, 'color': AppColors.neonCyan},
      {'name': 'bKash Mobile', 'icon': Icons.phone_android, 'color': const Color(0xFFE2136E)},
      {'name': 'Nagad Wallet', 'icon': Icons.account_balance_wallet, 'color': const Color(0xFFF7921E)},
      {'name': 'Crypto (USDT)', 'icon': Icons.currency_bitcoin, 'color': AppColors.neonGreen},
      {'name': 'Bank Wire', 'icon': Icons.account_balance, 'color': AppColors.accent},
    ];

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        title: Text(
          'Deposit Funds',
          style: AppTextStyle().boldTextStyle(fontSize: 18.sp, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sandbox Info Notice
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Iconsax.info_circle, color: AppColors.info, size: 20.sp),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      'Demo Sandbox Payment Provider: Simulates verified webhook and instant credit conversion.',
                      style: AppTextStyle().regularTextStyle(fontSize: 11.sp, color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Amount Input Card
            Text(
              'Select or Enter Amount (\$)',
              style: AppTextStyle().boldTextStyle(fontSize: 14.sp, color: Colors.white),
            ),
            SizedBox(height: 10.h),
            Container(
              decoration: BoxDecoration(
                color: AppColors.darkSurface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.darkBorder),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  Text(
                    '\$',
                    style: AppTextStyle().boldTextStyle(fontSize: 26.sp, color: AppColors.neonGreen),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextField(
                      controller: controller.depositAmountController,
                      keyboardType: TextInputType.number,
                      style: AppTextStyle().boldTextStyle(fontSize: 24.sp, color: Colors.white),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '0.00',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),

            // Preset Chips
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: presets.map((amount) {
                return InkWell(
                  onTap: () {
                    controller.depositAmountController.text = amount.toString();
                  },
                  borderRadius: BorderRadius.circular(10.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: AppColors.darkSurfaceVariant,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: AppColors.darkBorder),
                    ),
                    child: Text(
                      '+\$$amount',
                      style: AppTextStyle().boldTextStyle(fontSize: 12.sp, color: AppColors.gold),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 24.h),

            // Payment Method Selector
            Text(
              'Select Payment Method',
              style: AppTextStyle().boldTextStyle(fontSize: 14.sp, color: Colors.white),
            ),
            SizedBox(height: 10.h),
            Column(
              children: methods.map((m) {
                return Obx(() {
                  final isSelected = controller.selectedPaymentMethod.value == m['name'];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: InkWell(
                      onTap: () => controller.selectedPaymentMethod.value = m['name'] as String,
                      borderRadius: BorderRadius.circular(14.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (m['color'] as Color).withValues(alpha: 0.15)
                              : AppColors.darkSurface,
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                            color: isSelected
                                ? (m['color'] as Color)
                                : AppColors.darkBorder,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(m['icon'] as IconData, color: m['color'] as Color, size: 24.sp),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: Text(
                                m['name'] as String,
                                style: AppTextStyle().boldTextStyle(fontSize: 14.sp, color: Colors.white),
                              ),
                            ),
                            Icon(
                              isSelected ? Icons.check_circle_rounded : Icons.radio_button_off_rounded,
                              color: isSelected ? (m['color'] as Color) : AppColors.darkTextDisabled,
                              size: 20.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
              }).toList(),
            ),
            SizedBox(height: 12.h),

            // Account number / reference field
            Container(
              decoration: BoxDecoration(
                color: AppColors.darkSurface,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: AppColors.darkBorder),
              ),
              child: TextField(
                controller: controller.depositAccountController,
                style: AppTextStyle().mediumTextStyle(fontSize: 14.sp, color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Account / Card Number / Mobile Number',
                  hintStyle: AppTextStyle().regularTextStyle(fontSize: 13.sp, color: AppColors.darkTextDisabled),
                  prefixIcon: Icon(Iconsax.card, color: AppColors.darkTextSecondary, size: 20.sp),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                ),
              ),
            ),
            SizedBox(height: 28.h),

            // Submit Button
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.submitDeposit(instant: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.neonGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                    elevation: 6,
                    shadowColor: AppColors.neonGreen.withValues(alpha: 0.5),
                  ),
                  child: controller.isLoading.value
                      ? SizedBox(
                          height: 22.h,
                          width: 22.h,
                          child: const CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                        )
                      : Text(
                          'Confirm & Deposit (Instant Demo)',
                          style: AppTextStyle().boldTextStyle(fontSize: 15.sp, color: Colors.black),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
