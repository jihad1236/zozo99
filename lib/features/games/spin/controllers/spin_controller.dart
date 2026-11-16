import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zozo99/core/common/styles/global_text_style.dart';
import 'package:zozo99/core/repositories/betting_repository.dart';
import 'package:zozo99/core/utils/constants/colors.dart';

class SpinSegment {
  final String label;
  final double rewardCredits;
  final int rewardPoints;
  final Color color;

  const SpinSegment({
    required this.label,
    required this.rewardCredits,
    required this.rewardPoints,
    required this.color,
  });
}

class SpinController extends GetxController with GetSingleTickerProviderStateMixin {
  final BettingRepository _repository = Get.find<BettingRepository>();
  final Random _rng = Random();

  late AnimationController animController;
  late Animation<double> spinAnimation;

  final RxDouble currentRotation = 0.0.obs;
  final RxBool isSpinning = false.obs;
  final RxDouble stake = 25.0.obs;

  final List<SpinSegment> segments = const [
    SpinSegment(label: '10 Credits', rewardCredits: 10, rewardPoints: 0, color: Color(0xFF22C55E)),
    SpinSegment(label: '50 Credits', rewardCredits: 50, rewardPoints: 0, color: Color(0xFFFFB800)),
    SpinSegment(label: '25 Pts', rewardCredits: 0, rewardPoints: 25, color: Color(0xFF8B5CF6)),
    SpinSegment(label: '100 Credits', rewardCredits: 100, rewardPoints: 0, color: Color(0xFF00E5FF)),
    SpinSegment(label: 'Try Again', rewardCredits: 0, rewardPoints: 0, color: Color(0xFF4B5563)),
    SpinSegment(label: '250 Credits', rewardCredits: 250, rewardPoints: 0, color: Color(0xFFFF3366)),
    SpinSegment(label: '50 Pts', rewardCredits: 0, rewardPoints: 50, color: Color(0xFFEC4899)),
    SpinSegment(label: '2X Stake', rewardCredits: 50, rewardPoints: 10, color: Color(0xFF3B82F6)),
  ];

  @override
  void onInit() {
    super.onInit();
    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );
  }

  @override
  void onClose() {
    animController.dispose();
    super.onClose();
  }

  Future<void> spinWheel() async {
    if (isSpinning.value) return;

    final wallet = _repository.currentWallet;
    if (wallet != null && wallet.creditBalance < stake.value) {
      Get.snackbar('Insufficient Credits', 'You need at least ${stake.value.toInt()} credits to spin.',
          backgroundColor: AppColors.warning.withValues(alpha: 0.9), colorText: Colors.white);
      return;
    }

    isSpinning.value = true;

    // Pick target segment
    final targetIndex = _rng.nextInt(segments.length);
    final targetSegment = segments[targetIndex];

    final segmentAngle = (2 * pi) / segments.length;
    // Calculate final rotation (5 full spins + landing on target index under top indicator)
    final targetAngle = (5 * 2 * pi) + (targetIndex * segmentAngle) + (segmentAngle / 2);

    final startAngle = currentRotation.value % (2 * pi);
    spinAnimation = Tween<double>(begin: startAngle, end: startAngle + targetAngle).animate(
      CurvedAnimation(parent: animController, curve: Curves.easeOutCirc),
    )..addListener(() {
        currentRotation.value = spinAnimation.value;
      });

    animController.reset();
    await animController.forward();

    isSpinning.value = false;

    // Settle with server repository
    try {
      final bet = await _repository.playSpinGame(
        stake: stake.value,
        prizeLabel: targetSegment.label,
        rewardCredits: targetSegment.rewardCredits,
        rewardPoints: targetSegment.rewardPoints,
      );

      final won = bet.isWin;
      Get.dialog(
        AlertDialog(
          backgroundColor: AppColors.darkSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            won ? 'YOU WON! 🎡' : 'BETTER LUCK NEXT TIME!',
            style: AppTextStyle().boldTextStyle(
              fontSize: 18,
              color: won ? AppColors.gold : Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: targetSegment.color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.star_rounded, color: targetSegment.color, size: 40),
              ),
              const SizedBox(height: 12),
              Text(
                targetSegment.label,
                style: AppTextStyle().boldTextStyle(fontSize: 22, color: Colors.white),
              ),
              if (won) ...[
                const SizedBox(height: 8),
                Text(
                  '+${targetSegment.rewardCredits.toInt()} Credits  •  +${targetSegment.rewardPoints} Points',
                  style: AppTextStyle().boldTextStyle(fontSize: 14, color: AppColors.gold),
                ),
              ],
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Awesome!', style: AppTextStyle().boldTextStyle(fontSize: 14, color: Colors.black)),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''),
          backgroundColor: AppColors.error, colorText: Colors.white);
    }
  }
}
