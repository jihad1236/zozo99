import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/core/utils/constants/icon_path.dart';
import 'package:zozo99/core/utils/constants/sizer.dart';
import 'package:zozo99/features/points/presentation/screens/points_screen.dart';

class LandingVipSection extends StatelessWidget {
  const LandingVipSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Main VIP Club Banner
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              gradient: const LinearGradient(
                colors: [Color(0xFF003B22), Color(0xFF05160E), Color(0xFF0D121B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: const Color(0xFF00B67A).withValues(alpha: 0.35), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00B67A).withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFB800).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6.r),
                            border: Border.all(color: const Color(0xFFFFB800).withValues(alpha: 0.5)),
                          ),
                          child: Text(
                            'PREMIER EXPERIENCE',
                            style: TextStyle(
                              color: const Color(0xFFFFD700),
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'ZOZO99 VIP CLUB',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'The Most Exclusive VIP Program Ever',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 14.h),
                        InkWell(
                          onTap: () => Get.to(() => const PointsScreen()),
                          borderRadius: BorderRadius.circular(24.r),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFD54F), Color(0xFFFFA000), Color(0xFFFF8F00)],
                              ),
                              borderRadius: BorderRadius.circular(24.r),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFFA000).withValues(alpha: 0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'JOIN NOW!',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Icon(Icons.arrow_forward_rounded, size: 14.sp, color: Colors.black),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                // Crown / VIP Asset Graphic
                Expanded(
                  flex: 4,
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 80.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFFFD700).withValues(alpha: 0.12),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 58.w,
                              height: 58.w,
                              child: Image.asset(IconPath.vip, fit: BoxFit.contain),
                            ),
                            SizedBox(height: 4.h),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFF141923),
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(color: const Color(0xFFFFD700), width: 1),
                              ),
                              child: Text(
                                'VIP CLUB',
                                style: TextStyle(
                                  color: const Color(0xFFFFD700),
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          // Sub-cards: 24/7 Personal VIP Manager & VIP Exclusive Rewards
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 500) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildVipPerkCard(
                        assetIcon: IconPath.coin,
                        badgeColor: AppColors.emeraldGreen,
                        title: '24/7 Personal VIP Manager',
                        description:
                            "Our Personal VIP Manager's number one goal is to make your experience second-to-none by offering prompt and personal service that is unrivalled.\n\nYou'll be able to reach your 24/7 Personal VIP Manager via VIP LiveChat, Telegram, or Email.",
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildVipPerkCard(
                        assetIcon: IconPath.diamond,
                        badgeColor: const Color(0xFFFFB800),
                        title: 'VIP Exclusive Rewards',
                        description:
                            "Who doesn't like to have something extra? Be on your way to increased casino fun with exclusive rewards!\n\nOne of the biggest perks of joining our Zozo99 VIP Club is benefiting from the exclusive giveaways, cash prizes, level up rewards, and mystery gifts all year long.",
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildVipPerkCard(
                      assetIcon: IconPath.coin,
                      badgeColor: AppColors.emeraldGreen,
                      title: '24/7 Personal VIP Manager',
                      description:
                          "Our Personal VIP Manager's number one goal is to make your experience second-to-none by offering prompt and personal service that is unrivalled.\n\nYou'll be able to reach your 24/7 Personal VIP Manager via VIP LiveChat, Telegram, or Email.",
                    ),
                    SizedBox(height: 10.h),
                    _buildVipPerkCard(
                      assetIcon: IconPath.diamond,
                      badgeColor: const Color(0xFFFFB800),
                      title: 'VIP Exclusive Rewards',
                      description:
                          "Who doesn't like to have something extra? Be on your way to increased casino fun with exclusive rewards!\n\nOne of the biggest perks of joining our Zozo99 VIP Club is benefiting from the exclusive giveaways, cash prizes, level up rewards, and mystery gifts all year long.",
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVipPerkCard({
    required String assetIcon,
    required Color badgeColor,
    required String title,
    required String description,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF141923),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFF222B3D)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [badgeColor.withValues(alpha: 0.25), const Color(0xFF0D121B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: badgeColor.withValues(alpha: 0.5)),
                ),
                child: Center(
                  child: Image.asset(assetIcon, fit: BoxFit.contain),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            description,
            style: TextStyle(
              color: Colors.white60,
              fontSize: 11.5.sp,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
