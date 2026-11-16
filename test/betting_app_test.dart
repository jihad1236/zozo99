import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:zozo99/core/models/betting_models.dart';
import 'package:zozo99/core/repositories/betting_repository.dart';
import 'package:zozo99/core/repositories/mock_betting_repository.dart';
import 'package:zozo99/features/games/aviator/controllers/aviator_controller.dart';
import 'package:zozo99/features/landing/controllers/landing_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockBettingRepository repository;

  setUp(() {
    repository = MockBettingRepository();
    repository.onInit();
  });

  tearDown(() {
    repository.onClose();
  });

  group('Betting & Gaming Engine Tests', () {
    test('Initial user and wallet are seeded properly', () {
      expect(repository.currentUser, isNotNull);
      expect(repository.currentUser!.username, 'AlexRider');
      expect(repository.currentUser!.tier, VipTier.gold);
      expect(repository.currentWallet, isNotNull);
      expect(repository.currentWallet!.cashBalance, greaterThan(0));
      expect(repository.currentWallet!.creditBalance, greaterThan(0));
    });

    test('VIP Tier calculation from points works accurately', () {
      expect(VipTier.fromPoints(200), VipTier.silver);
      expect(VipTier.fromPoints(1000), VipTier.gold);
      expect(VipTier.fromPoints(2500), VipTier.gold);
      expect(VipTier.fromPoints(5000), VipTier.diamond);
      expect(VipTier.fromPoints(10000), VipTier.diamond);
    });

    test('Cash to Credits conversion calculates accurately at 1:100 rate', () async {
      final initialCash = repository.currentWallet!.cashBalance;
      final initialCredits = repository.currentWallet!.creditBalance;

      await repository.convertCashToCredits(50.0);

      expect(repository.currentWallet!.cashBalance, initialCash - 50.0);
      expect(repository.currentWallet!.creditBalance, initialCredits + 5000.0);
      expect(repository.transactions.first.type, TransactionType.creditConversion);
    });

    test('Deposit adds cash balance and records transaction', () async {
      final initialCash = repository.currentWallet!.cashBalance;

      await repository.createDeposit(
        amount: 100.0,
        paymentMethod: 'Visa/Mastercard',
        accountNumber: '4111-XXXX-XXXX-1111',
        simulateInstantSuccess: true,
      );

      expect(repository.currentWallet!.cashBalance, initialCash + 100.0);
      expect(repository.transactions.first.type, TransactionType.deposit);
    });

    test('Withdrawal places request in pending status and deducts cash balance', () async {
      final initialCash = repository.currentWallet!.cashBalance;

      final req = await repository.requestWithdrawal(
        amount: 30.0,
        method: 'Bank Wire',
        accountNumber: 'ACC-99214',
        accountName: 'Alex Rider',
      );

      expect(req.status, TransactionStatus.pending);
      expect(repository.currentWallet!.cashBalance, initialCash - 30.0);
    });

    test('Points redemption converts VIP points to Credits', () async {
      final initialPoints = repository.currentUser!.points;
      final initialCredits = repository.currentWallet!.creditBalance;

      await repository.redeemPointsToCredits(200);

      expect(repository.currentUser!.points, initialPoints - 200);
      expect(repository.currentWallet!.creditBalance, initialCredits + 20.0); // 200 pts / 10 = 20 credits
    });

    test('Puzzle game handles win payout and ledger entry', () async {
      final initialCredits = repository.currentWallet!.creditBalance;

      final bet = await repository.playPuzzleGame(
        stake: 50.0,
        score: 160,
        moves: 8,
        won: true,
      );

      expect(bet.isWin, isTrue);
      expect(bet.payout, 150.0); // 3x multiplier
      expect(repository.currentWallet!.creditBalance, initialCredits - 50.0 + 150.0);
    });

    test('Admin toggles user block status', () async {
      final targetUser = repository.allUsers.firstWhere((u) => u.uid == 'user_02');
      expect(targetUser.isBlocked, isFalse);

      await repository.toggleUserBlock(targetUser.uid);
      final updated = repository.allUsers.firstWhere((u) => u.uid == targetUser.uid);
      expect(updated.isBlocked, isTrue);
    });

    test('Guest authentication state allows guest browsing and login toggle', () async {
      // Simulate guest logout
      await repository.logout();
      expect(repository.currentUser, isNull);
      expect(repository.currentWallet, isNull);

      // Sign in as user
      final user = await repository.login(email: 'user@zozo99.com', password: 'password123');
      expect(user.username, 'AlexRider');
      expect(repository.currentUser, isNotNull);
    });

    test('LandingController sorts and filters games by category and multiplier', () {
      Get.put<BettingRepository>(repository);
      final landingController = LandingController();

      // Default Popular games
      expect(landingController.selectedCategory.value, 'Popular');
      expect(landingController.filteredGames.isNotEmpty, isTrue);

      // Select Crash category
      landingController.selectCategory('Crash');
      expect(landingController.selectedCategory.value, 'Crash');
      for (final game in landingController.filteredGames) {
        expect(game['category'], 'Crash');
      }

      // Sort by Highest Multiplier
      landingController.selectSort('Highest Multiplier');
      final sortedGames = landingController.filteredGames;
      for (int i = 0; i < sortedGames.length - 1; i++) {
        expect(
          (sortedGames[i]['multiplierVal'] as int) >= (sortedGames[i + 1]['multiplierVal'] as int),
          isTrue,
        );
      }

      // Sort A - Z
      landingController.selectSort('A - Z');
      final alphaGames = landingController.filteredGames;
      for (int i = 0; i < alphaGames.length - 1; i++) {
        expect(
          (alphaGames[i]['title'] as String).compareTo(alphaGames[i + 1]['title'] as String) <= 0,
          isTrue,
        );
      }
    });

    test('AviatorController manages dual bet panels and presets', () async {
      Get.put<BettingRepository>(repository);
      final aviator = AviatorController();
      aviator.onInit();

      // Test presets on Panel 1 and Panel 2
      aviator.setPresetStake(1, 50.0);
      expect(aviator.stakeController1.text, '50.00');

      aviator.adjustStake(1, 10.0);
      expect(aviator.stakeController1.text, '60.00');

      aviator.setPresetStake(2, 100.0);
      expect(aviator.stakeController2.text, '100.00');

      // Test Auto Bet toggles
      aviator.toggleAutoBet(1, true);
      expect(aviator.isAutoBetEnabled1.value, isTrue);

      aviator.toggleAutoCashout(1, true);
      expect(aviator.isAutoCashoutEnabled1.value, isTrue);

      // Place bet on Panel 1
      await aviator.placeBet(1);
      expect(aviator.myBet1.value, isNotNull);
      expect(aviator.myBet1.value!.stake, 60.0);

      aviator.onClose();
    });
  });
}
