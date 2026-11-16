import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zozo99/core/common/styles/global_text_style.dart';
import 'package:zozo99/core/repositories/betting_repository.dart';
import 'package:zozo99/core/utils/constants/colors.dart';

class PuzzleController extends GetxController {
  final BettingRepository _repository = Get.find<BettingRepository>();
  final Random _rng = Random();

  final RxInt score = 0.obs;
  final RxInt movesLeft = 12.obs;
  final RxDouble currentStake = 50.0.obs;
  final RxBool isPlaying = false.obs;
  final RxBool isLoading = false.obs;

  // 4x4 Matrix of Gem Symbols (0 to 4)
  final RxList<int> grid = <int>[].obs;
  final Rx<int?> selectedIndex = Rx<int?>(null);

  final List<Color> gemColors = [
    AppColors.neonCyan,
    AppColors.aviatorRed,
    AppColors.gold,
    AppColors.neonGreen,
    AppColors.neonPurple,
  ];

  final List<IconData> gemIcons = [
    Icons.diamond,
    Icons.offline_bolt,
    Icons.star,
    Icons.shield,
    Icons.favorite,
  ];

  @override
  void onInit() {
    super.onInit();
    _initGrid();
  }

  void _initGrid() {
    grid.clear();
    for (int i = 0; i < 16; i++) {
      grid.add(_rng.nextInt(5));
    }
  }

  void setStake(double val) {
    if (!isPlaying.value) {
      currentStake.value = val;
    }
  }

  Future<void> startGame() async {
    final wallet = _repository.currentWallet;
    if (wallet != null && wallet.creditBalance < currentStake.value) {
      Get.snackbar('Insufficient Credits', 'Please deposit or convert cash to credits.',
          backgroundColor: AppColors.warning.withValues(alpha: 0.9), colorText: Colors.white);
      return;
    }

    score.value = 0;
    movesLeft.value = 12;
    selectedIndex.value = null;
    _initGrid();
    isPlaying.value = true;
  }

  void onTileTap(int index) {
    if (!isPlaying.value || movesLeft.value <= 0) return;

    if (selectedIndex.value == null) {
      selectedIndex.value = index;
    } else {
      final prev = selectedIndex.value!;
      if (prev == index) {
        selectedIndex.value = null;
        return;
      }

      // Check adjacency
      if (_isAdjacent(prev, index)) {
        // Swap
        final temp = grid[prev];
        grid[prev] = grid[index];
        grid[index] = temp;
        movesLeft.value--;

        // Check Matches
        final pointsEarned = _checkAndClearMatches();
        if (pointsEarned > 0) {
          score.value += pointsEarned;
        }

        selectedIndex.value = null;

        // Check Game Over
        if (movesLeft.value <= 0) {
          _finishGame();
        }
      } else {
        selectedIndex.value = index;
      }
    }
  }

  bool _isAdjacent(int i1, int i2) {
    final r1 = i1 ~/ 4;
    final c1 = i1 % 4;
    final r2 = i2 ~/ 4;
    final c2 = i2 % 4;
    return (r1 == r2 && (c1 - c2).abs() == 1) || (c1 == c2 && (r1 - r2).abs() == 1);
  }

  int _checkAndClearMatches() {
    int earned = 0;
    final toClear = <int>{};

    // Horizontal check
    for (int r = 0; r < 4; r++) {
      for (int c = 0; c < 2; c++) {
        final idx = r * 4 + c;
        if (grid[idx] == grid[idx + 1] && grid[idx] == grid[idx + 2]) {
          toClear.addAll([idx, idx + 1, idx + 2]);
          earned += 30;
        }
      }
    }

    // Vertical check
    for (int c = 0; c < 4; c++) {
      for (int r = 0; r < 2; r++) {
        final idx = r * 4 + c;
        if (grid[idx] == grid[idx + 4] && grid[idx] == grid[idx + 8]) {
          toClear.addAll([idx, idx + 4, idx + 8]);
          earned += 30;
        }
      }
    }

    if (toClear.isNotEmpty) {
      for (final idx in toClear) {
        grid[idx] = _rng.nextInt(5); // replenish
      }
    } else {
      // Small bonus anyway for moves
      earned += 5;
    }

    return earned;
  }

  Future<void> _finishGame() async {
    isPlaying.value = false;
    final won = score.value >= 80;

    try {
      isLoading.value = true;
      final bet = await _repository.playPuzzleGame(
        stake: currentStake.value,
        score: score.value,
        moves: 12 - movesLeft.value,
        won: won,
      );

      if (won) {
        Get.dialog(
          AlertDialog(
            backgroundColor: AppColors.darkSurface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                const Icon(Icons.emoji_events, color: AppColors.gold, size: 28),
                const SizedBox(width: 8),
                Text('PUZZLE MASTER! 🎉', style: AppTextStyle().boldTextStyle(fontSize: 18, color: AppColors.gold)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Final Score: ${score.value}', style: AppTextStyle().boldTextStyle(fontSize: 16, color: Colors.white)),
                const SizedBox(height: 6),
                Text('Stake: ${currentStake.value.toInt()} Credits', style: AppTextStyle().regularTextStyle(fontSize: 13, color: AppColors.darkTextSecondary)),
                Text('Multiplier: ${bet.cashoutMultiplier.toStringAsFixed(1)}X', style: AppTextStyle().boldTextStyle(fontSize: 14, color: AppColors.neonGreen)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Won +${bet.payout.toInt()} Credits!', style: AppTextStyle().boldTextStyle(fontSize: 18, color: AppColors.gold)),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                  startGame();
                },
                child: Text('Play Again', style: AppTextStyle().boldTextStyle(fontSize: 14, color: AppColors.neonCyan)),
              ),
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold),
                child: Text('Collect', style: AppTextStyle().boldTextStyle(fontSize: 14, color: Colors.black)),
              ),
            ],
          ),
        );
      } else {
        Get.snackbar('Game Over', 'You scored ${score.value} pts (needed 80 pts to win). Try again!',
            backgroundColor: AppColors.darkSurface, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''),
          backgroundColor: AppColors.error, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
