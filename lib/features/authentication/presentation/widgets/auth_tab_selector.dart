import 'package:flutter/material.dart';
import 'package:zozo99/core/common/styles/global_text_style.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/core/utils/constants/sizer.dart';

class AuthTabSelector extends StatelessWidget {
  final TabController tabController;

  const AuthTabSelector({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
          width: 1.0,
        ),
      ),
      child: TabBar(
        controller: tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00B67A), Color(0xFF008C5D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.emeraldGreen.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        labelColor: Colors.black,
        unselectedLabelColor: Colors.white70,
        labelStyle: AppTextStyle().boldTextStyle(fontSize: 13.sp),
        unselectedLabelStyle: AppTextStyle().mediumTextStyle(fontSize: 13.sp),
        tabs: const [
          Tab(text: 'Sign In'),
          Tab(text: 'Register'),
        ],
      ),
    );
  }
}
