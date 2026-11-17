import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zozo99/core/common/styles/global_text_style.dart';
import 'package:zozo99/core/models/betting_models.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/core/utils/constants/sizer.dart';
import 'package:zozo99/features/wallet/controllers/wallet_controller.dart';
import 'package:zozo99/features/wallet/presentation/screens/deposit_screen.dart';
import 'package:zozo99/features/wallet/presentation/screens/withdrawal_screen.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<WalletController>()
        ? Get.find<WalletController>()
        : Get.put(WalletController());

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Wallet & Cashier',
          style: AppTextStyle().boldTextStyle(fontSize: 20.sp, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Iconsax.refresh, color: AppColors.darkTextSecondary, size: 20.sp),
            onPressed: () {
              Get.snackbar('Refreshed', 'Wallet balance synced with server ledger.',
                  backgroundColor: AppColors.darkSurface, colorText: Colors.white);
            },
          ),
        ],
      ),
      body: ResponsiveLayout(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dual Balance Card wrapped in RepaintBoundary
              RepaintBoundary(child: _buildBalanceHeroCard(context, controller)),
              SizedBox(height: 16.h),

              // Quick Actions Bar
              _buildQuickActions(context, controller),
              SizedBox(height: 20.h),

              // Conversion Widget
              _buildConversionBanner(context, controller),
              SizedBox(height: 24.h),

              // Transaction History Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transaction Ledger',
                    style: AppTextStyle().boldTextStyle(fontSize: 16.sp, color: Colors.white),
                  ),
                  Text(
                    'Server Audited',
                    style: AppTextStyle().mediumTextStyle(fontSize: 11.sp, color: AppColors.neonGreen),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Filter Chips
              _buildFilterChips(controller),
              SizedBox(height: 12.h),

              // Transactions List
              _buildTransactionsList(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceHeroCard(BuildContext context, WalletController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF22283A), Color(0xFF141722)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.25), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Iconsax.wallet_3, color: AppColors.gold, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'TOTAL ASSETS',
                    style: AppTextStyle().boldTextStyle(
                      fontSize: 12.sp,
                      color: AppColors.darkTextSecondary,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.neonGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: AppColors.neonGreen.withValues(alpha: 0.3)),
                ),
                child: Text(
                  '1 USD = 100 Credits',
                  style: AppTextStyle().boldTextStyle(fontSize: 10.sp, color: AppColors.neonGreen),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              // Cash Balance
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cash Balance',
                      style: AppTextStyle().regularTextStyle(fontSize: 12.sp, color: AppColors.darkTextSecondary),
                    ),
                    SizedBox(height: 4.h),
                    Obx(
                      () => Text(
                        '\$${(controller.wallet.value?.cashBalance ?? 0.0).toStringAsFixed(2)}',
                        style: AppTextStyle().boldTextStyle(
                          fontSize: 22.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 40.h,
                width: 1,
                color: AppColors.darkBorder,
              ),
              SizedBox(width: 16.w),
              // Game Credits
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Game Credits',
                      style: AppTextStyle().regularTextStyle(fontSize: 12.sp, color: AppColors.darkTextSecondary),
                    ),
                    SizedBox(height: 4.h),
                    Obx(
                      () => Row(
                        children: [
                          Icon(Icons.bolt_rounded, color: AppColors.gold, size: 22.sp),
                          SizedBox(width: 4.w),
                          Text(
                            (controller.wallet.value?.creditBalance ?? 0.0).toInt().toString(),
                            style: AppTextStyle().boldTextStyle(
                              fontSize: 22.sp,
                              color: AppColors.gold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, WalletController controller) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            label: 'Deposit',
            icon: Iconsax.add_circle,
            color: AppColors.neonGreen,
            onTap: () => Get.to(() => const DepositScreen()),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _buildActionButton(
            label: 'Withdraw',
            icon: Iconsax.export_1,
            color: AppColors.aviatorRed,
            onTap: () => Get.to(() => const WithdrawalScreen()),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _buildActionButton(
            label: 'Convert',
            icon: Iconsax.convert,
            color: AppColors.accent,
            onTap: () => _showConversionBottomSheet(context, controller),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22.sp),
            SizedBox(height: 6.h),
            Text(
              label,
              style: AppTextStyle().boldTextStyle(fontSize: 12.sp, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversionBanner(BuildContext context, WalletController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Iconsax.repeat, color: AppColors.gold, size: 18.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Credit Conversion',
                  style: AppTextStyle().boldTextStyle(fontSize: 13.sp, color: Colors.white),
                ),
                Text(
                  'Instant swap between Cash and Credits anytime',
                  style: AppTextStyle().regularTextStyle(fontSize: 10.sp, color: AppColors.darkTextSecondary),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _showConversionBottomSheet(context, controller),
            child: Text(
              'Convert ⇄',
              style: AppTextStyle().boldTextStyle(fontSize: 12.sp, color: AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(WalletController controller) {
    final filters = <String, TransactionType?>{
      'All': null,
      'Deposits': TransactionType.deposit,
      'Withdrawals': TransactionType.withdrawal,
      'Conversions': TransactionType.creditConversion,
      'Game Wins': TransactionType.gameWin,
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.entries.map((entry) {
          return Obx(() {
            final isSelected = controller.selectedFilter.value == entry.value;
            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: FilterChip(
                selected: isSelected,
                label: Text(entry.key),
                labelStyle: AppTextStyle().mediumTextStyle(
                  fontSize: 11.sp,
                  color: isSelected ? Colors.white : AppColors.darkTextSecondary,
                ),
                backgroundColor: AppColors.darkSurfaceVariant,
                selectedColor: AppColors.aviatorRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  side: BorderSide(
                    color: isSelected ? AppColors.aviatorRed : AppColors.darkBorder,
                  ),
                ),
                onSelected: (_) => controller.setFilter(entry.value),
              ),
            );
          });
        }).toList(),
      ),
    );
  }

  Widget _buildTransactionsList(WalletController controller) {
    return Obx(() {
      final items = controller.filteredTransactions;
      if (items.isEmpty) {
        return Container(
          padding: EdgeInsets.all(32.r),
          alignment: Alignment.center,
          child: Column(
            children: [
              Icon(Iconsax.receipt_item, size: 40.sp, color: AppColors.darkTextDisabled),
              SizedBox(height: 12.h),
              Text(
                'No transactions found',
                style: AppTextStyle().mediumTextStyle(fontSize: 14.sp, color: AppColors.darkTextSecondary),
              ),
            ],
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, _) => SizedBox(height: 10.h),
        itemBuilder: (context, index) {
          final tx = items[index];
          final isCredit = tx.type == TransactionType.gameWin || tx.type == TransactionType.deposit;
          return RepaintBoundary(
            child: Container(
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: AppColors.darkSurface,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: AppColors.darkBorder),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: _getTransactionColor(tx.type).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      _getTransactionIcon(tx.type),
                      color: _getTransactionColor(tx.type),
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tx.description.isNotEmpty ? tx.description : tx.type.code,
                          style: AppTextStyle().boldTextStyle(fontSize: 13.sp, color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                tx.referenceId,
                                style: AppTextStyle().regularTextStyle(
                                  fontSize: 10.sp,
                                  color: AppColors.darkTextDisabled,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: tx.status == TransactionStatus.completed
                                    ? AppColors.neonGreen.withValues(alpha: 0.15)
                                    : AppColors.warning.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                tx.status.code,
                                style: AppTextStyle().boldTextStyle(
                                  fontSize: 8.sp,
                                  color: tx.status == TransactionStatus.completed
                                      ? AppColors.neonGreen
                                      : AppColors.warning,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${isCredit ? "+" : "-"}${tx.currency == "CREDITS" ? "${tx.amount.toInt()} ⚡" : "\$${tx.amount.toStringAsFixed(2)}"}',
                        style: AppTextStyle().boldTextStyle(
                          fontSize: 14.sp,
                          color: isCredit ? AppColors.neonGreen : Colors.white,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${tx.createdAt.hour.toString().padLeft(2, '0')}:${tx.createdAt.minute.toString().padLeft(2, '0')}',
                        style: AppTextStyle().regularTextStyle(
                          fontSize: 10.sp,
                          color: AppColors.darkTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Color _getTransactionColor(TransactionType type) {
    switch (type) {
      case TransactionType.deposit:
        return AppColors.neonGreen;
      case TransactionType.withdrawal:
        return AppColors.aviatorRed;
      case TransactionType.gameWin:
        return AppColors.gold;
      case TransactionType.creditConversion:
        return AppColors.accent;
      default:
        return Colors.white70;
    }
  }

  IconData _getTransactionIcon(TransactionType type) {
    switch (type) {
      case TransactionType.deposit:
        return Iconsax.arrow_down_2;
      case TransactionType.withdrawal:
        return Iconsax.arrow_up_1;
      case TransactionType.gameWin:
        return Iconsax.cup;
      case TransactionType.creditConversion:
        return Iconsax.convert;
      default:
        return Iconsax.activity;
    }
  }

  void _showConversionBottomSheet(BuildContext context, WalletController controller) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.darkBorder,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Credit Converter',
              style: AppTextStyle().boldTextStyle(fontSize: 18.sp, color: Colors.white),
            ),
            Text(
              'Convert Cash to Credits or exchange Credits back to Cash instantly',
              style: AppTextStyle().regularTextStyle(fontSize: 12.sp, color: AppColors.darkTextSecondary),
            ),
            SizedBox(height: 20.h),
            // Cash to Credits
            Text(
              'Convert Cash to Game Credits',
              style: AppTextStyle().boldTextStyle(fontSize: 13.sp, color: AppColors.neonGreen),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.darkSurfaceVariant,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TextField(
                      controller: controller.convertCashController,
                      keyboardType: TextInputType.number,
                      style: AppTextStyle().boldTextStyle(fontSize: 14.sp, color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.attach_money, color: AppColors.neonGreen, size: 20.sp),
                        hintText: 'Cash Amount (\$)',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                ElevatedButton(
                  onPressed: controller.convertCashToCredits,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.neonGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  child: Text(
                    'Get Credits ⚡',
                    style: AppTextStyle().boldTextStyle(fontSize: 12.sp, color: Colors.black),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            // Credits to Cash
            Text(
              'Exchange Credits to Cash',
              style: AppTextStyle().boldTextStyle(fontSize: 13.sp, color: AppColors.gold),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.darkSurfaceVariant,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TextField(
                      controller: controller.convertCreditController,
                      keyboardType: TextInputType.number,
                      style: AppTextStyle().boldTextStyle(fontSize: 14.sp, color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.bolt_rounded, color: AppColors.gold, size: 20.sp),
                        hintText: 'Credits to Cash',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                ElevatedButton(
                  onPressed: controller.convertCreditsToCash,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  child: Text(
                    'Get Cash 💵',
                    style: AppTextStyle().boldTextStyle(fontSize: 12.sp, color: Colors.black),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
