import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:zozo99/core/models/betting_models.dart';
import 'package:zozo99/core/repositories/betting_repository.dart';

class MockBettingRepository extends GetxService implements BettingRepository {
  final Random _rng = Random();

  // ─── Reactive In-Memory Database ─────────────────────────────────
  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);
  final Rx<WalletModel?> _currentWallet = Rx<WalletModel?>(null);

  final RxList<UserModel> _allUsers = <UserModel>[].obs;
  final Map<String, WalletModel> _userWallets = {};
  final RxList<TransactionModel> _transactions = <TransactionModel>[].obs;
  final RxList<DepositRequestModel> _depositRequests =
      <DepositRequestModel>[].obs;
  final RxList<WithdrawalRequestModel> _withdrawalRequests =
      <WithdrawalRequestModel>[].obs;
  final RxList<GameModel> _games = <GameModel>[].obs;
  final RxList<GameBetModel> _gameBets = <GameBetModel>[].obs;
  final RxList<PointsLedgerModel> _pointsLedger = <PointsLedgerModel>[].obs;
  final RxList<AppNotificationModel> _notifications =
      <AppNotificationModel>[].obs;
  final RxList<AdminActionModel> _auditLogs = <AdminActionModel>[].obs;

  // Aviator Server Simulation State
  final Rx<GameRoundModel> _aviatorRound = Rx<GameRoundModel>(
    GameRoundModel(
      id: 'round_init',
      gameId: 'aviator_demo',
      status: RoundStatus.waiting,
      crashMultiplier: 2.45,
      startAt: DateTime.now(),
    ),
  );

  Timer? _aviatorTicker;
  double _currentClimbingMultiplier = 1.00;
  GameBetModel? _activeAviatorBet;

  // ─── Streams & Getters ───────────────────────────────────────────
  @override
  Stream<UserModel?> get currentUserStream => _currentUser.stream;
  @override
  UserModel? get currentUser => _currentUser.value;

  @override
  Stream<WalletModel?> get walletStream => _currentWallet.stream;
  @override
  WalletModel? get currentWallet => _currentWallet.value;

  @override
  Stream<List<TransactionModel>> get transactionsStream => _transactions.stream;
  @override
  List<TransactionModel> get transactions => _transactions;

  @override
  Stream<List<DepositRequestModel>> get depositRequestsStream =>
      _depositRequests.stream;

  @override
  Stream<List<WithdrawalRequestModel>> get withdrawalRequestsStream =>
      _withdrawalRequests.stream;

  @override
  Stream<List<GameModel>> get gamesStream => _games.stream;
  @override
  List<GameModel> get games => _games;

  @override
  Stream<List<GameBetModel>> get gameBetsStream => _gameBets.stream;
  @override
  List<GameBetModel> get gameBets => _gameBets;

  @override
  Stream<GameRoundModel> get aviatorRoundStream => _aviatorRound.stream;
  @override
  GameRoundModel get currentAviatorRound => _aviatorRound.value;

  double get currentAviatorMultiplier => _currentClimbingMultiplier;

  @override
  Stream<List<PointsLedgerModel>> get pointsLedgerStream =>
      _pointsLedger.stream;
  @override
  List<PointsLedgerModel> get pointsLedger => _pointsLedger;

  @override
  Stream<List<AppNotificationModel>> get notificationsStream =>
      _notifications.stream;

  @override
  Stream<List<UserModel>> get allUsersStream => _allUsers.stream;
  @override
  List<UserModel> get allUsers => _allUsers;

  @override
  Stream<List<WithdrawalRequestModel>> get allWithdrawalRequestsStream =>
      _withdrawalRequests.stream;

  @override
  Stream<List<AdminActionModel>> get adminAuditLogsStream => _auditLogs.stream;

  // ─── Initialization & Seed Data ──────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _seedInitialData();
    _startAviatorEngine();
  }

  @override
  void onClose() {
    _aviatorTicker?.cancel();
    super.onClose();
  }

  void _seedInitialData() {
    final now = DateTime.now();

    final customer = UserModel(
      uid: 'user_customer_01',
      email: 'user@zozo99.com',
      phone: '+880 1712 345678',
      username: 'AlexRider',
      role: UserRole.customer,
      status: UserStatus.active,
      points: 1850,
      tier: VipTier.gold,
      avatarUrl:
          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
      createdAt: now.subtract(const Duration(days: 30)),
      updatedAt: now,
    );

    final admin = UserModel(
      uid: 'admin_master_01',
      email: 'admin@zozo99.com',
      phone: '+880 1999 888777',
      username: 'ChiefAdmin',
      role: UserRole.admin,
      status: UserStatus.active,
      points: 7500,
      tier: VipTier.diamond,
      avatarUrl:
          'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=150',
      createdAt: now.subtract(const Duration(days: 90)),
      updatedAt: now,
    );

    final player2 = UserModel(
      uid: 'user_02',
      email: 'sophia@zozo99.com',
      phone: '+880 1811 223344',
      username: 'SophiaWin',
      role: UserRole.customer,
      status: UserStatus.active,
      points: 420,
      tier: VipTier.silver,
      createdAt: now.subtract(const Duration(days: 12)),
      updatedAt: now,
    );

    final player3 = UserModel(
      uid: 'user_03',
      email: 'crypto_king@zozo99.com',
      phone: '+880 1622 998877',
      username: 'CryptoKing',
      role: UserRole.customer,
      status: UserStatus.blocked,
      points: 6200,
      tier: VipTier.diamond,
      createdAt: now.subtract(const Duration(days: 45)),
      updatedAt: now,
    );

    _allUsers.assignAll([customer, admin, player2, player3]);

    // Initial Wallets
    _userWallets[customer.uid] = WalletModel(
      uid: customer.uid,
      cashBalance: 320.0,
      creditBalance: 4500.0,
      totalDeposited: 600.0,
      totalWithdrawn: 150.0,
      updatedAt: now,
    );

    _userWallets[admin.uid] = WalletModel(
      uid: admin.uid,
      cashBalance: 5000.0,
      creditBalance: 50000.0,
      totalDeposited: 10000.0,
      totalWithdrawn: 0.0,
      updatedAt: now,
    );

    _userWallets[player2.uid] = WalletModel(
      uid: player2.uid,
      cashBalance: 50.0,
      creditBalance: 1200.0,
      totalDeposited: 100.0,
      totalWithdrawn: 0.0,
      updatedAt: now,
    );

    _userWallets[player3.uid] = WalletModel(
      uid: player3.uid,
      cashBalance: 0.0,
      creditBalance: 850.0,
      totalDeposited: 1500.0,
      totalWithdrawn: 1200.0,
      updatedAt: now,
    );

    // Default active user is Guest (null) - user must sign up or log in
    _currentUser.value = null;
    _currentWallet.value = null;

    // Seed Games
    _games.assignAll([
      const GameModel(
        id: 'aviator_demo',
        name: 'Aviator Crash',
        type: GameType.aviator,
        enabled: true,
        minStake: 10.0,
        maxStake: 5000.0,
        description: 'Multipliers climb into the sky! Cash out before the plane flies away!',
        badge: 'TRENDING 🚀',
      ),
      const GameModel(
        id: 'puzzle_demo',
        name: 'Cyber Match Rush',
        type: GameType.puzzle,
        enabled: true,
        minStake: 20.0,
        maxStake: 2000.0,
        description: 'Solve the high-tech matrix puzzle to claim massive credit multipliers!',
        badge: 'POPULAR 🧩',
      ),
      const GameModel(
        id: 'spin_demo',
        name: 'Lucky Fortune Wheel',
        type: GameType.spin,
        enabled: true,
        minStake: 25.0,
        maxStake: 2500.0,
        description: 'Spin the wheel of fortune for instant credits, bonus multipliers & points!',
        badge: 'DAILY WHEEL 🎡',
      ),
    ]);

    // Seed Transactions
    _transactions.assignAll([
      TransactionModel(
        id: 'tx_01',
        uid: customer.uid,
        type: TransactionType.deposit,
        amount: 200.0,
        status: TransactionStatus.completed,
        referenceId: 'DEP-98214',
        description: 'Demo Visa Deposit - Verified',
        createdAt: now.subtract(const Duration(days: 3)),
      ),
      TransactionModel(
        id: 'tx_02',
        uid: customer.uid,
        type: TransactionType.creditConversion,
        amount: 150.0,
        status: TransactionStatus.completed,
        referenceId: 'CONV-4412',
        description: 'Converted \$150 to 15,000 Credits',
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      TransactionModel(
        id: 'tx_03',
        uid: customer.uid,
        type: TransactionType.gameWin,
        amount: 450.0,
        status: TransactionStatus.completed,
        referenceId: 'AVI-BET-991',
        description: 'Aviator 3.20x Cashout Win',
        createdAt: now.subtract(const Duration(hours: 14)),
      ),
      TransactionModel(
        id: 'tx_04',
        uid: customer.uid,
        type: TransactionType.withdrawal,
        amount: 50.0,
        status: TransactionStatus.completed,
        referenceId: 'WTH-7731',
        description: 'Withdrawal to Bank Account',
        createdAt: now.subtract(const Duration(hours: 4)),
      ),
    ]);

    // Seed Withdrawals for Admin review
    _withdrawalRequests.assignAll([
      WithdrawalRequestModel(
        id: 'wth_req_01',
        uid: player2.uid,
        amount: 80.0,
        method: 'bKash',
        accountNumber: '01811223344',
        accountName: 'Sophia Miller',
        status: TransactionStatus.pending,
        referenceId: 'WTH-BK-101',
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(hours: 2)),
      ),
      WithdrawalRequestModel(
        id: 'wth_req_02',
        uid: customer.uid,
        amount: 50.0,
        method: 'Bank Wire',
        accountNumber: 'CityBank-9921',
        accountName: customer.username,
        status: TransactionStatus.completed,
        referenceId: 'WTH-7731',
        createdAt: now.subtract(const Duration(hours: 4)),
        updatedAt: now.subtract(const Duration(hours: 3)),
      ),
    ]);

    // Seed Notifications
    _notifications.assignAll([
      AppNotificationModel(
        id: 'notif_01',
        uid: customer.uid,
        title: 'Welcome to Zozo99! 🚀',
        message: 'Your account is ready. Claim your Gold VIP benefits and start playing!',
        type: 'PROMO',
        isRead: false,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      AppNotificationModel(
        id: 'notif_02',
        uid: customer.uid,
        title: 'Deposit Successful 💳',
        message: 'Your demo deposit of \$200 has been credited to your cash balance.',
        type: 'WALLET',
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 12)),
      ),
      AppNotificationModel(
        id: 'notif_03',
        uid: customer.uid,
        title: 'Gold Tier Achieved! ⭐',
        message: 'Congratulations! You unlocked Gold Tier with 3% cashback on wagers!',
        type: 'TIER',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
    ]);

    // Seed Points
    _pointsLedger.assignAll([
      PointsLedgerModel(
        id: 'pt_01',
        uid: customer.uid,
        points: 500,
        type: PointType.bonus,
        source: 'WELCOME_BONUS',
        referenceId: 'REF_INIT',
        createdAt: now.subtract(const Duration(days: 20)),
      ),
      PointsLedgerModel(
        id: 'pt_02',
        uid: customer.uid,
        points: 850,
        type: PointType.earn,
        source: 'GAMEPLAY_AVIATOR',
        referenceId: 'REF_AVI_01',
        createdAt: now.subtract(const Duration(days: 5)),
      ),
      PointsLedgerModel(
        id: 'pt_03',
        uid: customer.uid,
        points: 500,
        type: PointType.earn,
        source: 'GAMEPLAY_SPIN',
        referenceId: 'REF_SPN_02',
        createdAt: now.subtract(const Duration(hours: 6)),
      ),
    ]);

    // Seed Admin Audit
    _auditLogs.assignAll([
      AdminActionModel(
        id: 'log_01',
        adminUid: admin.uid,
        adminUsername: admin.username,
        actionType: 'SYSTEM_BOOT',
        targetUid: 'SYSTEM',
        details:
            'Initial system seed and security rules compiled successfully.',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      AdminActionModel(
        id: 'log_02',
        adminUid: admin.uid,
        adminUsername: admin.username,
        actionType: 'BLOCK_USER',
        targetUid: player3.uid,
        details: 'Blocked user for abnormal multi-session request anomaly.',
        createdAt: now.subtract(const Duration(hours: 18)),
      ),
    ]);
  }

  // ─── Authentication Operations ───────────────────────────────────
  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final matched = _allUsers.firstWhereOrNull(
      (u) => u.email.toLowerCase() == email.trim().toLowerCase(),
    );

    if (matched == null) {
      throw Exception('Invalid email or password.');
    }
    if (matched.isBlocked) {
      throw Exception('Account is suspended. Please contact support.');
    }

    _currentUser.value = matched;
    _currentWallet.value =
        _userWallets[matched.uid] ??
        WalletModel(uid: matched.uid, updatedAt: DateTime.now());
    return matched;
  }

  @override
  Future<UserModel> register({
    required String email,
    required String phone,
    required String username,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final existing = _allUsers.firstWhereOrNull(
      (u) => u.email.toLowerCase() == email.trim().toLowerCase(),
    );
    if (existing != null) {
      throw Exception('Email already registered.');
    }

    final now = DateTime.now();
    final newUser = UserModel(
      uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: email.trim(),
      phone: phone.trim(),
      username: username.trim(),
      role: UserRole.customer,
      status: UserStatus.active,
      points: 200, // Signup bonus points
      tier: VipTier.silver,
      createdAt: now,
      updatedAt: now,
    );

    final newWallet = WalletModel(
      uid: newUser.uid,
      cashBalance: 0.0,
      creditBalance: 500.0, // Welcome 500 Demo credits
      totalDeposited: 0.0,
      totalWithdrawn: 0.0,
      updatedAt: now,
    );

    _allUsers.add(newUser);
    _userWallets[newUser.uid] = newWallet;
    _currentUser.value = newUser;
    _currentWallet.value = newWallet;

    // Welcome notification
    _notifications.insert(
      0,
      AppNotificationModel(
        id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
        uid: newUser.uid,
        title: 'Welcome Bonus Credited! 🎉',
        message: 'You received 500 Demo Credits and 200 VIP Points to start your adventure!',
        type: 'BONUS',
        isRead: false,
        createdAt: now,
      ),
    );

    return newUser;
  }

  @override
  Future<void> updateProfile({
    String? username,
    String? phone,
    String? avatarUrl,
  }) async {
    final user = _currentUser.value;
    if (user == null) return;

    final updated = user.copyWith(
      username: username?.trim().isNotEmpty == true
          ? username!.trim()
          : user.username,
      phone: phone?.trim().isNotEmpty == true ? phone!.trim() : user.phone,
      avatarUrl: avatarUrl ?? user.avatarUrl,
      updatedAt: DateTime.now(),
    );

    _currentUser.value = updated;
    final idx = _allUsers.indexWhere((u) => u.uid == user.uid);
    if (idx != -1) _allUsers[idx] = updated;
  }

  @override
  Future<void> logout() async {
    _currentUser.value = null;
    _currentWallet.value = null;
  }

  @override
  Future<void> switchDemoRole(UserRole role) async {
    final target =
        _allUsers.firstWhereOrNull((u) => u.role == role) ?? _allUsers.first;
    _currentUser.value = target;
    _currentWallet.value = _userWallets[target.uid];
  }

  // ─── Wallet & Currency Operations ────────────────────────────────
  @override
  Future<void> convertCashToCredits(double cashAmount) async {
    final user = _currentUser.value;
    final wallet = _currentWallet.value;
    if (user == null || wallet == null)
      throw Exception('User not authenticated.');
    if (cashAmount <= 0) throw Exception('Enter a valid amount.');
    if (wallet.cashBalance < cashAmount)
      throw Exception('Insufficient cash balance.');

    final creditsToAdd = cashAmount * 100.0;
    final updatedWallet = wallet.copyWith(
      cashBalance: wallet.cashBalance - cashAmount,
      creditBalance: wallet.creditBalance + creditsToAdd,
      updatedAt: DateTime.now(),
    );

    _applyWalletUpdate(updatedWallet);

    final tx = TransactionModel(
      id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
      uid: user.uid,
      type: TransactionType.creditConversion,
      amount: cashAmount,
      currency: 'USD',
      status: TransactionStatus.completed,
      referenceId: 'CONV-${_rng.nextInt(90000) + 10000}',
      description:
          'Converted \$${cashAmount.toStringAsFixed(2)} to ${creditsToAdd.toInt()} Credits',
      createdAt: DateTime.now(),
    );
    _transactions.insert(0, tx);

    // Award Points (1 point per \$1 converted)
    _awardPoints(
      user.uid,
      (cashAmount * 1.5).toInt(),
      PointType.earn,
      'CONVERT_BONUS',
    );
  }

  @override
  Future<void> convertCreditsToCash(double creditAmount) async {
    final user = _currentUser.value;
    final wallet = _currentWallet.value;
    if (user == null || wallet == null)
      throw Exception('User not authenticated.');
    if (creditAmount < 100)
      throw Exception('Minimum conversion is 100 credits.');
    if (wallet.creditBalance < creditAmount)
      throw Exception('Insufficient credits.');

    final cashToAdd = creditAmount / 100.0;
    final updatedWallet = wallet.copyWith(
      creditBalance: wallet.creditBalance - creditAmount,
      cashBalance: wallet.cashBalance + cashToAdd,
      updatedAt: DateTime.now(),
    );

    _applyWalletUpdate(updatedWallet);

    final tx = TransactionModel(
      id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
      uid: user.uid,
      type: TransactionType.creditConversion,
      amount: cashToAdd,
      currency: 'USD',
      status: TransactionStatus.completed,
      referenceId: 'CONV-${_rng.nextInt(90000) + 10000}',
      description:
          'Exchanged ${creditAmount.toInt()} Credits for \$${cashToAdd.toStringAsFixed(2)} Cash',
      createdAt: DateTime.now(),
    );
    _transactions.insert(0, tx);
  }

  // ─── Deposit Flow ────────────────────────────────────────────────
  @override
  Future<DepositRequestModel> createDeposit({
    required double amount,
    required String paymentMethod,
    required String accountNumber,
    bool simulateInstantSuccess = true,
  }) async {
    final user = _currentUser.value;
    final wallet = _currentWallet.value;
    if (user == null || wallet == null)
      throw Exception('User not authenticated.');
    if (amount < 10) throw Exception('Minimum deposit is \$10.00.');
    if (amount > 10000) throw Exception('Maximum deposit is \$10,000.00.');

    final ref = 'DEP-${_rng.nextInt(900000) + 100000}';
    final now = DateTime.now();

    final req = DepositRequestModel(
      id: 'dep_${now.millisecondsSinceEpoch}',
      uid: user.uid,
      amount: amount,
      paymentMethod: paymentMethod,
      accountNumber: accountNumber,
      transactionRef: ref,
      status: simulateInstantSuccess
          ? TransactionStatus.completed
          : TransactionStatus.pending,
      createdAt: now,
    );

    _depositRequests.insert(0, req);

    if (simulateInstantSuccess) {
      // Simulate verified payment provider webhook updating balance
      final updatedWallet = wallet.copyWith(
        cashBalance: wallet.cashBalance + amount,
        totalDeposited: wallet.totalDeposited + amount,
        updatedAt: now,
      );
      _applyWalletUpdate(updatedWallet);

      final tx = TransactionModel(
        id: 'tx_${now.millisecondsSinceEpoch}',
        uid: user.uid,
        type: TransactionType.deposit,
        amount: amount,
        currency: 'USD',
        status: TransactionStatus.completed,
        referenceId: ref,
        description: '$paymentMethod Deposit Success',
        createdAt: now,
      );
      _transactions.insert(0, tx);

      // Deposit bonus points
      _awardPoints(
        user.uid,
        (amount * 2).toInt(),
        PointType.bonus,
        'DEPOSIT_REWARD',
      );

      // Notification
      _notifications.insert(
        0,
        AppNotificationModel(
          id: 'notif_${now.millisecondsSinceEpoch}',
          uid: user.uid,
          title: 'Deposit Received! 💰',
          message:
              '\$${amount.toStringAsFixed(2)} was successfully added to your cash balance.',
          type: 'WALLET',
          isRead: false,
          createdAt: now,
        ),
      );
    }

    return req;
  }

  // ─── Withdrawal Flow ─────────────────────────────────────────────
  @override
  Future<WithdrawalRequestModel> requestWithdrawal({
    required double amount,
    required String method,
    required String accountNumber,
    required String accountName,
  }) async {
    final user = _currentUser.value;
    final wallet = _currentWallet.value;
    if (user == null || wallet == null)
      throw Exception('User not authenticated.');
    if (amount < 20) throw Exception('Minimum withdrawal is \$20.00.');
    if (amount > 5000) throw Exception('Maximum withdrawal is \$5,000.00.');
    if (wallet.cashBalance < amount) {
      throw Exception(
        'Insufficient cash balance. Available: \$${wallet.cashBalance.toStringAsFixed(2)}',
      );
    }

    final ref = 'WTH-${_rng.nextInt(900000) + 100000}';
    final now = DateTime.now();

    // Deduct cash balance and place in escrow/pending
    final updatedWallet = wallet.copyWith(
      cashBalance: wallet.cashBalance - amount,
      totalWithdrawn: wallet.totalWithdrawn + amount,
      updatedAt: now,
    );
    _applyWalletUpdate(updatedWallet);

    final req = WithdrawalRequestModel(
      id: 'wth_${now.millisecondsSinceEpoch}',
      uid: user.uid,
      amount: amount,
      method: method,
      accountNumber: accountNumber,
      accountName: accountName,
      status: TransactionStatus.pending,
      referenceId: ref,
      createdAt: now,
      updatedAt: now,
    );

    _withdrawalRequests.insert(0, req);

    final tx = TransactionModel(
      id: 'tx_${now.millisecondsSinceEpoch}',
      uid: user.uid,
      type: TransactionType.withdrawal,
      amount: amount,
      currency: 'USD',
      status: TransactionStatus.pending,
      referenceId: ref,
      description: 'Withdrawal Request ($method) - Pending Admin Approval',
      createdAt: now,
    );
    _transactions.insert(0, tx);

    _notifications.insert(
      0,
      AppNotificationModel(
        id: 'notif_${now.millisecondsSinceEpoch}',
        uid: user.uid,
        title: 'Withdrawal Submitted ⏳',
        message:
            'Your request for \$${amount.toStringAsFixed(2)} via $method is being processed.',
        type: 'WALLET',
        isRead: false,
        createdAt: now,
      ),
    );

    return req;
  }

  // ─── Aviator Real-Time Engine ────────────────────────────────────
  void _startAviatorEngine() {
    _runAviatorRoundLoop();
  }

  void _runAviatorRoundLoop() async {
    while (true) {
      // Phase 1: WAITING (5 seconds)
      _currentClimbingMultiplier = 1.00;
      final roundId = 'round_${DateTime.now().millisecondsSinceEpoch}';

      // Pick crash multiplier with house edge simulation (1.10x up to 35.00x)
      final randVal = _rng.nextDouble();
      double targetCrash;
      if (randVal < 0.10) {
        targetCrash =
            1.05 + (_rng.nextDouble() * 0.20); // 1.05x - 1.25x early crash
      } else if (randVal < 0.65) {
        targetCrash =
            1.30 + (_rng.nextDouble() * 2.50); // 1.30x - 3.80x normal range
      } else if (randVal < 0.90) {
        targetCrash =
            3.80 + (_rng.nextDouble() * 6.00); // 3.80x - 9.80x high range
      } else {
        targetCrash = 10.0 + (_rng.nextDouble() * 25.0); // 10.0x - 35.0x moon!
      }

      _aviatorRound.value = GameRoundModel(
        id: roundId,
        gameId: 'aviator_demo',
        status: RoundStatus.waiting,
        crashMultiplier: targetCrash,
        startAt: DateTime.now(),
      );

      // Wait 5 seconds for players to place bets
      await Future.delayed(const Duration(seconds: 5));

      // Phase 2: RUNNING (Climbing)
      _aviatorRound.value = GameRoundModel(
        id: roundId,
        gameId: 'aviator_demo',
        status: RoundStatus.running,
        crashMultiplier: targetCrash,
        startAt: DateTime.now(),
      );

      final completer = Completer<void>();
      double multiplier = 1.00;
      final speedMs = 60;

      _aviatorTicker?.cancel();
      _aviatorTicker = Timer.periodic(Duration(milliseconds: speedMs), (timer) {
        // Exponential flight curve
        final increment = 0.01 + (multiplier * 0.005);
        multiplier += increment;
        _currentClimbingMultiplier = double.parse(
          multiplier.toStringAsFixed(2),
        );

        // Auto Cashout check
        if (_activeAviatorBet != null &&
            _activeAviatorBet!.status == BetStatus.placed &&
            _activeAviatorBet!.autoCashout != null &&
            multiplier >= _activeAviatorBet!.autoCashout!) {
          cashoutAviatorBet(
            betId: _activeAviatorBet!.id,
            currentMultiplier: _activeAviatorBet!.autoCashout!,
          );
        }

        if (multiplier >= targetCrash) {
          timer.cancel();
          completer.complete();
        }
      });

      await completer.future;

      // Phase 3: CRASHED
      _aviatorRound.value = GameRoundModel(
        id: roundId,
        gameId: 'aviator_demo',
        status: RoundStatus.crashed,
        crashMultiplier: targetCrash,
        startAt: _aviatorRound.value.startAt,
      );

      // If active bet was not cashed out, mark as LOST
      if (_activeAviatorBet != null &&
          _activeAviatorBet!.status == BetStatus.placed) {
        final lostBet = _activeAviatorBet!.copyWith(
          status: BetStatus.lost,
          cashoutMultiplier: targetCrash,
          payout: 0.0,
        );
        _activeAviatorBet = null;
        final idx = _gameBets.indexWhere((b) => b.id == lostBet.id);
        if (idx != -1) _gameBets[idx] = lostBet;
      }

      await Future.delayed(const Duration(seconds: 3));

      // Phase 4: SETTLED
      _aviatorRound.value = GameRoundModel(
        id: roundId,
        gameId: 'aviator_demo',
        status: RoundStatus.settled,
        crashMultiplier: targetCrash,
        startAt: _aviatorRound.value.startAt,
      );

      await Future.delayed(const Duration(milliseconds: 1500));
    }
  }

  @override
  Future<GameBetModel> placeAviatorBet({
    required double stake,
    double? autoCashout,
  }) async {
    final user = _currentUser.value;
    final wallet = _currentWallet.value;
    if (user == null || wallet == null)
      throw Exception('Please log in to place bets.');
    if (_aviatorRound.value.status != RoundStatus.waiting) {
      throw Exception(
        'Betting closed for current round. Please wait for the next countdown.',
      );
    }
    if (stake < 10) throw Exception('Minimum stake is 10 Credits.');
    if (wallet.creditBalance < stake) {
      throw Exception(
        'Insufficient credits! Available: ${wallet.creditBalance.toInt()} Credits.',
      );
    }

    // Server-side debit
    final updatedWallet = wallet.copyWith(
      creditBalance: wallet.creditBalance - stake,
      updatedAt: DateTime.now(),
    );
    _applyWalletUpdate(updatedWallet);

    final bet = GameBetModel(
      id: 'bet_${DateTime.now().millisecondsSinceEpoch}',
      uid: user.uid,
      username: user.username,
      roundId: _aviatorRound.value.id,
      gameType: GameType.aviator,
      stake: stake,
      autoCashout: autoCashout,
      cashoutMultiplier: 0.0,
      payout: 0.0,
      status: BetStatus.placed,
      createdAt: DateTime.now(),
    );

    _activeAviatorBet = bet;
    _gameBets.insert(0, bet);

    // Ledger Debit entry
    _transactions.insert(
      0,
      TransactionModel(
        id: 'tx_bet_${DateTime.now().millisecondsSinceEpoch}',
        uid: user.uid,
        type: TransactionType.gameDebit,
        amount: stake,
        currency: 'CREDITS',
        status: TransactionStatus.completed,
        referenceId: bet.id,
        description: 'Aviator Bet Placed',
        createdAt: DateTime.now(),
      ),
    );

    // Points earned on wager
    _awardPoints(
      user.uid,
      (stake / 10).clamp(1, 50).toInt(),
      PointType.earn,
      'AVIATOR_WAGER',
    );

    return bet;
  }

  @override
  Future<GameBetModel> cashoutAviatorBet({
    required String betId,
    required double currentMultiplier,
  }) async {
    final user = _currentUser.value;
    final wallet = _currentWallet.value;
    if (user == null || wallet == null)
      throw Exception('User not authenticated.');
    if (_aviatorRound.value.status != RoundStatus.running) {
      throw Exception('Plane already crashed or round not running.');
    }

    final bet = _activeAviatorBet;
    if (bet == null || bet.id != betId || bet.status != BetStatus.placed) {
      throw Exception('No active bet found to cash out.');
    }

    final payout = bet.stake * currentMultiplier;

    // Credit payout
    final updatedWallet = wallet.copyWith(
      creditBalance: wallet.creditBalance + payout,
      updatedAt: DateTime.now(),
    );
    _applyWalletUpdate(updatedWallet);

    final cashedBet = bet.copyWith(
      status: BetStatus.cashedOut,
      cashoutMultiplier: currentMultiplier,
      payout: payout,
    );
    _activeAviatorBet = null;

    final idx = _gameBets.indexWhere((b) => b.id == betId);
    if (idx != -1) _gameBets[idx] = cashedBet;

    // Transaction Win record
    _transactions.insert(
      0,
      TransactionModel(
        id: 'tx_win_${DateTime.now().millisecondsSinceEpoch}',
        uid: user.uid,
        type: TransactionType.gameWin,
        amount: payout,
        currency: 'CREDITS',
        status: TransactionStatus.completed,
        referenceId: betId,
        description:
            'Aviator Won at ${currentMultiplier.toStringAsFixed(2)}x (+${payout.toInt()} Credits)',
        createdAt: DateTime.now(),
      ),
    );

    return cashedBet;
  }

  // ─── Puzzle Game Flow ────────────────────────────────────────────
  @override
  Future<GameBetModel> playPuzzleGame({
    required double stake,
    required int score,
    required int moves,
    required bool won,
  }) async {
    final user = _currentUser.value;
    final wallet = _currentWallet.value;
    if (user == null || wallet == null)
      throw Exception('User not authenticated.');
    if (wallet.creditBalance < stake) throw Exception('Insufficient credits.');

    // Debit stake
    var currentCredits = wallet.creditBalance - stake;
    final betId = 'puz_${DateTime.now().millisecondsSinceEpoch}';

    double multiplier = 0.0;
    double payout = 0.0;
    BetStatus status = BetStatus.lost;

    if (won) {
      multiplier = score > 150 ? 3.0 : 2.0;
      payout = stake * multiplier;
      currentCredits += payout;
      status = BetStatus.won;
    }

    final updatedWallet = wallet.copyWith(
      creditBalance: currentCredits,
      updatedAt: DateTime.now(),
    );
    _applyWalletUpdate(updatedWallet);

    final bet = GameBetModel(
      id: betId,
      uid: user.uid,
      username: user.username,
      roundId: 'puz_round_${DateTime.now().millisecondsSinceEpoch}',
      gameType: GameType.puzzle,
      stake: stake,
      cashoutMultiplier: multiplier,
      payout: payout,
      status: status,
      createdAt: DateTime.now(),
    );
    _gameBets.insert(0, bet);

    // Ledger
    _transactions.insert(
      0,
      TransactionModel(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        uid: user.uid,
        type: won ? TransactionType.gameWin : TransactionType.gameDebit,
        amount: won ? payout : stake,
        currency: 'CREDITS',
        status: TransactionStatus.completed,
        referenceId: betId,
        description: won
            ? 'Cyber Match Won (${multiplier}x) +${payout.toInt()} Credits'
            : 'Cyber Match Puzzle Stake',
        createdAt: DateTime.now(),
      ),
    );

    if (won) {
      _awardPoints(
        user.uid,
        (payout / 5).toInt(),
        PointType.earn,
        'PUZZLE_WIN',
      );
    }

    return bet;
  }

  // ─── Spin Game Flow ──────────────────────────────────────────────
  @override
  Future<GameBetModel> playSpinGame({
    required double stake,
    required String prizeLabel,
    required double rewardCredits,
    required int rewardPoints,
  }) async {
    final user = _currentUser.value;
    final wallet = _currentWallet.value;
    if (user == null || wallet == null)
      throw Exception('User not authenticated.');
    if (wallet.creditBalance < stake) throw Exception('Insufficient credits.');

    // Debit stake + add reward
    final netCredits = (wallet.creditBalance - stake) + rewardCredits;
    final updatedWallet = wallet.copyWith(
      creditBalance: netCredits,
      updatedAt: DateTime.now(),
    );
    _applyWalletUpdate(updatedWallet);

    final won = rewardCredits > 0 || rewardPoints > 0;
    final betId = 'spn_${DateTime.now().millisecondsSinceEpoch}';

    final bet = GameBetModel(
      id: betId,
      uid: user.uid,
      username: user.username,
      roundId: 'spn_round_${DateTime.now().millisecondsSinceEpoch}',
      gameType: GameType.spin,
      stake: stake,
      cashoutMultiplier: stake > 0 ? (rewardCredits / stake) : 1.0,
      payout: rewardCredits,
      status: won ? BetStatus.won : BetStatus.lost,
      createdAt: DateTime.now(),
    );
    _gameBets.insert(0, bet);

    _transactions.insert(
      0,
      TransactionModel(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        uid: user.uid,
        type: won ? TransactionType.gameWin : TransactionType.gameDebit,
        amount: won ? rewardCredits : stake,
        currency: 'CREDITS',
        status: TransactionStatus.completed,
        referenceId: betId,
        description: 'Lucky Spin Result: $prizeLabel',
        createdAt: DateTime.now(),
      ),
    );

    if (rewardPoints > 0) {
      _awardPoints(user.uid, rewardPoints, PointType.bonus, 'LUCKY_SPIN_PRIZE');
    }

    return bet;
  }

  // ─── Points & Tiers System ───────────────────────────────────────
  void _awardPoints(String uid, int points, PointType type, String source) {
    if (points <= 0) return;

    final entry = PointsLedgerModel(
      id: 'pt_${DateTime.now().millisecondsSinceEpoch}',
      uid: uid,
      points: points,
      type: type,
      source: source,
      referenceId: 'REF_${_rng.nextInt(99999)}',
      createdAt: DateTime.now(),
    );
    _pointsLedger.insert(0, entry);

    // Update user points and check Tier Upgrade
    final user = _allUsers.firstWhereOrNull((u) => u.uid == uid);
    if (user != null) {
      final newPoints = user.points + points;
      final newTier = VipTier.fromPoints(newPoints);
      final upgraded = user.copyWith(
        points: newPoints,
        tier: newTier,
        updatedAt: DateTime.now(),
      );

      final idx = _allUsers.indexWhere((u) => u.uid == uid);
      if (idx != -1) _allUsers[idx] = upgraded;
      if (_currentUser.value?.uid == uid) _currentUser.value = upgraded;

      if (newTier != user.tier) {
        _notifications.insert(
          0,
          AppNotificationModel(
            id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
            uid: uid,
            title: 'Tier Upgrade! 🏆',
            message:
                'You have ascended to ${newTier.label} Tier! Enjoy enhanced cashback & perks.',
            type: 'TIER',
            isRead: false,
            createdAt: DateTime.now(),
          ),
        );
      }
    }
  }

  @override
  Future<void> redeemPointsToCredits(int points) async {
    final user = _currentUser.value;
    final wallet = _currentWallet.value;
    if (user == null || wallet == null)
      throw Exception('User not authenticated.');
    if (points < 100) throw Exception('Minimum redemption is 100 points.');
    if (user.points < points) throw Exception('Insufficient VIP points.');

    // 100 points = 10 Credits
    final creditsToAdd = (points / 10).toDouble();

    final updatedWallet = wallet.copyWith(
      creditBalance: wallet.creditBalance + creditsToAdd,
      updatedAt: DateTime.now(),
    );
    _applyWalletUpdate(updatedWallet);

    // Deduct points
    final newPoints = user.points - points;
    final updatedUser = user.copyWith(
      points: newPoints,
      tier: VipTier.fromPoints(newPoints),
      updatedAt: DateTime.now(),
    );
    final idx = _allUsers.indexWhere((u) => u.uid == user.uid);
    if (idx != -1) _allUsers[idx] = updatedUser;
    _currentUser.value = updatedUser;

    _pointsLedger.insert(
      0,
      PointsLedgerModel(
        id: 'pt_${DateTime.now().millisecondsSinceEpoch}',
        uid: user.uid,
        points: -points,
        type: PointType.redeem,
        source: 'CREDIT_REDEMPTION',
        referenceId: 'RED-${_rng.nextInt(90000)}',
        createdAt: DateTime.now(),
      ),
    );

    _transactions.insert(
      0,
      TransactionModel(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        uid: user.uid,
        type: TransactionType.bonus,
        amount: creditsToAdd,
        currency: 'CREDITS',
        status: TransactionStatus.completed,
        referenceId: 'PTS-RED',
        description:
            'Redeemed $points VIP Points for ${creditsToAdd.toInt()} Credits',
        createdAt: DateTime.now(),
      ),
    );
  }

  // ─── Notification Operations ─────────────────────────────────────
  @override
  Future<void> markNotificationAsRead(String id) async {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx != -1) {
      _notifications[idx] = _notifications[idx].copyWith(isRead: true);
    }
  }

  @override
  Future<void> clearAllNotifications() async {
    _notifications.clear();
  }

  // ─── Admin Management Operations ─────────────────────────────────
  @override
  Future<void> toggleUserBlock(String uid) async {
    final admin = _currentUser.value;
    final idx = _allUsers.indexWhere((u) => u.uid == uid);
    if (idx == -1) throw Exception('User not found.');

    final user = _allUsers[idx];
    final newStatus = user.status == UserStatus.active
        ? UserStatus.blocked
        : UserStatus.active;
    final updated = user.copyWith(status: newStatus, updatedAt: DateTime.now());
    _allUsers[idx] = updated;

    // Log admin action
    _recordAdminAction(
      actionType: newStatus == UserStatus.blocked
          ? 'BLOCK_USER'
          : 'UNBLOCK_USER',
      targetUid: uid,
      details:
          '${admin?.username ?? "Admin"} changed status of ${user.username} to ${newStatus.name}',
    );
  }

  @override
  Future<void> adjustUserBalance({
    required String targetUid,
    required double cashDelta,
    required double creditDelta,
    required int pointsDelta,
    required String reason,
  }) async {
    final targetWallet = _userWallets[targetUid];
    if (targetWallet == null) throw Exception('Target wallet not found.');

    final updatedWallet = targetWallet.copyWith(
      cashBalance: (targetWallet.cashBalance + cashDelta).clamp(0.0, 9999999.0),
      creditBalance: (targetWallet.creditBalance + creditDelta).clamp(
        0.0,
        9999999.0,
      ),
      updatedAt: DateTime.now(),
    );
    _userWallets[targetUid] = updatedWallet;
    if (_currentUser.value?.uid == targetUid) {
      _currentWallet.value = updatedWallet;
    }

    if (pointsDelta != 0) {
      _awardPoints(
        targetUid,
        pointsDelta,
        PointType.adjustment,
        'ADMIN_ADJUSTMENT',
      );
    }

    _recordAdminAction(
      actionType: 'BALANCE_ADJUSTMENT',
      targetUid: targetUid,
      details: 'Cash: +$cashDelta, Credits: +$creditDelta, Reason: $reason',
    );
  }

  @override
  Future<void> approveWithdrawal(String requestId) async {
    final idx = _withdrawalRequests.indexWhere((r) => r.id == requestId);
    if (idx == -1) throw Exception('Request not found.');

    final req = _withdrawalRequests[idx];
    final updated = req.copyWith(
      status: TransactionStatus.completed,
      updatedAt: DateTime.now(),
    );
    _withdrawalRequests[idx] = updated;

    // Update corresponding transaction
    final txIdx = _transactions.indexWhere(
      (t) => t.referenceId == req.referenceId,
    );
    if (txIdx != -1) {
      _transactions[txIdx] = TransactionModel(
        id: _transactions[txIdx].id,
        uid: req.uid,
        type: TransactionType.withdrawal,
        amount: req.amount,
        status: TransactionStatus.completed,
        referenceId: req.referenceId,
        description: 'Withdrawal Approved & Sent (${req.method})',
        createdAt: _transactions[txIdx].createdAt,
      );
    }

    _recordAdminAction(
      actionType: 'APPROVE_WITHDRAWAL',
      targetUid: req.uid,
      details: 'Approved withdrawal ${req.referenceId} of \$${req.amount}',
    );
  }

  @override
  Future<void> rejectWithdrawal(String requestId, String reason) async {
    final idx = _withdrawalRequests.indexWhere((r) => r.id == requestId);
    if (idx == -1) throw Exception('Request not found.');

    final req = _withdrawalRequests[idx];
    final updated = req.copyWith(
      status: TransactionStatus.cancelled,
      rejectionReason: reason,
      updatedAt: DateTime.now(),
    );
    _withdrawalRequests[idx] = updated;

    // Refund cash balance to user
    final targetWallet = _userWallets[req.uid];
    if (targetWallet != null) {
      final refunded = targetWallet.copyWith(
        cashBalance: targetWallet.cashBalance + req.amount,
        totalWithdrawn: targetWallet.totalWithdrawn - req.amount,
        updatedAt: DateTime.now(),
      );
      _userWallets[req.uid] = refunded;
      if (_currentUser.value?.uid == req.uid) {
        _currentWallet.value = refunded;
      }
    }

    _recordAdminAction(
      actionType: 'REJECT_WITHDRAWAL',
      targetUid: req.uid,
      details:
          'Rejected withdrawal ${req.referenceId} (\$${req.amount}). Reason: $reason',
    );
  }

  @override
  Future<void> toggleGameStatus(String gameId) async {
    final idx = _games.indexWhere((g) => g.id == gameId);
    if (idx != -1) {
      final current = _games[idx];
      _games[idx] = current.copyWith(enabled: !current.enabled);
      _recordAdminAction(
        actionType: 'TOGGLE_GAME',
        targetUid: gameId,
        details: 'Changed ${current.name} enabled state to ${!current.enabled}',
      );
    }
  }

  @override
  Future<void> updateGameStakes(
    String gameId,
    double minStake,
    double maxStake,
  ) async {
    final idx = _games.indexWhere((g) => g.id == gameId);
    if (idx != -1) {
      final current = _games[idx];
      _games[idx] = current.copyWith(minStake: minStake, maxStake: maxStake);
      _recordAdminAction(
        actionType: 'UPDATE_STAKES',
        targetUid: gameId,
        details:
            'Updated ${current.name} stakes to min: $minStake, max: $maxStake',
      );
    }
  }

  void _recordAdminAction({
    required String actionType,
    required String targetUid,
    required String details,
  }) {
    final admin = _currentUser.value;
    final log = AdminActionModel(
      id: 'log_${DateTime.now().millisecondsSinceEpoch}',
      adminUid: admin?.uid ?? 'admin_system',
      adminUsername: admin?.username ?? 'Admin',
      actionType: actionType,
      targetUid: targetUid,
      details: details,
      createdAt: DateTime.now(),
    );
    _auditLogs.insert(0, log);
  }

  void _applyWalletUpdate(WalletModel updated) {
    _userWallets[updated.uid] = updated;
    if (_currentUser.value?.uid == updated.uid) {
      _currentWallet.value = updated;
    }
  }
}
