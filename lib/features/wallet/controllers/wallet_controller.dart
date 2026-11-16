import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zozo99/core/models/betting_models.dart';
import 'package:zozo99/core/repositories/betting_repository.dart';
import 'package:zozo99/core/utils/constants/colors.dart';

class WalletController extends GetxController {
  final BettingRepository _repository = Get.find<BettingRepository>();

  // Observables
  final Rx<WalletModel?> wallet = Rx<WalletModel?>(null);
  final RxList<TransactionModel> transactions = <TransactionModel>[].obs;
  final Rx<TransactionType?> selectedFilter = Rx<TransactionType?>(null);
  final RxBool isLoading = false.obs;

  // Deposit form
  final depositAmountController = TextEditingController(text: '100');
  final depositAccountController = TextEditingController();
  final RxString selectedPaymentMethod = 'Visa/Mastercard'.obs;

  // Withdrawal form
  final withdrawAmountController = TextEditingController(text: '50');
  final withdrawAccountController = TextEditingController();
  final withdrawNameController = TextEditingController();
  final RxString selectedWithdrawMethod = 'Bank Account'.obs;

  // Conversion form
  final convertCashController = TextEditingController(text: '50');
  final convertCreditController = TextEditingController(text: '1000');

  List<TransactionModel> get filteredTransactions {
    if (selectedFilter.value == null) {
      return transactions;
    }
    return transactions.where((t) => t.type == selectedFilter.value).toList();
  }

  @override
  void onInit() {
    super.onInit();
    wallet.bindStream(_repository.walletStream);
    wallet.value = _repository.currentWallet;
    transactions.bindStream(_repository.transactionsStream);
    transactions.assignAll(_repository.transactions);
  }

  @override
  void onClose() {
    depositAmountController.dispose();
    depositAccountController.dispose();
    withdrawAmountController.dispose();
    withdrawAccountController.dispose();
    withdrawNameController.dispose();
    convertCashController.dispose();
    convertCreditController.dispose();
    super.onClose();
  }

  void setFilter(TransactionType? type) {
    selectedFilter.value = type;
  }

  Future<void> convertCashToCredits() async {
    final amount = double.tryParse(convertCashController.text.trim()) ?? 0.0;
    if (amount <= 0) {
      Get.snackbar('Invalid Amount', 'Please enter a valid cash amount to convert.',
          backgroundColor: AppColors.warning.withValues(alpha: 0.9), colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      await _repository.convertCashToCredits(amount);
      Get.back(); // close modal/sheet
      Get.snackbar(
        'Conversion Successful! ⚡',
        'Exchanged \$${amount.toStringAsFixed(2)} for ${(amount * 100).toInt()} Game Credits.',
        backgroundColor: AppColors.success.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Conversion Failed', e.toString().replaceAll('Exception: ', ''),
          backgroundColor: AppColors.error.withValues(alpha: 0.9), colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> convertCreditsToCash() async {
    final credits = double.tryParse(convertCreditController.text.trim()) ?? 0.0;
    if (credits < 100) {
      Get.snackbar('Minimum 100 Credits', 'You need at least 100 credits to convert to cash.',
          backgroundColor: AppColors.warning.withValues(alpha: 0.9), colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      await _repository.convertCreditsToCash(credits);
      Get.back();
      Get.snackbar(
        'Conversion Successful! 💵',
        'Converted ${credits.toInt()} Credits to \$${(credits / 100).toStringAsFixed(2)} Cash.',
        backgroundColor: AppColors.success.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Conversion Failed', e.toString().replaceAll('Exception: ', ''),
          backgroundColor: AppColors.error.withValues(alpha: 0.9), colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitDeposit({bool instant = true}) async {
    final amount = double.tryParse(depositAmountController.text.trim()) ?? 0.0;
    if (amount < 10) {
      Get.snackbar('Minimum Deposit', 'Minimum deposit is \$10.00.',
          backgroundColor: AppColors.warning.withValues(alpha: 0.9), colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      await _repository.createDeposit(
        amount: amount,
        paymentMethod: selectedPaymentMethod.value,
        accountNumber: depositAccountController.text.trim(),
        simulateInstantSuccess: instant,
      );
      Get.back();
      Get.snackbar(
        'Deposit Complete! 🚀',
        '\$${amount.toStringAsFixed(2)} added to your Cash balance.',
        backgroundColor: AppColors.success.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Deposit Error', e.toString().replaceAll('Exception: ', ''),
          backgroundColor: AppColors.error.withValues(alpha: 0.9), colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitWithdrawal() async {
    final amount = double.tryParse(withdrawAmountController.text.trim()) ?? 0.0;
    final account = withdrawAccountController.text.trim();
    final name = withdrawNameController.text.trim();

    if (amount < 20) {
      Get.snackbar('Minimum Withdrawal', 'Minimum withdrawal is \$20.00.',
          backgroundColor: AppColors.warning.withValues(alpha: 0.9), colorText: Colors.white);
      return;
    }
    if (account.isEmpty) {
      Get.snackbar('Required Field', 'Please provide destination account/wallet details.',
          backgroundColor: AppColors.warning.withValues(alpha: 0.9), colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      await _repository.requestWithdrawal(
        amount: amount,
        method: selectedWithdrawMethod.value,
        accountNumber: account,
        accountName: name.isNotEmpty ? name : 'User Account',
      );
      Get.back();
      Get.snackbar(
        'Request Placed! ⏳',
        'Withdrawal request for \$${amount.toStringAsFixed(2)} sent for admin approval.',
        backgroundColor: AppColors.info.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Withdrawal Failed', e.toString().replaceAll('Exception: ', ''),
          backgroundColor: AppColors.error.withValues(alpha: 0.9), colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
