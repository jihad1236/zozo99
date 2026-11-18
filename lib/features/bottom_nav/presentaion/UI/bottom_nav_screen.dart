import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zozo99/core/models/betting_models.dart';
import 'package:zozo99/core/repositories/betting_repository.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/features/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:zozo99/features/bottom_nav/presentaion/widgets/web_top_menu_bar.dart';
import 'package:zozo99/features/games/presentation/screens/games_hub_screen.dart';
import 'package:zozo99/features/home/presentation/screens/home_lobby_screen.dart';
import 'package:zozo99/features/landing/presentation/screens/landing_screen.dart';
import 'package:zozo99/features/points/presentation/screens/points_screen.dart';
import 'package:zozo99/features/profile/presentation/screens/profile_screen.dart';
import 'package:zozo99/features/wallet/presentation/screens/wallet_screen.dart';

class BottomNavScreen extends StatelessWidget {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<BottomNavController>()
        ? Get.find<BottomNavController>()
        : Get.put(BottomNavController());
    final repository = Get.find<BettingRepository>();

    final isWideWeb = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: isWideWeb
          ? PreferredSize(
              preferredSize: const Size.fromHeight(72),
              child: WebTopMenuBar(controller: controller),
            )
          : null,
      body: StreamBuilder<UserModel?>(
        stream: repository.currentUserStream,
        initialData: repository.currentUser,
        builder: (context, snapshot) {
          final user = snapshot.data;
          final List<Widget> currentScreens = [
            user == null ? const LandingScreen() : const HomeLobbyScreen(),
            const GamesHubScreen(),
            const WalletScreen(),
            const PointsScreen(),
            const ProfileScreen(),
          ];

          return Obx(
            () => IndexedStack(
              index: controller.currentIndex.value,
              children: currentScreens,
            ),
          );
        },
      ),
      bottomNavigationBar: isWideWeb
          ? null
          : RepaintBoundary(
              child: _AppBottomNavBar(controller: controller),
            ),
    );
  }
}

class _AppBottomNavBar extends StatelessWidget {
  const _AppBottomNavBar({required this.controller});

  final BottomNavController controller;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0C101A).withValues(alpha: 0.90),
            border: const Border(
              top: BorderSide(color: Color(0xFF1E283D), width: 1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    controller.items.length,
                    (index) => _NavBarItem(
                      item: controller.items[index],
                      isSelected: controller.currentIndex.value == index,
                      onTap: () => controller.changeIndex(index),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const selectedColor = AppColors.aviatorRed;
    const unselectedColor = Color(0xFF757F9A);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? selectedColor.withValues(alpha: 0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  isSelected ? item.activeIcon : item.icon,
                  size: 22,
                  color: isSelected ? selectedColor : unselectedColor,
                ),
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isSelected ? Colors.white : unselectedColor,
                  letterSpacing: isSelected ? 0.3 : 0,
                ),
                child: Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
