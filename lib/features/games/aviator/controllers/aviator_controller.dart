import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zozo99/core/models/betting_models.dart';
import 'package:zozo99/core/repositories/betting_repository.dart';
import 'package:zozo99/core/repositories/mock_betting_repository.dart';
import 'package:zozo99/core/utils/constants/colors.dart';

class AviatorController extends GetxController {
  final BettingRepository _repository = Get.find<BettingRepository>();

  final Rx<GameRoundModel> round = Rx<GameRoundModel>(
    GameRoundModel(
      id: 'init',
      gameId: 'aviator_demo',
      status: RoundStatus.waiting,
      crashMultiplier: 2.0,
      startAt: DateTime.now(),
    ),
  );

  final RxDouble liveMultiplier = 1.00.obs;
  final RxList<double> recentCrashMultipliers = <double>[
    1.17, 3.53, 1.08, 1.28, 1.01, 1.57, 78.97, 1.64, 3.81, 2.80, 1.95, 1.06, 1.71, 5.38, 2.88, 1.24, 2.75, 2.48, 14.20
  ].obs;
  final RxList<Map<String, dynamic>> livePlayerBets = <Map<String, dynamic>>[].obs;

  // Panel 1 State
  final stakeController1 = TextEditingController(text: '20.00');
  final autoCashoutController1 = TextEditingController(text: '1.50');
  final Rx<GameBetModel?> myBet1 = Rx<GameBetModel?>(null);
  final RxBool isAutoBetEnabled1 = false.obs;
  final RxBool isAutoCashoutEnabled1 = false.obs;
  final RxString betMode1 = 'Bet'.obs; // 'Bet' or 'Auto'
  final RxBool isLoading1 = false.obs;

  // Panel 2 State
  final stakeController2 = TextEditingController(text: '50.00');
  final autoCashoutController2 = TextEditingController(text: '2.00');
  final Rx<GameBetModel?> myBet2 = Rx<GameBetModel?>(null);
  final RxBool isAutoBetEnabled2 = false.obs;
  final RxBool isAutoCashoutEnabled2 = false.obs;
  final RxString betMode2 = 'Bet'.obs;
  final RxBool isLoading2 = false.obs;

  // Active Live Panel Tab for Mobile (Panel 1 or Panel 2)
  final RxInt activePanelTab = 0.obs;

  Timer? _ticker;
  final Random _rng = Random();

  @override
  void onInit() {
    super.onInit();
    round.bindStream(_repository.aviatorRoundStream);
    round.listen((r) {
      if (r.status == RoundStatus.crashed) {
        recentCrashMultipliers.insert(0, r.crashMultiplier);
        if (recentCrashMultipliers.length > 25) {
          recentCrashMultipliers.removeLast();
        }
      }
      if (r.status == RoundStatus.waiting) {
        myBet1.value = null;
        myBet2.value = null;
        _generateSimulatedLiveBets();

        // Handle auto-bets if enabled
        if (isAutoBetEnabled1.value) {
          placeBet(1);
        }
        if (isAutoBetEnabled2.value) {
          placeBet(2);
        }
      }
    });

    _startMultiplierTracker();
  }

  @override
  void onClose() {
    _ticker?.cancel();
    stakeController1.dispose();
    autoCashoutController1.dispose();
    stakeController2.dispose();
    autoCashoutController2.dispose();
    super.onClose();
  }

  void _startMultiplierTracker() {
    _ticker = Timer.periodic(const Duration(milliseconds: 40), (_) {
      final repo = _repository;
      if (repo is MockBettingRepository) {
        liveMultiplier.value = repo.currentAviatorMultiplier;

        // Auto Cashout checks
        if (round.value.status == RoundStatus.running) {
          if (isAutoCashoutEnabled1.value && myBet1.value != null && !myBet1.value!.isSettled) {
            final target = double.tryParse(autoCashoutController1.text.trim()) ?? 1.50;
            if (liveMultiplier.value >= target) {
              cashOut(1);
            }
          }
          if (isAutoCashoutEnabled2.value && myBet2.value != null && !myBet2.value!.isSettled) {
            final target = double.tryParse(autoCashoutController2.text.trim()) ?? 2.00;
            if (liveMultiplier.value >= target) {
              cashOut(2);
            }
          }
        }
      }
    });
  }

  void _generateSimulatedLiveBets() {
    final names = [
      'CryptoSam', 'Kavita_99', 'NeoMatrix', 'PlayerX', 'DragonFly', 'Speedy88', 'AlphaBet', 'Zenith', 'Wasim_Fan', 'Titan_07'
    ];
    livePlayerBets.clear();
    for (int i = 0; i < 8; i++) {
      livePlayerBets.add({
        'user': names[_rng.nextInt(names.length)],
        'stake': (10 + _rng.nextInt(30) * 10).toDouble(),
        'cashedAt': null,
      });
    }
  }

  void setBetMode(int panel, String mode) {
    if (panel == 1) {
      betMode1.value = mode;
    } else {
      betMode2.value = mode;
    }
  }

  void setPanelTab(int tabIndex) {
    activePanelTab.value = tabIndex;
  }

  void toggleAutoBet(int panel, bool val) {
    if (panel == 1) {
      isAutoBetEnabled1.value = val;
    } else {
      isAutoBetEnabled2.value = val;
    }
  }

  void toggleAutoCashout(int panel, bool val) {
    if (panel == 1) {
      isAutoCashoutEnabled1.value = val;
    } else {
      isAutoCashoutEnabled2.value = val;
    }
  }

  void setPresetStake(int panel, double amount) {
    if (panel == 1) {
      stakeController1.text = amount.toStringAsFixed(2);
    } else {
      stakeController2.text = amount.toStringAsFixed(2);
    }
  }

  void adjustStake(int panel, double delta) {
    final controller = panel == 1 ? stakeController1 : stakeController2;
    final current = double.tryParse(controller.text.trim()) ?? 20.0;
    final next = (current + delta).clamp(10.0, 5000.0);
    controller.text = next.toStringAsFixed(2);
  }

  Future<void> placeBet(int panel) async {
    final controller = panel == 1 ? stakeController1 : stakeController2;
    final isAutoCashout = panel == 1 ? isAutoCashoutEnabled1.value : isAutoCashoutEnabled2.value;
    final autoCashController = panel == 1 ? autoCashoutController1 : autoCashoutController2;

    final stake = double.tryParse(controller.text.trim()) ?? 0.0;
    if (stake < 10) {
      _notify('Min Bet 10 Credits', 'Please enter at least 10 credits.',
          bg: AppColors.warning.withValues(alpha: 0.9));
      return;
    }

    double? autoCashout;
    if (isAutoCashout) {
      autoCashout = double.tryParse(autoCashController.text.trim());
      if (autoCashout == null || autoCashout < 1.10) {
        _notify('Auto Cashout', 'Minimum auto cashout target is 1.10x',
            bg: AppColors.warning.withValues(alpha: 0.9));
        return;
      }
    }

    try {
      if (panel == 1) isLoading1.value = true;
      if (panel == 2) isLoading2.value = true;

      final bet = await _repository.placeAviatorBet(
        stake: stake,
        autoCashout: autoCashout,
      );

      if (panel == 1) {
        myBet1.value = bet;
      } else {
        myBet2.value = bet;
      }

      _notify('Bet Placed! 🚀', '${stake.toStringAsFixed(2)} Credits placed on Panel $panel.',
          bg: AppColors.success.withValues(alpha: 0.9));
    } catch (e) {
      _notify('Error', e.toString().replaceAll('Exception: ', ''),
          bg: AppColors.error.withValues(alpha: 0.9));
    } finally {
      if (panel == 1) isLoading1.value = false;
      if (panel == 2) isLoading2.value = false;
    }
  }

  Future<void> cashOut(int panel) async {
    final bet = panel == 1 ? myBet1.value : myBet2.value;
    if (bet == null || bet.isSettled) return;

    try {
      final settledBet = await _repository.cashoutAviatorBet(
        betId: bet.id,
        currentMultiplier: liveMultiplier.value,
      );
      if (panel == 1) {
        myBet1.value = settledBet;
      } else {
        myBet2.value = settledBet;
      }
      _notify('CASHED OUT! 🎉', 'Won ${settledBet.payout.toStringAsFixed(2)} Credits at ${settledBet.cashedMultiplier?.toStringAsFixed(2)}x',
          bg: AppColors.emeraldGreen, text: Colors.black);
    } catch (e) {
      _notify('Cashout Failed', e.toString().replaceAll('Exception: ', ''),
          bg: AppColors.error.withValues(alpha: 0.9));
    }
  }

  Future<void> cancelBet(int panel) async {
    final bet = panel == 1 ? myBet1.value : myBet2.value;
    if (bet != null && round.value.status == RoundStatus.waiting) {
      if (panel == 1) myBet1.value = null;
      if (panel == 2) myBet2.value = null;
      _notify('Bet Cancelled', 'Your bet on Panel $panel was returned.',
          bg: Colors.white12);
    }
  }

  void _notify(String title, String message, {Color? bg, Color? text}) {
    if (Get.context != null) {
      Get.snackbar(
        title,
        message,
        backgroundColor: bg ?? AppColors.success.withValues(alpha: 0.9),
        colorText: text ?? Colors.white,
      );
    }
  }
}
