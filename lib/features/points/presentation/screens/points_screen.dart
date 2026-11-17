import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zozo99/core/common/styles/global_text_style.dart';
import 'package:zozo99/core/models/betting_models.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/core/utils/constants/sizer.dart';
import 'package:zozo99/features/points/controllers/points_controller.dart';

class PointsScreen extends StatelessWidget {
  const PointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<PointsController>()
        ? Get.find<PointsController>()
        : Get.put(PointsController());

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        title: Text(
          'VIP Club & Rewards',
          style: AppTextStyle().boldTextStyle(fontSize: 18.sp, color: Colors.white),
        ),
      ),
      body: ResponsiveLayout(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tier Hero Card wrapped in RepaintBoundary
              RepaintBoundary(child: _buildTierHeroCard(context, controller)),
              SizedBox(height: 16.h),

              // Tier Progress Bar wrapped in RepaintBoundary
              RepaintBoundary(child: _buildTierProgress(controller)),
              SizedBox(height: 20.h),

              // Redeem Points Quick Action
              _buildRedeemBanner(context, controller),
              SizedBox(height: 24.h),

              // Tier Perks Breakdown
              Text(
                'VIP Tier Benefits',
                style: AppTextStyle().boldTextStyle(fontSize: 16.sp, color: Colors.white),
              ),
              SizedBox(height: 12.h),
              RepaintBoundary(child: _buildPerksList()),
              SizedBox(height: 24.h),

              // Points Ledger History
              Text(
                'Points History',
                style: AppTextStyle().boldTextStyle(fontSize: 16.sp, color: Colors.white),
              ),
              SizedBox(height: 12.h),
              _buildLedgerList(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTierHeroCard(BuildContext context, PointsController controller) {
    return Obx(() {
      final tier = controller.currentTier;
      final points = controller.currentPoints;

      List<Color> gradientColors;
      Color accentColor;
      if (tier == VipTier.diamond) {
        gradientColors = [const Color(0xFF00C6FF), const Color(0xFF0072FF)];
        accentColor = AppColors.neonCyan;
      } else if (tier == VipTier.gold) {
        gradientColors = [const Color(0xFFFFB300), const Color(0xFFE65100)];
        accentColor = AppColors.gold;
      } else {
        gradientColors = [const Color(0xFF757F9A), const Color(0xFFD7DDE8)];
        accentColor = Colors.white70;
      }

      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.r),
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.3),
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Iconsax.crown, color: Colors.white, size: 16.sp),
                      SizedBox(width: 6.w),
                      Text(
                        '${tier.label.toUpperCase()} VIP',
                        style: AppTextStyle().boldTextStyle(fontSize: 12.sp, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${(tier.cashbackRate * 100).toInt()}% CASHBACK',
                  style: AppTextStyle().boldTextStyle(fontSize: 11.sp, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Text(
              'TOTAL VIP POINTS',
              style: AppTextStyle().boldTextStyle(
                fontSize: 11.sp,
                color: Colors.white.withValues(alpha: 0.8),
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(Iconsax.star1, color: Colors.white, size: 28.sp),
                SizedBox(width: 8.w),
                Text(
                  points.toString(),
                  style: AppTextStyle().boldTextStyle(fontSize: 32.sp, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTierProgress(PointsController controller) {
    return Obx(() {
      final progress = controller.tierProgress;
      final ptsNeeded = controller.pointsToNextTier;
      final nextTier = controller.nextTierName;

      return Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Next Rank: $nextTier',
                  style: AppTextStyle().boldTextStyle(fontSize: 13.sp, color: Colors.white),
                ),
                Text(
                  ptsNeeded > 0 ? '$ptsNeeded pts needed' : 'Max Rank Achieved!',
                  style: AppTextStyle().boldTextStyle(fontSize: 11.sp, color: AppColors.gold),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10.h,
                backgroundColor: AppColors.darkSurfaceVariant,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildRedeemBanner(BuildContext context, PointsController controller) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Iconsax.gift, color: AppColors.gold, size: 22.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Redeem Points to Credits',
                  style: AppTextStyle().boldTextStyle(fontSize: 14.sp, color: Colors.white),
                ),
                SizedBox(height: 2.h),
                Text(
                  '100 Points = 10 Free Game Credits',
                  style: AppTextStyle().regularTextStyle(fontSize: 11.sp, color: AppColors.darkTextSecondary),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _showRedeemSheet(context, controller),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gold,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            ),
            child: Text(
              'Redeem',
              style: AppTextStyle().boldTextStyle(fontSize: 12.sp, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerksList() {
    final perks = [
      {'title': 'Wager Cashback', 'silver': '1%', 'gold': '3%', 'diamond': '5%'},
      {'title': 'Withdrawal Priority', 'silver': 'Standard', 'gold': 'Priority', 'diamond': 'Instant VIP'},
      {'title': 'Deposit Bonus', 'silver': '+5%', 'gold': '+15%', 'diamond': '+30%'},
      {'title': 'Dedicated Host', 'silver': '❌', 'gold': 'Email', 'diamond': '24/7 Personal'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.r),
            child: Row(
              children: [
                Expanded(flex: 3, child: Text('Perk', style: AppTextStyle().boldTextStyle(fontSize: 11.sp, color: AppColors.darkTextSecondary))),
                Expanded(flex: 2, child: Center(child: Text('Silver', style: AppTextStyle().boldTextStyle(fontSize: 11.sp, color: Colors.white70)))),
                Expanded(flex: 2, child: Center(child: Text('Gold', style: AppTextStyle().boldTextStyle(fontSize: 11.sp, color: AppColors.gold)))),
                Expanded(flex: 2, child: Center(child: Text('Diamond', style: AppTextStyle().boldTextStyle(fontSize: 11.sp, color: AppColors.neonCyan)))),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.darkBorder),
          ...perks.map((p) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 10.h),
              child: Row(
                children: [
                  Expanded(flex: 3, child: Text(p['title']!, style: AppTextStyle().mediumTextStyle(fontSize: 12.sp, color: Colors.white))),
                  Expanded(flex: 2, child: Center(child: Text(p['silver']!, style: AppTextStyle().regularTextStyle(fontSize: 11.sp, color: Colors.white70)))),
                  Expanded(flex: 2, child: Center(child: Text(p['gold']!, style: AppTextStyle().boldTextStyle(fontSize: 11.sp, color: AppColors.gold)))),
                  Expanded(flex: 2, child: Center(child: Text(p['diamond']!, style: AppTextStyle().boldTextStyle(fontSize: 11.sp, color: AppColors.neonCyan)))),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLedgerList(PointsController controller) {
    return Obx(() {
      final items = controller.ledger;
      if (items.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(24.r),
            child: Text(
              'No points history yet. Play games to earn!',
              style: AppTextStyle().regularTextStyle(fontSize: 13.sp, color: AppColors.darkTextSecondary),
            ),
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, _) => SizedBox(height: 8.h),
        itemBuilder: (context, index) {
          final entry = items[index];
          final isPositive = entry.points > 0;
          return RepaintBoundary(
            child: Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: AppColors.darkSurface,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.darkBorder),
              ),
              child: Row(
                children: [
                  Icon(
                    isPositive ? Iconsax.arrow_up_3 : Iconsax.arrow_down,
                    color: isPositive ? AppColors.gold : AppColors.aviatorRed,
                    size: 20.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.source.replaceAll('_', ' '),
                          style: AppTextStyle().boldTextStyle(fontSize: 12.sp, color: Colors.white),
                        ),
                        Text(
                          entry.type.code,
                          style: AppTextStyle().regularTextStyle(fontSize: 10.sp, color: AppColors.darkTextSecondary),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${isPositive ? "+" : ""}${entry.points} pts',
                    style: AppTextStyle().boldTextStyle(
                      fontSize: 13.sp,
                      color: isPositive ? AppColors.gold : AppColors.aviatorRed,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  void _showRedeemSheet(BuildContext context, PointsController controller) {
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
              'Redeem VIP Points',
              style: AppTextStyle().boldTextStyle(fontSize: 18.sp, color: Colors.white),
            ),
            SizedBox(height: 4.h),
            Text(
              'Available: ${controller.currentPoints} Points (100 Pts = 10 Credits)',
              style: AppTextStyle().regularTextStyle(fontSize: 12.sp, color: AppColors.gold),
            ),
            SizedBox(height: 16.h),
            Container(
              decoration: BoxDecoration(
                color: AppColors.darkSurfaceVariant,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: TextField(
                controller: controller.redeemController,
                keyboardType: TextInputType.number,
                style: AppTextStyle().boldTextStyle(fontSize: 16.sp, color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: Icon(Iconsax.star, color: AppColors.gold, size: 20.sp),
                  hintText: 'Points to convert',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.redeemPoints,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.black)
                      : Text(
                          'Redeem to Credits',
                          style: AppTextStyle().boldTextStyle(fontSize: 14.sp, color: Colors.black),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
