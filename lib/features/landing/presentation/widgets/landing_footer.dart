import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/core/utils/constants/icon_path.dart';
import 'package:zozo99/core/utils/constants/sizer.dart';
import 'package:zozo99/features/points/presentation/screens/points_screen.dart';

class LandingFooter extends StatelessWidget {
  const LandingFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF090D14),
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 36.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Links Grid (Responsive 2x2 or 4 columns)
          Wrap(
            spacing: 24.w,
            runSpacing: 24.h,
            children: [
              _buildColumn(
                title: 'Gaming',
                items: [
                  _FooterLink(title: 'Casino'),
                  _FooterLink(title: 'Slots'),
                  _FooterLink(title: 'Table Games'),
                  _FooterLink(title: 'Crash (Aviator)'),
                  _FooterLink(title: 'Fishing'),
                  _FooterLink(title: 'Arcade'),
                  _FooterLink(title: 'Lottery'),
                ],
              ),
              _buildColumn(
                title: 'About Zozo99',
                items: [
                  _FooterLink(title: 'About Us', hasExternalIcon: true),
                  _FooterLink(title: 'Privacy Policy', hasExternalIcon: true),
                  _FooterLink(title: 'Terms & Conditions', hasExternalIcon: true),
                  _FooterLink(title: 'Responsible Gaming', hasExternalIcon: true),
                  _FooterLink(title: 'KYC & Verification', hasExternalIcon: true),
                ],
              ),
              _buildColumn(
                title: 'Features',
                items: [
                  _FooterLink(title: 'Promotions (100% Bonus)'),
                  _FooterLink(
                    title: 'VIP Club',
                    onTap: () => Get.to(() => const PointsScreen()),
                  ),
                  _FooterLink(title: 'Referral Program'),
                  _FooterLink(title: 'Brand Ambassadors'),
                  _FooterLink(title: 'APP Download (APK)'),
                ],
              ),
              _buildColumn(
                title: 'Help & Support',
                items: [
                  _FooterLink(title: 'New Member Guide', hasExternalIcon: true),
                  _FooterLink(title: 'Zozo99 Forum', hasExternalIcon: true),
                  _FooterLink(title: '24/7 Live Support', isHighlighted: true),
                ],
              ),
            ],
          ),
          SizedBox(height: 28.h),
          const Divider(color: Color(0xFF1B2332), height: 1),
          SizedBox(height: 20.h),
          // Responsible Gaming & Badges
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.15),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.5)),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.warning_amber_rounded, size: 14, color: Colors.redAccent),
                    SizedBox(width: 4.w),
                    Text(
                      '18+',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  'Gambling can be addictive. Play responsibly. Age 18 and above only.',
                  style: TextStyle(color: Colors.white38, fontSize: 10.sp),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              SizedBox(
                width: 20.w,
                height: 20.w,
                child: Image.asset(IconPath.appLogo, fit: BoxFit.contain),
              ),
              SizedBox(width: 6.w),
              Text(
                'zozo',
                style: TextStyle(
                  color: AppColors.emeraldGreen,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                '99',
                style: TextStyle(
                  color: const Color(0xFFFF4D4D),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  '© 2026 ZOZO99 Official. All rights reserved. Curacao eGaming Authorized License.',
                  style: TextStyle(
                    color: Colors.white24,
                    fontSize: 9.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColumn({
    required String title,
    required List<_FooterLink> items,
  }) {
    return SizedBox(
      width: 150.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(height: 12.h),
          ...items.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: InkWell(
                onTap: item.onTap ?? () {},
                borderRadius: BorderRadius.circular(4.r),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        item.title,
                        style: TextStyle(
                          color: item.isHighlighted ? AppColors.emeraldGreen : Colors.white60,
                          fontSize: 11.5.sp,
                          fontWeight: item.isHighlighted ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (item.hasExternalIcon) ...[
                      SizedBox(width: 4.w),
                      Icon(Icons.open_in_new_rounded, size: 10.sp, color: Colors.white38),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterLink {
  final String title;
  final bool hasExternalIcon;
  final bool isHighlighted;
  final VoidCallback? onTap;

  _FooterLink({
    required this.title,
    this.hasExternalIcon = false,
    this.isHighlighted = false,
    this.onTap,
  });
}
