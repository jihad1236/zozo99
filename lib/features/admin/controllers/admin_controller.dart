import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zozo99/core/models/betting_models.dart';
import 'package:zozo99/core/repositories/betting_repository.dart';
import 'package:zozo99/core/utils/constants/colors.dart';

class AdminController extends GetxController {
  final BettingRepository _repository = Get.find<BettingRepository>();

  final RxList<UserModel> users = <UserModel>[].obs;
  final RxList<WithdrawalRequestModel> withdrawalRequests = <WithdrawalRequestModel>[].obs;
  final RxList<GameModel> games = <GameModel>[].obs;
  final RxList<AdminActionModel> auditLogs = <AdminActionModel>[].obs;
  final RxList<TransactionModel> transactions = <TransactionModel>[].obs;
  final RxBool isLoading = false.obs;

  // Adjustment form
  final adjustCashController = TextEditingController(text: '0');
  final adjustCreditController = TextEditingController(text: '0');
  final adjustPointsController = TextEditingController(text: '0');
  final adjustReasonController = TextEditingController();

  // Stake config
  final minStakeController = TextEditingController();
  final maxStakeController = TextEditingController();

  int get totalUsers => users.length;
  int get activeUsers => users.where((u) => u.status == UserStatus.active).length;
  int get blockedUsers => users.where((u) => u.status == UserStatus.blocked).length;

  int get pendingWithdrawalsCount =>
      withdrawalRequests.where((r) => r.status == TransactionStatus.pending).length;

  double get totalDeposits =>
      transactions.where((t) => t.type == TransactionType.deposit).fold(0.0, (acc, t) => acc + t.amount);

  double get totalWithdrawals =>
      transactions.where((t) => t.type == TransactionType.withdrawal && t.status == TransactionStatus.completed).fold(0.0, (acc, t) => acc + t.amount);

  @override
  void onInit() {
    super.onInit();
    users.bindStream(_repository.allUsersStream);
    users.assignAll(_repository.allUsers);

    withdrawalRequests.bindStream(_repository.allWithdrawalRequestsStream);

    games.bindStream(_repository.gamesStream);
    games.assignAll(_repository.games);

    auditLogs.bindStream(_repository.adminAuditLogsStream);

    transactions.bindStream(_repository.transactionsStream);
    transactions.assignAll(_repository.transactions);
  }

  @override
  void onClose() {
    adjustCashController.dispose();
    adjustCreditController.dispose();
    adjustPointsController.dispose();
    adjustReasonController.dispose();
    minStakeController.dispose();
    maxStakeController.dispose();
    super.onClose();
  }

  Future<void> toggleBlock(String uid) async {
    try {
      isLoading.value = true;
      await _repository.toggleUserBlock(uid);
      Get.snackbar('Status Updated', 'User account status changed.',
          backgroundColor: AppColors.info, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''),
          backgroundColor: AppColors.error, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitBalanceAdjustment(String targetUid) async {
    final cash = double.tryParse(adjustCashController.text.trim()) ?? 0.0;
    final credits = double.tryParse(adjustCreditController.text.trim()) ?? 0.0;
    final pts = int.tryParse(adjustPointsController.text.trim()) ?? 0;
    final reason = adjustReasonController.text.trim();

    if (reason.isEmpty) {
      Get.snackbar('Reason Required', 'Every admin adjustment must record an audit reason.',
          backgroundColor: AppColors.warning, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      await _repository.adjustUserBalance(
        targetUid: targetUid,
        cashDelta: cash,
        creditDelta: credits,
        pointsDelta: pts,
        reason: reason,
      );
      Get.back();
      adjustCashController.text = '0';
      adjustCreditController.text = '0';
      adjustPointsController.text = '0';
      adjustReasonController.clear();
      Get.snackbar('Adjustment Applied', 'Ledger balance and audit record created.',
          backgroundColor: AppColors.success, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''),
          backgroundColor: AppColors.error, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> approveWithdrawal(String requestId) async {
    try {
      isLoading.value = true;
      await _repository.approveWithdrawal(requestId);
      Get.snackbar('Approved', 'Withdrawal request approved and processed.',
          backgroundColor: AppColors.success, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''),
          backgroundColor: AppColors.error, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> rejectWithdrawal(String requestId, String reason) async {
    try {
      isLoading.value = true;
      await _repository.rejectWithdrawal(requestId, reason);
      Get.snackbar('Rejected', 'Withdrawal rejected and balance refunded to user.',
          backgroundColor: AppColors.warning, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''),
          backgroundColor: AppColors.error, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleGame(String gameId) async {
    try {
      isLoading.value = true;
      await _repository.toggleGameStatus(gameId);
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''),
          backgroundColor: AppColors.error, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateGameStakes(String gameId) async {
    final minS = double.tryParse(minStakeController.text.trim()) ?? 10.0;
    final maxS = double.tryParse(maxStakeController.text.trim()) ?? 1000.0;

    try {
      isLoading.value = true;
      await _repository.updateGameStakes(gameId, minS, maxS);
      Get.back();
      Get.snackbar('Game Config Updated', 'Min and Max stakes adjusted.',
          backgroundColor: AppColors.success, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''),
          backgroundColor: AppColors.error, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
