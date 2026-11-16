import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zozo99/core/common/styles/global_text_style.dart';
import 'package:zozo99/core/models/betting_models.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/core/utils/constants/sizer.dart';
import 'package:zozo99/features/landing/controllers/landing_controller.dart';

class LandingGamesGrid extends StatelessWidget {
  final LandingController controller;

  const LandingGamesGrid({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Category Header & Sorting Bar
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          child: Row(
            children: [
              Obx(() => Text(
                    '${controller.selectedCategory.value} Games',
                    style: AppTextStyle().boldTextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                  )),
              SizedBox(width: 8.w),
              Obx(() {
                final count = controller.filteredGames.length;
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B2332),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: const Color(0xFF2C3545)),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      color: AppColors.emeraldGreen,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),
              const Spacer(),

              // Category Wise Sort Selector
              Obx(() {
                final currentSort = controller.selectedSort.value;
                return PopupMenuButton<String>(
                  color: const Color(0xFF141923),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: const BorderSide(color: Color(0xFF222B3D)),
                  ),
                  initialValue: currentSort,
                  onSelected: controller.selectSort,
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'Recommended',
                      child: Text('Recommended', style: TextStyle(color: Colors.white, fontSize: 13)),
                    ),
                    const PopupMenuItem(
                      value: 'Highest Multiplier',
                      child: Text('Highest Multiplier', style: TextStyle(color: Colors.white, fontSize: 13)),
                    ),
                    const PopupMenuItem(
                      value: 'A - Z',
                      child: Text('A - Z Name', style: TextStyle(color: Colors.white, fontSize: 13)),
                    ),
                  ],
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141923),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: const Color(0xFF222B3D)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.sort_rounded, color: AppColors.emeraldGreen, size: 14.sp),
                        SizedBox(width: 4.w),
                        Text(
                          currentSort,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(Icons.arrow_drop_down, color: Colors.white54, size: 16.sp),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),

        // 3-Column Games Grid
        Obx(() {
          final games = controller.filteredGames;
          final showAll = controller.showAllGames.value;
          final displayCount = showAll ? games.length : (games.length > 6 ? 6 : games.length);

          if (games.isEmpty) {
            return Container(
              height: 180.h,
              alignment: Alignment.center,
              child: Text(
                'No games found for this category',
                style: TextStyle(color: Colors.white38, fontSize: 13.sp),
              ),
            );
          }

          return GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8.w,
              mainAxisSpacing: 10.h,
              childAspectRatio: 0.72,
            ),
            itemCount: displayCount,
            itemBuilder: (context, index) {
              final game = games[index];
              return _buildGameCard(game);
            },
          );
        }),

        // "More" / "Show Less" Button
        Obx(() {
          final totalGames = controller.filteredGames.length;
          if (totalGames <= 6) return const SizedBox.shrink();

          final showAll = controller.showAllGames.value;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            child: Center(
              child: InkWell(
                onTap: controller.toggleShowAllGames,
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: AppColors.emeraldGreen,
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.emeraldGreen.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        showAll ? 'Show Less' : 'More ($totalGames)',
                        style: AppTextStyle().boldTextStyle(fontSize: 13.sp, color: Colors.black),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        showAll ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                        color: Colors.black,
                        size: 16.sp,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildGameCard(Map<String, dynamic> game) {
    final title = game['title'] as String;
    final provider = game['provider'] as String;
    final multiplier = game['multiplier'] as String;
    final accent = game['accent'] as Color? ?? AppColors.emeraldGreen;
    final assetIcon = game['assetIcon'] as String?;
    final networkImage = game['networkImage'] as String?;
    final type = game['type'] as GameType? ?? GameType.aviator;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => controller.onGameTap(type),
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF131722),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFF222B3D), width: 1.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. Background Network Seed Image
              if (networkImage != null)
                Image.network(
                  networkImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [accent.withValues(alpha: 0.35), const Color(0xFF0F131C)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),

              // 2. High Quality Dark Gradient Overlay
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0x33000000),
                      Color(0x7705080E),
                      Color(0xEE090D15),
                      Color(0xFF090D15),
                    ],
                    stops: [0.0, 0.45, 0.82, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              // 3. Center Graphic / Asset Icon
              if (assetIcon != null)
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 24.h),
                    child: Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withValues(alpha: 0.25),
                        boxShadow: [
                          BoxShadow(
                            color: accent.withValues(alpha: 0.35),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        assetIcon,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

              // 4. Top Badges Row (Multiplier & Corner Logo)
              Positioned(
                top: 6.h,
                left: 6.w,
                right: 6.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Multiplier Badge
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(
                          color: multiplier == 'JACKPOT' ? AppColors.gold : accent.withValues(alpha: 0.8),
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        multiplier,
                        style: TextStyle(
                          color: multiplier == 'JACKPOT' ? AppColors.gold : Colors.white,
                          fontSize: 8.5.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    // zozo corner stamp
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                      child: Text(
                        'zozo',
                        style: TextStyle(
                          color: AppColors.emeraldGreen,
                          fontSize: 7.5.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 5. Bottom Title & Provider Information (Pixel-Perfect Alignment)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(6.w, 6.h, 6.w, 6.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0C1017).withValues(alpha: 0.95),
                    border: Border(
                      top: BorderSide(color: Colors.white.withValues(alpha: 0.08), width: 0.8),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Container(
                            width: 4.w,
                            height: 4.w,
                            decoration: BoxDecoration(
                              color: accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              provider,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
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
      ),
    );
  }
}
