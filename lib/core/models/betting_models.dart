import 'package:flutter/foundation.dart';

/// User Role
enum UserRole {
  customer,
  admin;

  static UserRole fromString(String? role) {
    if (role?.toLowerCase() == 'admin') return UserRole.admin;
    return UserRole.customer;
  }
}

/// User Account Status
enum UserStatus {
  active,
  blocked;

  static UserStatus fromString(String? status) {
    if (status?.toLowerCase() == 'blocked') return UserStatus.blocked;
    return UserStatus.active;
  }
}

/// VIP Tier System
enum VipTier {
  silver('Silver', 0, 999, 0.01),
  gold('Gold', 1000, 4999, 0.03),
  diamond('Diamond', 5000, 9999999, 0.05);

  final String label;
  final int minPoints;
  final int maxPoints;
  final double cashbackRate;

  const VipTier(this.label, this.minPoints, this.maxPoints, this.cashbackRate);

  static VipTier fromPoints(int points) {
    if (points >= diamond.minPoints) return VipTier.diamond;
    if (points >= gold.minPoints) return VipTier.gold;
    return VipTier.silver;
  }

  static VipTier fromString(String? tier) {
    final lower = tier?.toLowerCase();
    if (lower == 'diamond') return VipTier.diamond;
    if (lower == 'gold') return VipTier.gold;
    return VipTier.silver;
  }
}

/// User Profile Model
@immutable
class UserModel {
  final String uid;
  final String email;
  final String phone;
  final String username;
  final UserRole role;
  final UserStatus status;
  final int points;
  final VipTier tier;
  final String avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.uid,
    required this.email,
    required this.phone,
    required this.username,
    this.role = UserRole.customer,
    this.status = UserStatus.active,
    this.points = 0,
    this.tier = VipTier.silver,
    this.avatarUrl = '',
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isAdmin => role == UserRole.admin;
  bool get isBlocked => status == UserStatus.blocked;

  UserModel copyWith({
    String? uid,
    String? email,
    String? phone,
    String? username,
    UserRole? role,
    UserStatus? status,
    int? points,
    VipTier? tier,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      username: username ?? this.username,
      role: role ?? this.role,
      status: status ?? this.status,
      points: points ?? this.points,
      tier: tier ?? this.tier,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'phone': phone,
    'username': username,
    'role': role.name,
    'status': status.name,
    'points': points,
    'tier': tier.label,
    'avatarUrl': avatarUrl,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    uid: json['uid'] as String? ?? '',
    email: json['email'] as String? ?? '',
    phone: json['phone'] as String? ?? '',
    username: json['username'] as String? ?? 'User',
    role: UserRole.fromString(json['role'] as String?),
    status: UserStatus.fromString(json['status'] as String?),
    points: (json['points'] as num?)?.toInt() ?? 0,
    tier: VipTier.fromString(json['tier'] as String?),
    avatarUrl: json['avatarUrl'] as String? ?? '',
    createdAt: json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
        : DateTime.now(),
    updatedAt: json['updatedAt'] != null
        ? DateTime.tryParse(json['updatedAt'] as String) ?? DateTime.now()
        : DateTime.now(),
  );
}

/// Wallet Model
@immutable
class WalletModel {
  final String uid;
  final double cashBalance;
  final double creditBalance;
  final double totalDeposited;
  final double totalWithdrawn;
  final DateTime updatedAt;

  const WalletModel({
    required this.uid,
    this.cashBalance = 0.0,
    this.creditBalance = 0.0,
    this.totalDeposited = 0.0,
    this.totalWithdrawn = 0.0,
    required this.updatedAt,
  });

  WalletModel copyWith({
    String? uid,
    double? cashBalance,
    double? creditBalance,
    double? totalDeposited,
    double? totalWithdrawn,
    DateTime? updatedAt,
  }) {
    return WalletModel(
      uid: uid ?? this.uid,
      cashBalance: cashBalance ?? this.cashBalance,
      creditBalance: creditBalance ?? this.creditBalance,
      totalDeposited: totalDeposited ?? this.totalDeposited,
      totalWithdrawn: totalWithdrawn ?? this.totalWithdrawn,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'cashBalance': cashBalance,
    'creditBalance': creditBalance,
    'totalDeposited': totalDeposited,
    'totalWithdrawn': totalWithdrawn,
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
    uid: json['uid'] as String? ?? '',
    cashBalance: (json['cashBalance'] as num?)?.toDouble() ?? 0.0,
    creditBalance: (json['creditBalance'] as num?)?.toDouble() ?? 0.0,
    totalDeposited: (json['totalDeposited'] as num?)?.toDouble() ?? 0.0,
    totalWithdrawn: (json['totalWithdrawn'] as num?)?.toDouble() ?? 0.0,
    updatedAt: json['updatedAt'] != null
        ? DateTime.tryParse(json['updatedAt'] as String) ?? DateTime.now()
        : DateTime.now(),
  );
}

/// Transaction Types
enum TransactionType {
  deposit('DEPOSIT'),
  withdrawal('WITHDRAWAL'),
  creditConversion('CREDIT_CONVERSION'),
  gameDebit('GAME_DEBIT'),
  gameWin('GAME_WIN'),
  refund('REFUND'),
  bonus('BONUS'),
  adjustment('ADJUSTMENT');

  final String code;
  const TransactionType(this.code);

  static TransactionType fromString(String? value) {
    for (final type in TransactionType.values) {
      if (type.code == value || type.name == value) return type;
    }
    return TransactionType.deposit;
  }
}

/// Transaction Status
enum TransactionStatus {
  pending('PENDING'),
  completed('COMPLETED'),
  failed('FAILED'),
  cancelled('CANCELLED');

  final String code;
  const TransactionStatus(this.code);

  static TransactionStatus fromString(String? value) {
    for (final s in TransactionStatus.values) {
      if (s.code == value || s.name == value) return s;
    }
    return TransactionStatus.completed;
  }
}

/// Ledger Transaction Model
@immutable
class TransactionModel {
  final String id;
  final String uid;
  final TransactionType type;
  final double amount;
  final String currency;
  final TransactionStatus status;
  final String referenceId;
  final String description;
  final DateTime createdAt;

  const TransactionModel({
    required this.id,
    required this.uid,
    required this.type,
    required this.amount,
    this.currency = 'USD',
    this.status = TransactionStatus.completed,
    required this.referenceId,
    this.description = '',
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'uid': uid,
    'type': type.code,
    'amount': amount,
    'currency': currency,
    'status': status.code,
    'referenceId': referenceId,
    'description': description,
    'createdAt': createdAt.toIso8601String(),
  };

  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
    id: json['id'] as String? ?? '',
    uid: json['uid'] as String? ?? '',
    type: TransactionType.fromString(json['type'] as String?),
    amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    currency: json['currency'] as String? ?? 'USD',
    status: TransactionStatus.fromString(json['status'] as String?),
    referenceId: json['referenceId'] as String? ?? '',
    description: json['description'] as String? ?? '',
    createdAt: json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
        : DateTime.now(),
  );
}

/// Deposit Request Model
@immutable
class DepositRequestModel {
  final String id;
  final String uid;
  final double amount;
  final String paymentMethod;
  final String accountNumber;
  final String transactionRef;
  final TransactionStatus status;
  final DateTime createdAt;

  const DepositRequestModel({
    required this.id,
    required this.uid,
    required this.amount,
    required this.paymentMethod,
    this.accountNumber = '',
    required this.transactionRef,
    this.status = TransactionStatus.pending,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'uid': uid,
    'amount': amount,
    'paymentMethod': paymentMethod,
    'accountNumber': accountNumber,
    'transactionRef': transactionRef,
    'status': status.code,
    'createdAt': createdAt.toIso8601String(),
  };

  factory DepositRequestModel.fromJson(Map<String, dynamic> json) => DepositRequestModel(
    id: json['id'] as String? ?? '',
    uid: json['uid'] as String? ?? '',
    amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    paymentMethod: json['paymentMethod'] as String? ?? 'Card',
    accountNumber: json['accountNumber'] as String? ?? '',
    transactionRef: json['transactionRef'] as String? ?? '',
    status: TransactionStatus.fromString(json['status'] as String?),
    createdAt: json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
        : DateTime.now(),
  );
}

/// Withdrawal Request Model
@immutable
class WithdrawalRequestModel {
  final String id;
  final String uid;
  final double amount;
  final String method;
  final String accountNumber;
  final String accountName;
  final TransactionStatus status;
  final String referenceId;
  final String rejectionReason;
  final DateTime createdAt;
  final DateTime updatedAt;

  const WithdrawalRequestModel({
    required this.id,
    required this.uid,
    required this.amount,
    required this.method,
    required this.accountNumber,
    this.accountName = '',
    this.status = TransactionStatus.pending,
    required this.referenceId,
    this.rejectionReason = '',
    required this.createdAt,
    required this.updatedAt,
  });

  WithdrawalRequestModel copyWith({
    String? id,
    String? uid,
    double? amount,
    String? method,
    String? accountNumber,
    String? accountName,
    TransactionStatus? status,
    String? referenceId,
    String? rejectionReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WithdrawalRequestModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      amount: amount ?? this.amount,
      method: method ?? this.method,
      accountNumber: accountNumber ?? this.accountNumber,
      accountName: accountName ?? this.accountName,
      status: status ?? this.status,
      referenceId: referenceId ?? this.referenceId,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'uid': uid,
    'amount': amount,
    'method': method,
    'accountNumber': accountNumber,
    'accountName': accountName,
    'status': status.code,
    'referenceId': referenceId,
    'rejectionReason': rejectionReason,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory WithdrawalRequestModel.fromJson(Map<String, dynamic> json) => WithdrawalRequestModel(
    id: json['id'] as String? ?? '',
    uid: json['uid'] as String? ?? '',
    amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    method: json['method'] as String? ?? 'Bank',
    accountNumber: json['accountNumber'] as String? ?? '',
    accountName: json['accountName'] as String? ?? '',
    status: TransactionStatus.fromString(json['status'] as String?),
    referenceId: json['referenceId'] as String? ?? '',
    rejectionReason: json['rejectionReason'] as String? ?? '',
    createdAt: json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
        : DateTime.now(),
    updatedAt: json['updatedAt'] != null
        ? DateTime.tryParse(json['updatedAt'] as String) ?? DateTime.now()
        : DateTime.now(),
  );
}

/// Game Types
enum GameType {
  aviator('AVIATOR'),
  puzzle('PUZZLE'),
  spin('SPIN');

  final String code;
  const GameType(this.code);

  static GameType fromString(String? value) {
    if (value?.toUpperCase() == 'AVIATOR') return GameType.aviator;
    if (value?.toUpperCase() == 'PUZZLE') return GameType.puzzle;
    return GameType.spin;
  }
}

/// Game Meta Model
@immutable
class GameModel {
  final String id;
  final String name;
  final GameType type;
  final bool enabled;
  final double minStake;
  final double maxStake;
  final String description;
  final String badge;

  const GameModel({
    required this.id,
    required this.name,
    required this.type,
    this.enabled = true,
    this.minStake = 10.0,
    this.maxStake = 1000.0,
    this.description = '',
    this.badge = 'HOT',
  });

  GameModel copyWith({
    String? id,
    String? name,
    GameType? type,
    bool? enabled,
    double? minStake,
    double? maxStake,
    String? description,
    String? badge,
  }) {
    return GameModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      enabled: enabled ?? this.enabled,
      minStake: minStake ?? this.minStake,
      maxStake: maxStake ?? this.maxStake,
      description: description ?? this.description,
      badge: badge ?? this.badge,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type.code,
    'enabled': enabled,
    'minStake': minStake,
    'maxStake': maxStake,
    'description': description,
    'badge': badge,
  };

  factory GameModel.fromJson(Map<String, dynamic> json) => GameModel(
    id: json['id'] as String? ?? '',
    name: json['name'] as String? ?? '',
    type: GameType.fromString(json['type'] as String?),
    enabled: json['enabled'] as bool? ?? true,
    minStake: (json['minStake'] as num?)?.toDouble() ?? 10.0,
    maxStake: (json['maxStake'] as num?)?.toDouble() ?? 1000.0,
    description: json['description'] as String? ?? '',
    badge: json['badge'] as String? ?? 'HOT',
  );
}

/// Aviator Round States
enum RoundStatus {
  waiting('WAITING'),
  running('RUNNING'),
  crashed('CRASHED'),
  settled('SETTLED');

  final String code;
  const RoundStatus(this.code);

  static RoundStatus fromString(String? value) {
    for (final s in RoundStatus.values) {
      if (s.code == value || s.name == value) return s;
    }
    return RoundStatus.waiting;
  }
}

/// Game Round Document Model
@immutable
class GameRoundModel {
  final String id;
  final String gameId;
  final RoundStatus status;
  final double crashMultiplier;
  final DateTime startAt;
  final DateTime? endedAt;

  const GameRoundModel({
    required this.id,
    required this.gameId,
    required this.status,
    required this.crashMultiplier,
    required this.startAt,
    this.endedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'gameId': gameId,
    'status': status.code,
    'crashMultiplier': crashMultiplier,
    'startAt': startAt.toIso8601String(),
    'endedAt': endedAt?.toIso8601String(),
  };

  factory GameRoundModel.fromJson(Map<String, dynamic> json) => GameRoundModel(
    id: json['id'] as String? ?? '',
    gameId: json['gameId'] as String? ?? '',
    status: RoundStatus.fromString(json['status'] as String?),
    crashMultiplier: (json['crashMultiplier'] as num?)?.toDouble() ?? 1.0,
    startAt: json['startAt'] != null
        ? DateTime.tryParse(json['startAt'] as String) ?? DateTime.now()
        : DateTime.now(),
    endedAt: json['endedAt'] != null
        ? DateTime.tryParse(json['endedAt'] as String)
        : null,
  );
}

/// Bet Status
enum BetStatus {
  placed('PLACED'),
  cashedOut('CASHED_OUT'),
  won('WON'),
  lost('LOST'),
  cancelled('CANCELLED');

  final String code;
  const BetStatus(this.code);

  static BetStatus fromString(String? value) {
    for (final s in BetStatus.values) {
      if (s.code == value || s.name == value) return s;
    }
    return BetStatus.placed;
  }
}

/// Game Bet Document Model
@immutable
class GameBetModel {
  final String id;
  final String uid;
  final String username;
  final String roundId;
  final GameType gameType;
  final double stake;
  final double? autoCashout;
  final double cashoutMultiplier;
  final double payout;
  final BetStatus status;
  final DateTime createdAt;

  const GameBetModel({
    required this.id,
    required this.uid,
    this.username = 'Player',
    required this.roundId,
    required this.gameType,
    required this.stake,
    this.autoCashout,
    this.cashoutMultiplier = 0.0,
    this.payout = 0.0,
    this.status = BetStatus.placed,
    required this.createdAt,
  });

  bool get isWin => status == BetStatus.cashedOut || status == BetStatus.won;
  bool get isSettled => status != BetStatus.placed;
  double? get cashedMultiplier => cashoutMultiplier > 0 ? cashoutMultiplier : null;

  GameBetModel copyWith({
    String? id,
    String? uid,
    String? username,
    String? roundId,
    GameType? gameType,
    double? stake,
    double? autoCashout,
    double? cashoutMultiplier,
    double? payout,
    BetStatus? status,
    DateTime? createdAt,
  }) {
    return GameBetModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      username: username ?? this.username,
      roundId: roundId ?? this.roundId,
      gameType: gameType ?? this.gameType,
      stake: stake ?? this.stake,
      autoCashout: autoCashout ?? this.autoCashout,
      cashoutMultiplier: cashoutMultiplier ?? this.cashoutMultiplier,
      payout: payout ?? this.payout,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'uid': uid,
    'username': username,
    'roundId': roundId,
    'gameType': gameType.code,
    'stake': stake,
    'autoCashout': autoCashout,
    'cashoutMultiplier': cashoutMultiplier,
    'payout': payout,
    'status': status.code,
    'createdAt': createdAt.toIso8601String(),
  };

  factory GameBetModel.fromJson(Map<String, dynamic> json) => GameBetModel(
    id: json['id'] as String? ?? '',
    uid: json['uid'] as String? ?? '',
    username: json['username'] as String? ?? 'Player',
    roundId: json['roundId'] as String? ?? '',
    gameType: GameType.fromString(json['gameType'] as String?),
    stake: (json['stake'] as num?)?.toDouble() ?? 0.0,
    autoCashout: (json['autoCashout'] as num?)?.toDouble(),
    cashoutMultiplier: (json['cashoutMultiplier'] as num?)?.toDouble() ?? 0.0,
    payout: (json['payout'] as num?)?.toDouble() ?? 0.0,
    status: BetStatus.fromString(json['status'] as String?),
    createdAt: json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
        : DateTime.now(),
  );
}

/// Points Ledger Entry
enum PointType {
  earn('EARN'),
  bonus('BONUS'),
  adjustment('ADJUSTMENT'),
  redeem('REDEEM');

  final String code;
  const PointType(this.code);

  static PointType fromString(String? value) {
    for (final p in PointType.values) {
      if (p.code == value || p.name == value) return p;
    }
    return PointType.earn;
  }
}

@immutable
class PointsLedgerModel {
  final String id;
  final String uid;
  final int points;
  final PointType type;
  final String source;
  final String referenceId;
  final DateTime createdAt;

  const PointsLedgerModel({
    required this.id,
    required this.uid,
    required this.points,
    required this.type,
    required this.source,
    required this.referenceId,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'uid': uid,
    'points': points,
    'type': type.code,
    'source': source,
    'referenceId': referenceId,
    'createdAt': createdAt.toIso8601String(),
  };

  factory PointsLedgerModel.fromJson(Map<String, dynamic> json) => PointsLedgerModel(
    id: json['id'] as String? ?? '',
    uid: json['uid'] as String? ?? '',
    points: (json['points'] as num?)?.toInt() ?? 0,
    type: PointType.fromString(json['type'] as String?),
    source: json['source'] as String? ?? 'SYSTEM',
    referenceId: json['referenceId'] as String? ?? '',
    createdAt: json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
        : DateTime.now(),
  );
}

/// App Notification Model
@immutable
class AppNotificationModel {
  final String id;
  final String uid;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final DateTime createdAt;

  const AppNotificationModel({
    required this.id,
    required this.uid,
    required this.title,
    required this.message,
    this.type = 'INFO',
    this.isRead = false,
    required this.createdAt,
  });

  AppNotificationModel copyWith({
    String? id,
    String? uid,
    String? title,
    String? message,
    String? type,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return AppNotificationModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'uid': uid,
    'title': title,
    'message': message,
    'type': type,
    'isRead': isRead,
    'createdAt': createdAt.toIso8601String(),
  };

  factory AppNotificationModel.fromJson(Map<String, dynamic> json) => AppNotificationModel(
    id: json['id'] as String? ?? '',
    uid: json['uid'] as String? ?? '',
    title: json['title'] as String? ?? '',
    message: json['message'] as String? ?? '',
    type: json['type'] as String? ?? 'INFO',
    isRead: json['isRead'] as bool? ?? false,
    createdAt: json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
        : DateTime.now(),
  );
}

/// Admin Action Audit Log Model
@immutable
class AdminActionModel {
  final String id;
  final String adminUid;
  final String adminUsername;
  final String actionType;
  final String targetUid;
  final String details;
  final DateTime createdAt;

  const AdminActionModel({
    required this.id,
    required this.adminUid,
    this.adminUsername = 'Admin',
    required this.actionType,
    required this.targetUid,
    required this.details,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'adminUid': adminUid,
    'adminUsername': adminUsername,
    'actionType': actionType,
    'targetUid': targetUid,
    'details': details,
    'createdAt': createdAt.toIso8601String(),
  };

  factory AdminActionModel.fromJson(Map<String, dynamic> json) => AdminActionModel(
    id: json['id'] as String? ?? '',
    adminUid: json['adminUid'] as String? ?? '',
    adminUsername: json['adminUsername'] as String? ?? 'Admin',
    actionType: json['actionType'] as String? ?? '',
    targetUid: json['targetUid'] as String? ?? '',
    details: json['details'] as String? ?? '',
    createdAt: json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
        : DateTime.now(),
  );
}

/// System Settings Model
@immutable
class SystemSettingsModel {
  final double conversionRate; // e.g. 1 USD = 100 Credits
  final double minDeposit;
  final double maxDeposit;
  final double minWithdrawal;
  final double maxWithdrawal;
  final int silverThreshold;
  final int goldThreshold;
  final int diamondThreshold;

  const SystemSettingsModel({
    this.conversionRate = 100.0,
    this.minDeposit = 20.0,
    this.maxDeposit = 5000.0,
    this.minWithdrawal = 20.0,
    this.maxWithdrawal = 5000.0,
    this.silverThreshold = 0,
    this.goldThreshold = 1000,
    this.diamondThreshold = 5000,
  });
}
