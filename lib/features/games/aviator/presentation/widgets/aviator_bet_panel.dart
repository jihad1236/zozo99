import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zozo99/core/models/betting_models.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/core/utils/constants/sizer.dart';
import 'package:zozo99/features/games/aviator/controllers/aviator_controller.dart';

class AviatorBetPanel extends StatelessWidget {
  final AviatorController controller;
  final int panel; // 1 or 2

  const AviatorBetPanel({
    super.key,
    required this.controller,
    required this.panel,
  });

  @override
  Widget build(BuildContext context) {
    final stakeController = panel == 1 ? controller.stakeController1 : controller.stakeController2;
    final autoCashController = panel == 1 ? controller.autoCashoutController1 : controller.autoCashoutController2;

    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: const Color(0xFF141923),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFF222B3D)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Mode Selector: "Bet" vs "Auto"
          Obx(() {
            final mode = panel == 1 ? controller.betMode1.value : controller.betMode2.value;
            return Container(
              height: 28.h,
              decoration: BoxDecoration(
                color: const Color(0xFF0C1017),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => controller.setBetMode(panel, 'Bet'),
                      borderRadius: BorderRadius.circular(20.r),
                      child: Container(
                        decoration: BoxDecoration(
                          color: mode == 'Bet' ? const Color(0xFF252D3D) : Colors.transparent,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Bet',
                          style: TextStyle(
                            color: mode == 'Bet' ? Colors.white : Colors.white54,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => controller.setBetMode(panel, 'Auto'),
                      borderRadius: BorderRadius.circular(20.r),
                      child: Container(
                        decoration: BoxDecoration(
                          color: mode == 'Auto' ? const Color(0xFF252D3D) : Colors.transparent,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Auto',
                          style: TextStyle(
                            color: mode == 'Auto' ? Colors.white : Colors.white54,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          SizedBox(height: 8.h),

          // 2. Middle Row: Counter & Presets + Giant Action Button
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: Counter & Presets
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    // Plus / Minus Amount Box
                    Container(
                      height: 36.h,
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A0D14),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: const Color(0xFF222B3D)),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, color: Colors.white70, size: 16),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () => controller.adjustStake(panel, -10.0),
                          ),
                          Expanded(
                            child: TextField(
                              controller: stakeController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.white70, size: 16),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () => controller.adjustStake(panel, 10.0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 6.h),

                    // Quick Chips Grid (20, 50, 100, 500)
                    Row(
                      children: [
                        _buildPresetChip('20.00', 20.0),
                        SizedBox(width: 4.w),
                        _buildPresetChip('50.00', 50.0),
                        SizedBox(width: 4.w),
                        _buildPresetChip('100.00', 100.0),
                        SizedBox(width: 4.w),
                        _buildPresetChip('500.00', 500.0),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),

              // Right: Giant Action Button
              Expanded(
                flex: 5,
                child: Obx(() {
                  final round = controller.round.value;
                  final status = round.status;
                  final bet = panel == 1 ? controller.myBet1.value : controller.myBet2.value;
                  final multiplier = controller.liveMultiplier.value;
                  final isLoading = panel == 1 ? controller.isLoading1.value : controller.isLoading2.value;

                  // Bet Placed & Round Flying -> Giant CASHOUT Button
                  if (bet != null && !bet.isSettled && status == RoundStatus.running) {
                    final currentWin = bet.stake * multiplier;
                    return InkWell(
                      onTap: () => controller.cashOut(panel),
                      borderRadius: BorderRadius.circular(14.r),
                      child: Container(
                        height: 68.h,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF9100), Color(0xFFFF6D00)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(14.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF6D00).withValues(alpha: 0.5),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'CASH OUT',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              '${currentWin.toStringAsFixed(2)} CREDITS',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Bet Placed & Waiting for Next Round -> WAITING / CANCEL
                  if (bet != null && !bet.isSettled && status == RoundStatus.waiting) {
                    return InkWell(
                      onTap: () => controller.cancelBet(panel),
                      borderRadius: BorderRadius.circular(14.r),
                      child: Container(
                        height: 68.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFC2185B),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'WAITING...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              'CANCEL',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Default State: Green Giant "BET" Button
                  final stakeText = stakeController.text.trim();
                  return InkWell(
                    onTap: isLoading ? null : () => controller.placeBet(panel),
                    borderRadius: BorderRadius.circular(14.r),
                    child: Container(
                      height: 68.h,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF28A745), Color(0xFF1E7E34)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(14.r),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF28A745).withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'BET',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.8,
                            ),
                          ),
                          Text(
                            '$stakeText CREDITS',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // 3. Auto Controls Row (Auto Bet & Auto Cash Out)
          Row(
            children: [
              // Auto Bet Toggle
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Auto Bet', style: TextStyle(color: Colors.white70, fontSize: 10.sp)),
                  SizedBox(width: 4.w),
                  Obx(() {
                    final isAuto = panel == 1 ? controller.isAutoBetEnabled1.value : controller.isAutoBetEnabled2.value;
                    return Transform.scale(
                      scale: 0.7,
                      child: Switch(
                        value: isAuto,
                        onChanged: (val) => controller.toggleAutoBet(panel, val),
                        activeThumbColor: AppColors.emeraldGreen,
                        activeTrackColor: AppColors.emeraldGreen.withValues(alpha: 0.3),
                      ),
                    );
                  }),
                ],
              ),
              const Spacer(),

              // Auto Cash Out Toggle + Multiplier input
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Auto Cash Out', style: TextStyle(color: Colors.white70, fontSize: 10.sp)),
                  SizedBox(width: 4.w),
                  Obx(() {
                    final isAuto = panel == 1 ? controller.isAutoCashoutEnabled1.value : controller.isAutoCashoutEnabled2.value;
                    return Transform.scale(
                      scale: 0.7,
                      child: Switch(
                        value: isAuto,
                        onChanged: (val) => controller.toggleAutoCashout(panel, val),
                        activeThumbColor: AppColors.emeraldGreen,
                        activeTrackColor: AppColors.emeraldGreen.withValues(alpha: 0.3),
                      ),
                    );
                  }),
                  SizedBox(width: 4.w),
                  Container(
                    width: 50.w,
                    height: 24.h,
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0C1017),
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(color: const Color(0xFF222B3D)),
                    ),
                    alignment: Alignment.center,
                    child: TextField(
                      controller: autoCashController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChip(String label, double amount) {
    return Expanded(
      child: InkWell(
        onTap: () => controller.setPresetStake(panel, amount),
        borderRadius: BorderRadius.circular(6.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          decoration: BoxDecoration(
            color: const Color(0xFF0E131C),
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(color: const Color(0xFF1E2533)),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white60,
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
