import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zozo99/core/models/betting_models.dart';
import 'package:zozo99/core/repositories/betting_repository.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/core/utils/constants/icon_path.dart';
import 'package:zozo99/features/games/aviator/presentation/screens/aviator_screen.dart';
import 'package:zozo99/features/games/puzzle/presentation/screens/puzzle_screen.dart';
import 'package:zozo99/features/games/spin/presentation/screens/spin_screen.dart';
import 'package:zozo99/routes/app_routes.dart';

class LandingController extends GetxController {
  final BettingRepository _repository = Get.find<BettingRepository>();

  final RxString selectedCategory = 'Popular'.obs;
  final RxString selectedSort = 'Recommended'.obs;
  final RxInt carouselIndex = 0.obs;
  final RxBool showAllGames = false.obs;

  Stream<UserModel?> get userStream => _repository.currentUserStream;
  UserModel? get currentUser => _repository.currentUser;
  bool get isLoggedIn => currentUser != null;

  Stream<WalletModel?> get walletStream => _repository.walletStream;
  WalletModel? get currentWallet => _repository.currentWallet;

  // Master Comprehensive Game Catalog
  static final List<Map<String, dynamic>> allGames = [
    // CRASH GAMES
    {
      'id': 'aviator_01',
      'title': 'AVIATOR',
      'provider': 'SPRIBE',
      'multiplier': '100x',
      'multiplierVal': 100,
      'category': 'Crash',
      'isPopular': true,
      'accent': AppColors.aviatorRed,
      'assetIcon': IconPath.aviator,
      'networkImage': 'https://picsum.photos/seed/aviator99/400/500',
      'type': GameType.aviator,
    },
    {
      'id': 'aviax_02',
      'title': 'AVIA X',
      'provider': 'MICROGAMING',
      'multiplier': '200x',
      'multiplierVal': 200,
      'category': 'Crash',
      'isPopular': true,
      'accent': const Color(0xFFFF5722),
      'assetIcon': IconPath.aviator,
      'networkImage': 'https://picsum.photos/seed/aviax_fly/400/500',
      'type': GameType.aviator,
    },
    {
      'id': 'spaceman_03',
      'title': 'SPACEMAN',
      'provider': 'PRAGMATIC',
      'multiplier': '500x',
      'multiplierVal': 500,
      'category': 'Crash',
      'isPopular': false,
      'accent': const Color(0xFF00E5FF),
      'assetIcon': IconPath.aviator,
      'networkImage': 'https://picsum.photos/seed/spaceman_bet/400/500',
      'type': GameType.aviator,
    },

    // SLOTS
    {
      'id': 'super_ace_01',
      'title': 'SUPER ACE PLUS',
      'provider': 'LUCKY365',
      'multiplier': '100x',
      'multiplierVal': 100,
      'category': 'Slots',
      'isPopular': true,
      'accent': const Color(0xFFFF9800),
      'assetIcon': IconPath.diamond,
      'networkImage': 'https://picsum.photos/seed/superace/400/500',
      'type': GameType.spin,
    },
    {
      'id': 'dragon_gems_02',
      'title': 'DRAGON GEMS',
      'provider': 'YELLOW BAT',
      'multiplier': '500x',
      'multiplierVal': 500,
      'category': 'Slots',
      'isPopular': true,
      'accent': const Color(0xFFFF3D00),
      'assetIcon': IconPath.diamond,
      'networkImage': 'https://picsum.photos/seed/dragongems/400/500',
      'type': GameType.spin,
    },
    {
      'id': 'fortune_garuda_03',
      'title': 'FORTUNE GARUDA',
      'provider': 'JILI',
      'multiplier': '500x',
      'multiplierVal': 500,
      'category': 'Slots',
      'isPopular': true,
      'accent': AppColors.gold,
      'assetIcon': IconPath.diamond,
      'networkImage': 'https://picsum.photos/seed/garuda_gold/400/500',
      'type': GameType.spin,
    },
    {
      'id': 'wild_showdown_04',
      'title': 'WILD SHOWDOWN',
      'provider': 'PG SOFT',
      'multiplier': '150x',
      'multiplierVal': 150,
      'category': 'Slots',
      'isPopular': false,
      'accent': const Color(0xFFE91E63),
      'assetIcon': IconPath.diamond,
      'networkImage': 'https://picsum.photos/seed/wild_pg/400/500',
      'type': GameType.spin,
    },
    {
      'id': 'gates_olympus_05',
      'title': 'GATES OF OLYMPUS',
      'provider': 'PRAGMATIC',
      'multiplier': '1000x',
      'multiplierVal': 1000,
      'category': 'Slots',
      'isPopular': true,
      'accent': const Color(0xFF9C27B0),
      'assetIcon': IconPath.diamond,
      'networkImage': 'https://picsum.photos/seed/olympus_zeus/400/500',
      'type': GameType.spin,
    },

    // CASINO / LIVE
    {
      'id': 'fortune_wheel_01',
      'title': 'FORTUNE WHEEL',
      'provider': 'ZOZO LIVE',
      'multiplier': 'JACKPOT',
      'multiplierVal': 888,
      'category': 'Casino',
      'isPopular': true,
      'accent': AppColors.gold,
      'assetIcon': IconPath.fortuneWheel,
      'networkImage': 'https://picsum.photos/seed/wheel_spin/400/500',
      'type': GameType.spin,
    },
    {
      'id': 'roulette_live_02',
      'title': 'LIGHTNING ROULETTE',
      'provider': 'EVOLUTION',
      'multiplier': '500x',
      'multiplierVal': 500,
      'category': 'Casino',
      'isPopular': true,
      'accent': const Color(0xFFFFC107),
      'assetIcon': IconPath.fortuneWheel,
      'networkImage': 'https://picsum.photos/seed/roulette_live/400/500',
      'type': GameType.spin,
    },
    {
      'id': 'baccarat_live_03',
      'title': 'SPEED BACCARAT',
      'provider': 'SEXY GAMING',
      'multiplier': '8x',
      'multiplierVal': 8,
      'category': 'Casino',
      'isPopular': false,
      'accent': const Color(0xFFE040FB),
      'assetIcon': IconPath.coin,
      'networkImage': 'https://picsum.photos/seed/baccarat_speed/400/500',
      'type': GameType.puzzle,
    },

    // ARCADE
    {
      'id': 'super_elements_01',
      'title': 'SUPER ELEMENTS',
      'provider': 'FA CHAI',
      'multiplier': '250x',
      'multiplierVal': 250,
      'category': 'Arcade',
      'isPopular': true,
      'accent': const Color(0xFF8B5CF6),
      'assetIcon': IconPath.joystick,
      'networkImage': 'https://picsum.photos/seed/super_elements/400/500',
      'type': GameType.puzzle,
    },
    {
      'id': 'cyber_match_02',
      'title': 'CYBER MATCH',
      'provider': 'ZOZO STUDIO',
      'multiplier': '3.5x',
      'multiplierVal': 3,
      'category': 'Arcade',
      'isPopular': true,
      'accent': const Color(0xFF00E5FF),
      'assetIcon': IconPath.puzzle,
      'networkImage': 'https://picsum.photos/seed/cyber_puzzle/400/500',
      'type': GameType.puzzle,
    },
    {
      'id': 'color_blast_03',
      'title': 'COLOR BLAST',
      'provider': 'JDB',
      'multiplier': '120x',
      'multiplierVal': 120,
      'category': 'Arcade',
      'isPopular': false,
      'accent': const Color(0xFF00E676),
      'assetIcon': IconPath.joystick,
      'networkImage': 'https://picsum.photos/seed/color_blast/400/500',
      'type': GameType.puzzle,
    },

    // TABLE
    {
      'id': 'blackjack_01',
      'title': 'CLASSIC BLACKJACK',
      'provider': 'MICROGAMING',
      'multiplier': '2.5x',
      'multiplierVal': 2,
      'category': 'Table',
      'isPopular': true,
      'accent': const Color(0xFF26A69A),
      'assetIcon': IconPath.coin,
      'networkImage': 'https://picsum.photos/seed/blackjack_classic/400/500',
      'type': GameType.puzzle,
    },
    {
      'id': 'teen_patti_02',
      'title': 'TEEN PATTI 20-20',
      'provider': 'KINGMAKER',
      'multiplier': '45x',
      'multiplierVal': 45,
      'category': 'Table',
      'isPopular': false,
      'accent': const Color(0xFFFF7043),
      'assetIcon': IconPath.coin,
      'networkImage': 'https://picsum.photos/seed/teen_patti/400/500',
      'type': GameType.spin,
    },
    {
      'id': 'andar_bahar_03',
      'title': 'ANDAR BAHAR',
      'provider': 'JILI',
      'multiplier': '1.95x',
      'multiplierVal': 2,
      'category': 'Table',
      'isPopular': false,
      'accent': const Color(0xFFAB47BC),
      'assetIcon': IconPath.coin,
      'networkImage': 'https://picsum.photos/seed/andar_bahar/400/500',
      'type': GameType.puzzle,
    },

    // SPORTS
    {
      'id': 'cricket_live_01',
      'title': 'CRICKET PREMIER',
      'provider': 'BETRADAR',
      'multiplier': 'LIVE',
      'multiplierVal': 99,
      'category': 'Sports',
      'isPopular': true,
      'accent': const Color(0xFFFF9800),
      'assetIcon': IconPath.joystick,
      'networkImage': 'https://picsum.photos/seed/cricket_match/400/500',
      'type': GameType.aviator,
    },
    {
      'id': 'soccer_league_02',
      'title': 'VIRTUAL EPL',
      'provider': 'BETFAIR',
      'multiplier': '85x',
      'multiplierVal': 85,
      'category': 'Sports',
      'isPopular': false,
      'accent': const Color(0xFF4CAF50),
      'assetIcon': IconPath.joystick,
      'networkImage': 'https://picsum.photos/seed/soccer_stadium/400/500',
      'type': GameType.aviator,
    },

    // FISHING
    {
      'id': 'ocean_king_01',
      'title': 'OCEAN KING 3',
      'provider': 'JILI',
      'multiplier': '300x',
      'multiplierVal': 300,
      'category': 'Fishing',
      'isPopular': true,
      'accent': const Color(0xFF03A9F4),
      'assetIcon': IconPath.diamond,
      'networkImage': 'https://picsum.photos/seed/ocean_king/400/500',
      'type': GameType.spin,
    },
    {
      'id': 'dragon_fishing_02',
      'title': 'DRAGON FISHING',
      'provider': 'FA CHAI',
      'multiplier': '500x',
      'multiplierVal': 500,
      'category': 'Fishing',
      'isPopular': false,
      'accent': const Color(0xFF00BCD4),
      'assetIcon': IconPath.diamond,
      'networkImage': 'https://picsum.photos/seed/dragon_fish/400/500',
      'type': GameType.spin,
    },

    // LOTTERY
    {
      'id': 'mega_keno_01',
      'title': 'TURBO KENO 80',
      'provider': 'ZOZO STUDIO',
      'multiplier': '1000x',
      'multiplierVal': 1000,
      'category': 'Lottery',
      'isPopular': true,
      'accent': const Color(0xFFE91E63),
      'assetIcon': IconPath.vip,
      'networkImage': 'https://picsum.photos/seed/keno_numbers/400/500',
      'type': GameType.spin,
    },
    {
      'id': 'lucky_numbers_02',
      'title': 'LUCKY 5/36',
      'provider': 'SPRIBE',
      'multiplier': '750x',
      'multiplierVal': 750,
      'category': 'Lottery',
      'isPopular': false,
      'accent': const Color(0xFFFF4081),
      'assetIcon': IconPath.coin,
      'networkImage': 'https://picsum.photos/seed/lucky_ball/400/500',
      'type': GameType.spin,
    },
  ];

  // Category & Sorting logic
  List<Map<String, dynamic>> get filteredGames {
    final cat = selectedCategory.value;
    List<Map<String, dynamic>> list;

    if (cat == 'Popular') {
      list = allGames.where((g) => g['isPopular'] == true).toList();
    } else {
      list = allGames
          .where((g) => (g['category'] as String).toLowerCase() == cat.toLowerCase())
          .toList();
      // If a category has fewer items, include popular games as recommended
      if (list.isEmpty) {
        list = allGames.where((g) => g['isPopular'] == true).toList();
      }
    }

    // Apply Sorting
    final sort = selectedSort.value;
    final sorted = List<Map<String, dynamic>>.from(list);
    if (sort == 'Highest Multiplier') {
      sorted.sort((a, b) => (b['multiplierVal'] as int).compareTo(a['multiplierVal'] as int));
    } else if (sort == 'A - Z') {
      sorted.sort((a, b) => (a['title'] as String).compareTo(b['title'] as String));
    }
    return sorted;
  }

  void selectCategory(String cat) {
    selectedCategory.value = cat;
  }

  void selectSort(String sort) {
    selectedSort.value = sort;
  }

  void setCarouselIndex(int index) {
    carouselIndex.value = index;
  }

  void toggleShowAllGames() {
    showAllGames.value = !showAllGames.value;
  }

  void onGameTap(GameType type) {
    if (isLoggedIn) {
      _navigateToGame(type);
    } else {
      _showGuestPlayOptions(type);
    }
  }

  void _navigateToGame(GameType type) {
    switch (type) {
      case GameType.aviator:
        Get.to(() => const AviatorScreen());
        break;
      case GameType.puzzle:
        Get.to(() => const PuzzleScreen());
        break;
      case GameType.spin:
        Get.to(() => const SpinScreen());
        break;
    }
  }

  void _showGuestPlayOptions(GameType type) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF141923),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: const [
            Icon(Icons.sports_esports_rounded, color: Color(0xFF00B67A), size: 24),
            SizedBox(width: 8),
            Text('Play Game', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'You are browsing as a Guest. Would you like to try the Free Demo or Sign In to play with live credits and earn VIP points?',
              style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              _navigateToGame(type); // Direct demo play
            },
            child: const Text('Try Free Demo', style: TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.toNamed(AppRoute.loginScreen);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00B67A),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Sign In / Register', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
