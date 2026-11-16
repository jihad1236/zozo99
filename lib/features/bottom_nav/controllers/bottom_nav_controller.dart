import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zozo99/features/games/presentation/screens/games_hub_screen.dart';
import 'package:zozo99/features/landing/presentation/screens/landing_screen.dart';
import 'package:zozo99/features/points/presentation/screens/points_screen.dart';
import 'package:zozo99/features/profile/presentation/screens/profile_screen.dart';
import 'package:zozo99/features/wallet/presentation/screens/wallet_screen.dart';

class NavItem {
  final String title;
  final IconData icon;
  final IconData activeIcon;

  const NavItem({
    required this.title,
    required this.icon,
    IconData? activeIcon,
  }) : activeIcon = activeIcon ?? icon;
}

class BottomNavController extends GetxController {
  final RxInt currentIndex = 0.obs; // default to Lobby (index 0)

  final List<NavItem> items = const [
    NavItem(
      title: 'Lobby',
      icon: Iconsax.home,
      activeIcon: Iconsax.home_15,
    ),
    NavItem(
      title: 'Games',
      icon: Iconsax.game,
      activeIcon: Iconsax.game5,
    ),
    NavItem(
      title: 'Wallet',
      icon: Iconsax.wallet_3,
      activeIcon: Iconsax.wallet_35,
    ),
    NavItem(
      title: 'VIP Club',
      icon: Iconsax.crown,
      activeIcon: Iconsax.crown1,
    ),
    NavItem(
      title: 'Profile',
      icon: Iconsax.user,
      activeIcon: Iconsax.user_tag,
    ),
  ];

  final List<Widget> screens = const [
    LandingScreen(),
    GamesHubScreen(),
    WalletScreen(),
    PointsScreen(),
    ProfileScreen(),
  ];

  void changeIndex(int index) {
    if (index >= 0 && index < screens.length) {
      currentIndex.value = index;
    }
  }
}
