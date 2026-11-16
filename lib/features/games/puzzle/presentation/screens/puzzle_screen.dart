import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zozo99/core/common/styles/global_text_style.dart';
import 'package:zozo99/core/models/betting_models.dart';
import 'package:zozo99/core/repositories/betting_repository.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/core/utils/constants/icon_path.dart';
import 'package:zozo99/core/utils/constants/sizer.dart';
import 'package:zozo99/features/games/puzzle/controllers/puzzle_controller.dart';

class PuzzleScreen extends StatelessWidget {
  const PuzzleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PuzzleController());
    final repository = Get.find<BettingRepository>();

    return Scaffold(
      backgroundColor: const Color(0xFF0F111A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141724),
        elevation: 0,
        title: Row(
          children: [
            Image.asset(IconPath.puzzle, width: 22.sp, height: 22.sp, fit: BoxFit.contain),
            SizedBox(width: 8.w),
            Text(
              'Cyber Match Rush',
              style: AppTextStyle().boldTextStyle(fontSize: 18.sp, color: Colors.white),
            ),
          ],
        ),
        actions: [
          StreamBuilder<WalletModel?>(
            stream: repository.walletStream,
            initialData: repository.currentWallet,
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
                      '${credits.toInt()} ⚡',
                      style: AppTextStyle().boldTextStyle(fontSize: 12.sp, color: Colors.white),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          children: [
            // Game Stats Bar
            _buildStatsBar(controller),
            SizedBox(height: 16.h),

            // 4x4 Cyber Puzzle Matrix
            _buildPuzzleGrid(controller),
            SizedBox(height: 20.h),

            // Stake selection & controls
            _buildControls(controller),
            SizedBox(height: 16.h),

            // Rules Card
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: const Color(0xFF181C2B),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: AppColors.darkBorder),
              ),
              child: Row(
                children: [
                  Icon(Iconsax.info_circle, color: AppColors.neonCyan, size: 20.sp),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      'Swap adjacent tiles to match 3 identical gems. Score 80+ points within 12 moves to win 2X to 3X credits!',
                      style: AppTextStyle().regularTextStyle(fontSize: 11.sp, color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsBar(PuzzleController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF181C2B),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.neonCyan.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('SCORE', controller.score, AppColors.gold),
          Container(height: 28.h, width: 1, color: AppColors.darkBorder),
          _buildStatItem('MOVES LEFT', controller.movesLeft, AppColors.neonCyan),
          Container(height: 28.h, width: 1, color: AppColors.darkBorder),
          Column(
            children: [
              Text('TARGET', style: AppTextStyle().boldTextStyle(fontSize: 10.sp, color: AppColors.darkTextSecondary)),
              SizedBox(height: 2.h),
              Text('80 PTS', style: AppTextStyle().boldTextStyle(fontSize: 16.sp, color: AppColors.neonGreen)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, RxInt val, Color color) {
    return Column(
      children: [
        Text(label, style: AppTextStyle().boldTextStyle(fontSize: 10.sp, color: AppColors.darkTextSecondary)),
        SizedBox(height: 2.h),
        Obx(
          () => Text(
            val.value.toString(),
            style: AppTextStyle().boldTextStyle(fontSize: 18.sp, color: color),
          ),
        ),
      ],
    );
  }

  Widget _buildPuzzleGrid(PuzzleController controller) {
    return Container(
      width: 320.w,
      height: 320.w,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: const Color(0xFF141724),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFF252A3D), width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonCyan.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Obx(
        () => GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: controller.grid.length,
          itemBuilder: (context, index) {
            final gemType = controller.grid[index];
            final isSelected = controller.selectedIndex.value == index;
            final color = controller.gemColors[gemType];
            final icon = controller.gemIcons[gemType];

            return GestureDetector(
              onTap: () => controller.onTileTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected ? color.withValues(alpha: 0.35) : const Color(0xFF1F2436),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSelected ? Colors.white : color.withValues(alpha: 0.4),
                    width: isSelected ? 2.5 : 1.2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: color.withValues(alpha: 0.6),
                            blurRadius: 12,
                          ),
                        ]
                      : null,
                ),
                child: Icon(icon, color: color, size: 28.sp),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildControls(PuzzleController controller) {
    final stakes = [20.0, 50.0, 100.0, 200.0];

    return Column(
      children: [
        Obx(() {
          if (controller.isPlaying.value) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Text(
                'Stake: ${controller.currentStake.value.toInt()} Credits  •  Make matches!',
                style: AppTextStyle().boldTextStyle(fontSize: 14.sp, color: AppColors.gold),
              ),
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: stakes.map((s) {
              final isSelected = controller.currentStake.value == s;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: InkWell(
                  onTap: () => controller.setStake(s),
                  borderRadius: BorderRadius.circular(10.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.neonCyan : const Color(0xFF1F2436),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: isSelected ? AppColors.neonCyan : AppColors.darkBorder,
                      ),
                    ),
                    child: Text(
                      '${s.toInt()} ⚡',
                      style: AppTextStyle().boldTextStyle(
                        fontSize: 12.sp,
                        color: isSelected ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }),
        SizedBox(height: 14.h),
        Obx(
          () => SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: controller.isPlaying.value ? null : controller.startGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.neonCyan,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                elevation: 6,
                shadowColor: AppColors.neonCyan.withValues(alpha: 0.4),
              ),
              child: Text(
                controller.isPlaying.value ? 'GAME IN PROGRESS' : 'PLAY FOR ${controller.currentStake.value.toInt()} CREDITS',
                style: AppTextStyle().boldTextStyle(
                  fontSize: 14.sp,
                  color: Colors.black,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
