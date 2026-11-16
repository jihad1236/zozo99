import 'package:zozo99/core/models/betting_models.dart';

abstract class BettingRepository {
  // ─── Auth & Profile ──────────────────────────────────────────────
  Stream<UserModel?> get currentUserStream;
  UserModel? get currentUser;
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({
    required String email,
    required String phone,
    required String username,
    required String password,
  });
  Future<void> updateProfile({String? username, String? phone, String? avatarUrl});
  Future<void> logout();
  Future<void> switchDemoRole(UserRole role);

  // ─── Wallet & Ledger ─────────────────────────────────────────────
  Stream<WalletModel?> get walletStream;
  WalletModel? get currentWallet;
  Stream<List<TransactionModel>> get transactionsStream;
  List<TransactionModel> get transactions;
  Future<void> convertCashToCredits(double cashAmount);
  Future<void> convertCreditsToCash(double creditAmount);

  // ─── Deposit & Withdrawal ─────────────────────────────────────────
  Stream<List<DepositRequestModel>> get depositRequestsStream;
  Future<DepositRequestModel> createDeposit({
    required double amount,
    required String paymentMethod,
    required String accountNumber,
    bool simulateInstantSuccess = true,
  });

  Stream<List<WithdrawalRequestModel>> get withdrawalRequestsStream;
  Future<WithdrawalRequestModel> requestWithdrawal({
    required double amount,
    required String method,
    required String accountNumber,
    required String accountName,
  });

  // ─── Games ───────────────────────────────────────────────────────
  Stream<List<GameModel>> get gamesStream;
  List<GameModel> get games;
  Stream<List<GameBetModel>> get gameBetsStream;
  List<GameBetModel> get gameBets;

  // Aviator
  Stream<GameRoundModel> get aviatorRoundStream;
  GameRoundModel get currentAviatorRound;
  Future<GameBetModel> placeAviatorBet({
    required double stake,
    double? autoCashout,
  });
  Future<GameBetModel> cashoutAviatorBet({
    required String betId,
    required double currentMultiplier,
  });

  // Puzzle
  Future<GameBetModel> playPuzzleGame({
    required double stake,
    required int score,
    required int moves,
    required bool won,
  });

  // Lucky Spin
  Future<GameBetModel> playSpinGame({
    required double stake,
    required String prizeLabel,
    required double rewardCredits,
    required int rewardPoints,
  });

  // ─── Points & Tiers ──────────────────────────────────────────────
  Stream<List<PointsLedgerModel>> get pointsLedgerStream;
  List<PointsLedgerModel> get pointsLedger;
  Future<void> redeemPointsToCredits(int points);

  // ─── Notifications ───────────────────────────────────────────────
  Stream<List<AppNotificationModel>> get notificationsStream;
  Future<void> markNotificationAsRead(String id);
  Future<void> clearAllNotifications();

  // ─── Admin Management ────────────────────────────────────────────
  Stream<List<UserModel>> get allUsersStream;
  List<UserModel> get allUsers;
  Stream<List<WithdrawalRequestModel>> get allWithdrawalRequestsStream;
  Stream<List<AdminActionModel>> get adminAuditLogsStream;

  Future<void> toggleUserBlock(String uid);
  Future<void> adjustUserBalance({
    required String targetUid,
    required double cashDelta,
    required double creditDelta,
    required int pointsDelta,
    required String reason,
  });
  Future<void> approveWithdrawal(String requestId);
  Future<void> rejectWithdrawal(String requestId, String reason);
  Future<void> toggleGameStatus(String gameId);
  Future<void> updateGameStakes(String gameId, double minStake, double maxStake);
}
