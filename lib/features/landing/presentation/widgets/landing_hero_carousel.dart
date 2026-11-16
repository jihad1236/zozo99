import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zozo99/core/common/styles/global_text_style.dart';
import 'package:zozo99/core/models/betting_models.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/core/utils/constants/icon_path.dart';
import 'package:zozo99/core/utils/constants/sizer.dart';
import 'package:zozo99/features/landing/controllers/landing_controller.dart';
import 'package:zozo99/features/points/presentation/screens/points_screen.dart';

class LandingHeroCarousel extends StatefulWidget {
  final LandingController controller;

  const LandingHeroCarousel({super.key, required this.controller});

  @override
  State<LandingHeroCarousel> createState() => _LandingHeroCarouselState();
}

class _LandingHeroCarouselState extends State<LandingHeroCarousel> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;

  final List<Map<String, dynamic>> banners = [
    {
      'tag': 'WELCOME OFFER',
      'title': '100% BONUS',
      'subtitle': 'ON ALL GAMES',
      'extra': '*Terms & Conditions Apply',
      'ambassador': 'Wasim Akram ✍️',
      'accent': const Color(0xFFFF2A4B),
      'bannerImage': IconPath.bannerWelcome,
      'type': null,
    },
    {
      'tag': 'CRASH SENSATION',
      'title': 'AVIATOR 100X',
      'subtitle': 'FLIGHT & CASHOUT',
      'extra': 'Spribe Provably Fair',
      'ambassador': 'Play Now 🚀',
      'accent': AppColors.aviatorRed,
      'bannerImage': null,
      'iconAsset': IconPath.aviator,
      'type': GameType.aviator,
    },
    {
      'tag': 'DAILY REWARDS',
      'title': 'VIP CLUB',
      'subtitle': 'EXCLUSIVE PRIVILEGES',
      'extra': 'Personal Manager & Cashback',
      'ambassador': 'Join VIP 👑',
      'accent': AppColors.gold,
      'bannerImage': IconPath.bannerVip,
      'type': null,
    },
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % banners.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onPageChanged(int index) {
    if (_currentPage != index) {
      setState(() {
        _currentPage = index;
      });
      widget.controller.setCarouselIndex(index);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 190.h,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final b = banners[index];
              final bannerImage = b['bannerImage'] as String?;
              final iconAsset = b['iconAsset'] as String?;
              final accent = b['accent'] as Color;

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 14.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: accent.withValues(alpha: 0.35)),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.15),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background Image or Fallback Gradient
                    if (bannerImage != null)
                      Image.asset(
                        bannerImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF1E0A12), Color(0xFF0C1017)],
                            ),
                          ),
                        ),
                      )
                    else
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF2B0A12), Color(0xFF10131B)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),

                    // Luxury Dark Gradient Overlay for perfect typography readability
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.88),
                            Colors.black.withValues(alpha: 0.65),
                            Colors.black.withValues(alpha: 0.35),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),

                    // Content Information
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 8.h,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: iconAsset != null ? 6 : 1,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 2.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: accent,
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: Text(
                                      b['tag'] as String,
                                      style: AppTextStyle().boldTextStyle(
                                        fontSize: 8.5.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Text(
                                    b['title'] as String,
                                    style: AppTextStyle().boldTextStyle(
                                      fontSize: 19.sp,
                                      color: AppColors.gold,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                  Text(
                                    b['subtitle'] as String,
                                    style: AppTextStyle().boldTextStyle(
                                      fontSize: 12.5.sp,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    b['extra'] as String,
                                    style: TextStyle(
                                      fontSize: 8.sp,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  InkWell(
                                    onTap: () {
                                      final type = b['type'] as GameType?;
                                      if (type != null) {
                                        widget.controller.onGameTap(type);
                                      } else {
                                        Get.to(() => const PointsScreen());
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(6.r),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 4.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.emeraldGreen,
                                        borderRadius: BorderRadius.circular(
                                          6.r,
                                        ),
                                      ),
                                      child: Text(
                                        b['ambassador'] as String,
                                        style: AppTextStyle().boldTextStyle(
                                          fontSize: 9.sp,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (iconAsset != null) ...[
                            SizedBox(width: 8.w),
                            Expanded(
                              flex: 4,
                              child: Center(
                                child: Container(
                                  width: 56.w,
                                  height: 56.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black.withValues(alpha: 0.4),
                                    boxShadow: [
                                      BoxShadow(
                                        color: accent.withValues(alpha: 0.4),
                                        blurRadius: 20,
                                        spreadRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: Image.asset(
                                    iconAsset,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(height: 8.h),
        // Localized Dots Indicator (Zero Obx overhead)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: EdgeInsets.symmetric(horizontal: 3.w),
              width: _currentPage == i ? 18.w : 6.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: _currentPage == i
                    ? AppColors.emeraldGreen
                    : const Color(0xFF2C3545),
                borderRadius: BorderRadius.circular(3.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
