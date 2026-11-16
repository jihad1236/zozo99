import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zozo99/core/models/betting_models.dart';
import 'package:zozo99/core/repositories/betting_repository.dart';
import 'package:zozo99/core/utils/constants/colors.dart';

class PointsController extends GetxController {
  final BettingRepository _repository = Get.find<BettingRepository>();

  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxList<PointsLedgerModel> ledger = <PointsLedgerModel>[].obs;
  final RxBool isLoading = false.obs;

  final redeemController = TextEditingController(text: '500');

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_repository.currentUserStream);
    user.value = _repository.currentUser;
    ledger.bindStream(_repository.pointsLedgerStream);
    ledger.assignAll(_repository.pointsLedger);
  }

  @override
  void onClose() {
    redeemController.dispose();
    super.onClose();
  }

  int get currentPoints => user.value?.points ?? 0;
  VipTier get currentTier => user.value?.tier ?? VipTier.silver;

  double get tierProgress {
    final pts = currentPoints;
    if (pts >= VipTier.diamond.minPoints) return 1.0;
    if (pts >= VipTier.gold.minPoints) {
      final range = VipTier.diamond.minPoints - VipTier.gold.minPoints;
      final current = pts - VipTier.gold.minPoints;
      return (current / range).clamp(0.0, 1.0);
    }
    final range = VipTier.gold.minPoints - VipTier.silver.minPoints;
    return (pts / range).clamp(0.0, 1.0);
  }

  int get pointsToNextTier {
    final pts = currentPoints;
    if (pts >= VipTier.diamond.minPoints) return 0;
    if (pts >= VipTier.gold.minPoints) {
      return VipTier.diamond.minPoints - pts;
    }
    return VipTier.gold.minPoints - pts;
  }

  String get nextTierName {
    if (currentTier == VipTier.silver) return 'Gold';
    if (currentTier == VipTier.gold) return 'Diamond';
    return 'Max Tier';
  }

  Future<void> redeemPoints() async {
    final pts = int.tryParse(redeemController.text.trim()) ?? 0;
    if (pts < 100) {
      Get.snackbar('Minimum 100 Points', 'You need at least 100 VIP points to redeem credits.',
          backgroundColor: AppColors.warning.withValues(alpha: 0.9), colorText: Colors.white);
      return;
    }
    if (pts > currentPoints) {
      Get.snackbar('Insufficient Points', 'You have $currentPoints points available.',
          backgroundColor: AppColors.warning.withValues(alpha: 0.9), colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      await _repository.redeemPointsToCredits(pts);
      Get.back();
      Get.snackbar(
        'Redeemed Successfully! 🎁',
        'Converted $pts Points into ${(pts / 10).toInt()} Game Credits.',
        backgroundColor: AppColors.success.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Redemption Failed', e.toString().replaceAll('Exception: ', ''),
          backgroundColor: AppColors.error.withValues(alpha: 0.9), colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
