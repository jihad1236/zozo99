import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zozo99/core/common/styles/global_text_style.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/core/utils/constants/sizer.dart';
import 'package:zozo99/features/wallet/controllers/wallet_controller.dart';

class WithdrawalScreen extends StatelessWidget {
  const WithdrawalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WalletController>();

    final methods = [
      {'name': 'Bank Account', 'icon': Icons.account_balance, 'color': AppColors.accent},
      {'name': 'bKash', 'icon': Icons.phone_android, 'color': const Color(0xFFE2136E)},
      {'name': 'Nagad', 'icon': Icons.account_balance_wallet, 'color': const Color(0xFFF7921E)},
      {'name': 'USDT (TRC20)', 'icon': Icons.currency_bitcoin, 'color': AppColors.neonGreen},
    ];

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        title: Text(
          'Request Withdrawal',
          style: AppTextStyle().boldTextStyle(fontSize: 18.sp, color: Colors.white),
        ),
      ),
      body: ResponsiveLayout(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Available Balance Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppColors.darkSurface,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppColors.darkBorder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Available to Withdraw',
                          style: AppTextStyle().regularTextStyle(fontSize: 12.sp, color: AppColors.darkTextSecondary),
                        ),
                        SizedBox(height: 4.h),
                        Obx(
                          () => Text(
                            '\$${(controller.wallet.value?.cashBalance ?? 0.0).toStringAsFixed(2)}',
                            style: AppTextStyle().boldTextStyle(fontSize: 22.sp, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: AppColors.aviatorRed.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'Min \$20.00',
                        style: AppTextStyle().boldTextStyle(fontSize: 11.sp, color: AppColors.aviatorRed),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // Amount Input
              Text(
                'Withdrawal Amount (\$)',
                style: AppTextStyle().boldTextStyle(fontSize: 14.sp, color: Colors.white),
              ),
              SizedBox(height: 8.h),
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
                      style: AppTextStyle().boldTextStyle(fontSize: 24.sp, color: AppColors.aviatorRed),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: TextField(
                        controller: controller.withdrawAmountController,
                        keyboardType: TextInputType.number,
                        style: AppTextStyle().boldTextStyle(fontSize: 22.sp, color: Colors.white),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '0.00',
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        final max = controller.wallet.value?.cashBalance ?? 0.0;
                        controller.withdrawAmountController.text = max.toStringAsFixed(2);
                      },
                      child: Text(
                        'MAX',
                        style: AppTextStyle().boldTextStyle(fontSize: 12.sp, color: AppColors.gold),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // Method Selector
              Text(
                'Select Payout Method',
                style: AppTextStyle().boldTextStyle(fontSize: 14.sp, color: Colors.white),
              ),
              SizedBox(height: 10.h),
              RepaintBoundary(
                child: Wrap(
                  spacing: 10.w,
                  runSpacing: 10.h,
                  children: methods.map((m) {
                    return Obx(() {
                      final isSelected = controller.selectedWithdrawMethod.value == m['name'];
                      return InkWell(
                        onTap: () => controller.selectedWithdrawMethod.value = m['name'] as String,
                        borderRadius: BorderRadius.circular(12.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (m['color'] as Color).withValues(alpha: 0.18)
                                : AppColors.darkSurfaceVariant,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: isSelected ? (m['color'] as Color) : AppColors.darkBorder,
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(m['icon'] as IconData, color: m['color'] as Color, size: 18.sp),
                              SizedBox(width: 8.w),
                              Text(
                                m['name'] as String,
                                style: AppTextStyle().boldTextStyle(
                                  fontSize: 12.sp,
                                  color: isSelected ? Colors.white : AppColors.darkTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  }).toList(),
                ),
              ),
              SizedBox(height: 20.h),

            // Account Details
            Text(
              'Payout Account Information',
              style: AppTextStyle().boldTextStyle(fontSize: 14.sp, color: Colors.white),
            ),
            SizedBox(height: 10.h),
            _buildField(
              controller: controller.withdrawAccountController,
              hint: 'Account Number / Wallet Address',
              icon: Iconsax.wallet_money,
            ),
            SizedBox(height: 12.h),
            _buildField(
              controller: controller.withdrawNameController,
              hint: 'Account Holder Name',
              icon: Iconsax.user,
            ),
            SizedBox(height: 18.h),

            // Security note
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: AppColors.darkSurfaceVariant,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.darkBorder),
              ),
              child: Row(
                children: [
                  Icon(Iconsax.shield_tick, color: AppColors.neonGreen, size: 20.sp),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      'Withdrawals undergo server audit review before dispatch. Track progress in Transaction Ledger.',
                      style: AppTextStyle().regularTextStyle(fontSize: 11.sp, color: AppColors.darkTextSecondary),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 28.h),

            // Submit Button
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.submitWithdrawal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.aviatorRed,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                    elevation: 6,
                    shadowColor: AppColors.aviatorRed.withValues(alpha: 0.5),
                  ),
                  child: controller.isLoading.value
                      ? SizedBox(
                          height: 22.h,
                          width: 22.h,
                          child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          'Submit Withdrawal Request',
                          style: AppTextStyle().boldTextStyle(fontSize: 15.sp, color: Colors.white),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: TextField(
        controller: controller,
        style: AppTextStyle().mediumTextStyle(fontSize: 14.sp, color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyle().regularTextStyle(fontSize: 13.sp, color: AppColors.darkTextDisabled),
          prefixIcon: Icon(icon, color: AppColors.darkTextSecondary, size: 20.sp),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        ),
      ),
    );
  }
}
