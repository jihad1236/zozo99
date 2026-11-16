import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zozo99/core/common/styles/global_text_style.dart';
import 'package:zozo99/core/models/betting_models.dart';
import 'package:zozo99/core/repositories/betting_repository.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/core/utils/constants/icon_path.dart';
import 'package:zozo99/core/utils/constants/sizer.dart';
import 'package:zozo99/features/games/aviator/presentation/screens/aviator_screen.dart';
import 'package:zozo99/features/games/puzzle/presentation/screens/puzzle_screen.dart';
import 'package:zozo99/features/games/spin/presentation/screens/spin_screen.dart';
import 'package:zozo99/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:zozo99/features/wallet/presentation/screens/deposit_screen.dart';

class HomeLobbyScreen extends StatelessWidget {
  const HomeLobbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = Get.find<BettingRepository>();

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        title: StreamBuilder<UserModel?>(
          stream: repository.currentUserStream,
          initialData: repository.currentUser,
          builder: (context, snapshot) {
            final user = snapshot.data;
            return Row(
              children: [
                CircleAvatar(
                  radius: 18.r,
                  backgroundColor: AppColors.aviatorRed,
                  child: Text(
                    user?.username.substring(0, 1).toUpperCase() ?? 'U',
                    style: AppTextStyle().boldTextStyle(fontSize: 14.sp, color: Colors.white),
                  ),
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 90.w,
                      child: Text(
                        user?.username ?? 'Gamer',
                        style: AppTextStyle().boldTextStyle(fontSize: 14.sp, color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        '${user?.tier.label.toUpperCase() ?? "SILVER"} VIP',
                        style: AppTextStyle().boldTextStyle(fontSize: 9.sp, color: AppColors.gold),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        actions: [
          // Credits Pill + Deposit Button
          StreamBuilder<WalletModel?>(
            stream: repository.walletStream,
            initialData: repository.currentWallet,
            builder: (context, snapshot) {
              final credits = snapshot.data?.creditBalance ?? 0.0;
              return Container(
                margin: EdgeInsets.only(right: 8.w),
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.darkSurface,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.bolt_rounded, color: AppColors.gold, size: 16.sp),
                    SizedBox(width: 4.w),
                    Text(
                      '${credits.toInt()}',
                      style: AppTextStyle().boldTextStyle(fontSize: 13.sp, color: Colors.white),
                    ),
                    SizedBox(width: 6.w),
                    InkWell(
                      onTap: () => Get.to(() => const DepositScreen()),
                      child: Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: const BoxDecoration(
                          color: AppColors.neonGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add, color: Colors.black, size: 12),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          // Notifications Bell
          IconButton(
            icon: const Icon(Iconsax.notification, color: Colors.white),
            onPressed: () => Get.to(() => const NotificationsScreen()),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live Winning Marquee Ticker
            _buildLiveWinningTicker(),
            SizedBox(height: 14.h),

            // Hero Promo Banner
            _buildHeroBanner(context),
            SizedBox(height: 20.h),

            // Section: Featured Games
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'HOT & FEATURED GAMES',
                  style: AppTextStyle().boldTextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: const BoxDecoration(
                        color: AppColors.neonGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '1,420 Online',
                      style: AppTextStyle().mediumTextStyle(fontSize: 11.sp, color: AppColors.neonGreen),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Game Cards
            _buildGameCard(
              title: 'Aviator Crash',
              badge: 'TRENDING 🚀',
              description: 'Real-time curve flight with multipliers up to 100X. Cash out in time!',
              accentColor: AppColors.aviatorRed,
              icon: Icons.flight_takeoff_rounded,
              imageAsset: IconPath.aviator,
              onPlay: () => Get.to(() => const AviatorScreen()),
            ),
            SizedBox(height: 12.h),

            _buildGameCard(
              title: 'Lucky Fortune Wheel',
              badge: 'DAILY SPIN 🎡',
              description: 'Spin for instant free credits, jackpot multipliers & VIP points!',
              accentColor: AppColors.gold,
              icon: Icons.album_rounded,
              imageAsset: IconPath.fortuneWheel,
              onPlay: () => Get.to(() => const SpinScreen()),
            ),
            SizedBox(height: 12.h),

            _buildGameCard(
              title: 'Cyber Match Rush',
              badge: 'PUZZLE 🧩',
              description: 'Match cyber crystals against the moves clock to win 3X rewards!',
              accentColor: AppColors.neonCyan,
              icon: Icons.extension_rounded,
              imageAsset: IconPath.puzzle,
              onPlay: () => Get.to(() => const PuzzleScreen()),
            ),
            SizedBox(height: 24.h),

            // Live Activity Feed
            Text(
              'LIVE CASINO ACTIVITY',
              style: AppTextStyle().boldTextStyle(
                fontSize: 13.sp,
                color: AppColors.darkTextSecondary,
                letterSpacing: 1.0,
              ),
            ),
            SizedBox(height: 10.h),
            _buildLiveActivityList(),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveWinningTicker() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.darkSurfaceVariant,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              'LIVE',
              style: AppTextStyle().boldTextStyle(fontSize: 9.sp, color: AppColors.gold),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'NeoMatrix cashed out 480 ⚡ on Aviator (3.2x) • Sophia won 100 ⚡ on Lucky Spin!',
              style: AppTextStyle().mediumTextStyle(fontSize: 11.sp, color: Colors.white70),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF2A4B), Color(0xFF6B1123)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.aviatorRed.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              'FEATURED CRASH GAME',
              style: AppTextStyle().boldTextStyle(fontSize: 10.sp, color: Colors.white),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'AVIATOR 100X MULTIPLIER',
            style: AppTextStyle().boldTextStyle(fontSize: 22.sp, color: Colors.white),
          ),
          SizedBox(height: 4.h),
          Text(
            'Watch the curve fly and cash out before the crash!',
            style: AppTextStyle().regularTextStyle(fontSize: 12.sp, color: Colors.white.withValues(alpha: 0.85)),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () => Get.to(() => const AviatorScreen()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'PLAY NOW 🚀',
                  style: AppTextStyle().boldTextStyle(fontSize: 13.sp, color: AppColors.aviatorRed),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard({
    required String title,
    required String badge,
    required String description,
    required Color accentColor,
    required IconData icon,
    String? imageAsset,
    required VoidCallback onPlay,
  }) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 52.w,
            height: 52.w,
            padding: EdgeInsets.all(imageAsset != null ? 10.r : 0),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: accentColor.withValues(alpha: 0.3)),
            ),
            child: imageAsset != null
                ? Image.asset(imageAsset, fit: BoxFit.contain)
                : Icon(icon, color: accentColor, size: 28.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: AppTextStyle().boldTextStyle(fontSize: 14.sp, color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        badge,
                        style: AppTextStyle().boldTextStyle(fontSize: 8.sp, color: accentColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: AppTextStyle().regularTextStyle(fontSize: 11.sp, color: AppColors.darkTextSecondary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          ElevatedButton(
            onPressed: onPlay,
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            ),
            child: Text(
              'PLAY',
              style: AppTextStyle().boldTextStyle(fontSize: 12.sp, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveActivityList() {
    final activities = [
      {'user': 'AlexRider', 'game': 'Aviator', 'win': '+320 Credits', 'color': AppColors.neonGreen},
      {'user': 'Kavita_99', 'game': 'Lucky Spin', 'win': '+100 Credits', 'color': AppColors.gold},
      {'user': 'NeoMatrix', 'game': 'Cyber Match', 'win': '+150 Credits', 'color': AppColors.neonCyan},
      {'user': 'Samurai_X', 'game': 'Aviator', 'win': '+840 Credits', 'color': AppColors.neonGreen},
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Column(
        children: activities.map((a) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.sports_esports_rounded, color: AppColors.darkTextSecondary, size: 16.sp),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          '${a['user']} (${a['game']})',
                          style: AppTextStyle().mediumTextStyle(fontSize: 12.sp, color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  a['win'] as String,
                  style: AppTextStyle().boldTextStyle(fontSize: 12.sp, color: a['color'] as Color),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
