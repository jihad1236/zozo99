import 'package:flutter/material.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/core/utils/constants/sizer.dart';

class LandingSponsorships extends StatelessWidget {
  const LandingSponsorships({super.key});

  static const List<_SponsorItem> _sponsors = [
    _SponsorItem(
      teamName: 'Quetta Gladiators',
      tier: 'Titanium Sponsor',
      years: '2023 - 2024',
      icon: Icons.shield_rounded,
      accentColor: Color(0xFF9C27B0),
    ),
    _SponsorItem(
      teamName: 'Sunrisers Eastern Cape',
      tier: 'Title Sponsor',
      years: '2023 - 2024',
      icon: Icons.wb_sunny_rounded,
      accentColor: Color(0xFFFF5722),
    ),
    _SponsorItem(
      teamName: 'Deccan Gladiators',
      tier: 'Title Sponsor',
      years: '2023 - 2024',
      icon: Icons.sports_kabaddi_rounded,
      accentColor: Color(0xFFFFB300),
    ),
    _SponsorItem(
      teamName: 'St Kitts & Nevis Patriots',
      tier: 'Principal Sponsor',
      years: '2024 - 2025',
      icon: Icons.military_tech_rounded,
      accentColor: Color(0xFF4CAF50),
    ),
    _SponsorItem(
      teamName: 'Biratnagar Kings',
      tier: 'Back of Jersey Sponsor',
      years: '2024 - 2025',
      icon: Icons.castle_rounded,
      accentColor: Color(0xFF29B6F6),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFF1B2332), width: 1),
          bottom: BorderSide(color: Color(0xFF1B2332), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 3.w,
                height: 14.h,
                decoration: BoxDecoration(
                  color: AppColors.emeraldGreen,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'Sponsorships',
                style: TextStyle(
                  color: AppColors.emeraldGreen,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          SizedBox(
            height: 64.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _sponsors.length,
              separatorBuilder: (context, index) => SizedBox(width: 20.w),
              itemBuilder: (context, index) {
                final sponsor = _sponsors[index];
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: sponsor.accentColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(color: sponsor.accentColor.withValues(alpha: 0.4), width: 1.2),
                      ),
                      child: Center(
                        child: Icon(sponsor.icon, color: sponsor.accentColor, size: 20.sp),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          sponsor.teamName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          sponsor.tier,
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 10.sp,
                          ),
                        ),
                        Text(
                          sponsor.years,
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 9.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SponsorItem {
  final String teamName;
  final String tier;
  final String years;
  final IconData icon;
  final Color accentColor;

  const _SponsorItem({
    required this.teamName,
    required this.tier,
    required this.years,
    required this.icon,
    required this.accentColor,
  });
}
