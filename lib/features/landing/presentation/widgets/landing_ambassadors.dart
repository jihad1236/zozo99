import 'package:flutter/material.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/core/utils/constants/sizer.dart';

class LandingAmbassadors extends StatelessWidget {
  const LandingAmbassadors({super.key});

  static const List<_AmbassadorItem> _ambassadors = [
    _AmbassadorItem(
      name: 'Wasim Akram',
      contractYears: '2024 - 2028',
      role: 'Global Cricket Icon',
    ),
    _AmbassadorItem(
      name: 'Mia Khalifa',
      contractYears: '2024',
      role: 'Brand Icon',
    ),
    _AmbassadorItem(
      name: 'Amy Jackson',
      contractYears: '2023 - 2024',
      role: 'International Star',
    ),
    _AmbassadorItem(
      name: 'Hansika Motwani',
      contractYears: '2023 - 2024',
      role: 'Film Celebrity',
    ),
    _AmbassadorItem(
      name: 'Keya Akter Payel',
      contractYears: '2025',
      role: 'Regional Ambassador',
    ),
    _AmbassadorItem(
      name: 'Yesha Sagar',
      contractYears: '2025 - 2026',
      role: 'Media Ambassador',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
                'Brand Ambassadors',
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
            height: 58.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _ambassadors.length,
              separatorBuilder: (context, index) => SizedBox(width: 20.w),
              itemBuilder: (context, index) {
                final ambassador = _ambassadors[index];
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF1B2332),
                        border: Border.all(color: Colors.white24, width: 1),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.draw_rounded,
                          size: 18.sp,
                          color: const Color(0xFFFFD700),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ambassador.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          ambassador.contractYears,
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 10.sp,
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

class _AmbassadorItem {
  final String name;
  final String contractYears;
  final String role;

  const _AmbassadorItem({
    required this.name,
    required this.contractYears,
    required this.role,
  });
}
