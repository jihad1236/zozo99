import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zozo99/core/common/styles/global_text_style.dart';
import 'package:zozo99/core/models/betting_models.dart';
import 'package:zozo99/core/repositories/betting_repository.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/core/utils/constants/icon_path.dart';
import 'package:zozo99/core/utils/constants/sizer.dart';
import 'package:zozo99/features/games/aviator/presentation/screens/aviator_screen.dart';
import 'package:zozo99/features/games/puzzle/presentation/screens/puzzle_screen.dart';
import 'package:zozo99/features/games/spin/presentation/screens/spin_screen.dart';

class GamesHubScreen extends StatefulWidget {
  const GamesHubScreen({super.key});

  @override
  State<GamesHubScreen> createState() => _GamesHubScreenState();
}

class _GamesHubScreenState extends State<GamesHubScreen> {
  final BettingRepository _repository = Get.find<BettingRepository>();
  String selectedCategory = 'ALL';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        title: Text(
          'Games Arena',
          style: AppTextStyle().boldTextStyle(fontSize: 20.sp, color: Colors.white),
        ),
        actions: [
          StreamBuilder<WalletModel?>(
            stream: _repository.walletStream,
            initialData: _repository.currentWallet,
            builder: (context, snapshot) {
              final credits = snapshot.data?.creditBalance ?? 0.0;
              return Container(
                margin: EdgeInsets.only(right: 14.w),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.darkSurface,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.bolt_rounded, color: AppColors.gold, size: 16.sp),
                    SizedBox(width: 4.w),
                    Text(
                      '${credits.toInt()} Credits',
                      style: AppTextStyle().boldTextStyle(fontSize: 12.sp, color: Colors.white),
                    ),
                  ],
                ),
              );
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
              // Category Filter Pills
              _buildCategoryPills(),
              SizedBox(height: 16.h),

              // Game Cards with RepaintBoundary
              if (selectedCategory == 'ALL' || selectedCategory == 'CRASH') ...[
                RepaintBoundary(
                  child: _buildGameHubCard(
                    title: 'Aviator Crash',
                    badge: 'HOTTEST 🔥',
                    multiplier: 'Up to 100X',
                    minStake: 10,
                    maxStake: 5000,
                    accentColor: AppColors.aviatorRed,
                    icon: Icons.flight_takeoff_rounded,
                    imageAsset: IconPath.aviator,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2C141D), Color(0xFF131722)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    onTap: () => Get.to(() => const AviatorScreen()),
                  ),
                ),
                SizedBox(height: 14.h),
              ],

              if (selectedCategory == 'ALL' || selectedCategory == 'ARCADE') ...[
                RepaintBoundary(
                  child: _buildGameHubCard(
                    title: 'Cyber Match Rush',
                    badge: 'ARCADE 🧩',
                    multiplier: 'Up to 3.5X',
                    minStake: 20,
                    maxStake: 2000,
                    accentColor: AppColors.neonCyan,
                    icon: Icons.extension_rounded,
                    imageAsset: IconPath.puzzle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF12232F), Color(0xFF131722)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    onTap: () => Get.to(() => const PuzzleScreen()),
                  ),
                ),
                SizedBox(height: 14.h),
              ],

              if (selectedCategory == 'ALL' || selectedCategory == 'WHEEL') ...[
                RepaintBoundary(
                  child: _buildGameHubCard(
                    title: 'Lucky Fortune Wheel',
                    badge: 'DAILY WHEEL 🎡',
                    multiplier: 'Win Free Credits',
                    minStake: 25,
                    maxStake: 2500,
                    accentColor: AppColors.gold,
                    icon: Icons.album_rounded,
                    imageAsset: IconPath.fortuneWheel,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2A2213), Color(0xFF131722)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    onTap: () => Get.to(() => const SpinScreen()),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryPills() {
    final categories = ['ALL', 'CRASH', 'ARCADE', 'WHEEL'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          final isSelected = selectedCategory == cat;
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: ChoiceChip(
              selected: isSelected,
              label: Text(cat),
              labelStyle: AppTextStyle().boldTextStyle(
                fontSize: 11.sp,
                color: isSelected ? Colors.white : AppColors.darkTextSecondary,
              ),
              backgroundColor: AppColors.darkSurface,
              selectedColor: AppColors.aviatorRed,
              onSelected: (_) {
                setState(() {
                  selectedCategory = cat;
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGameHubCard({
    required String title,
    required String badge,
    required String multiplier,
    required int minStake,
    required int maxStake,
    required Color accentColor,
    required IconData icon,
    String? imageAsset,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: gradient,
        border: Border.all(color: accentColor.withValues(alpha: 0.3)),
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52.w,
                height: 52.w,
                padding: EdgeInsets.all(imageAsset != null ? 8.r : 12.r),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14.r),
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
                            style: AppTextStyle().boldTextStyle(fontSize: 16.sp, color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            badge,
                            style: AppTextStyle().boldTextStyle(fontSize: 9.sp, color: accentColor),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Potential: $multiplier',
                      style: AppTextStyle().boldTextStyle(fontSize: 12.sp, color: accentColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          const Divider(height: 1, color: AppColors.darkBorder),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Min: $minStake ⚡  •  Max: $maxStake ⚡',
                  style: AppTextStyle().regularTextStyle(fontSize: 11.sp, color: AppColors.darkTextSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
              ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                ),
                child: Text(
                  'ENTER ARENA',
                  style: AppTextStyle().boldTextStyle(fontSize: 12.sp, color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
