import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zozo99/core/common/styles/global_text_style.dart';
import 'package:zozo99/core/models/betting_models.dart';
import 'package:zozo99/core/repositories/betting_repository.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/core/utils/constants/icon_path.dart';
import 'package:zozo99/features/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:zozo99/routes/app_routes.dart';

class WebTopMenuBar extends StatelessWidget {
  final BottomNavController controller;

  const WebTopMenuBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final BettingRepository repository = Get.find<BettingRepository>();

    return RepaintBoundary(
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 72,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0E17).withValues(alpha: 0.88),
              border: const Border(
                bottom: BorderSide(
                  color: Color(0xFF1F293D),
                  width: 1.0,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 24,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 1100;

                return Row(
                  children: [
                    // 1. BRAND LOGO & TITLE
                    InkWell(
                      onTap: () => controller.changeIndex(0),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.gold.withValues(alpha: 0.35),
                                    blurRadius: 14,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Image.asset(IconPath.appLogo, fit: BoxFit.contain),
                            ),
                            const SizedBox(width: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'zozo',
                                  style: AppTextStyle().boldTextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                                Text(
                                  '99',
                                  style: AppTextStyle().boldTextStyle(
                                    fontSize: 20,
                                    color: const Color(0xFFFF3B30),
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ],
                            ),
                            if (!isCompact) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E283D),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: const Color(0xFF2E3D59)),
                                ),
                                child: const Text(
                                  'CASINO',
                                  style: TextStyle(
                                    color: Color(0xFF00E676),
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // 2. CENTER NAVIGATION PILLS (Scrollable & Flexible, Never Overflows)
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Obx(() {
                            final currentIndex = controller.currentIndex.value;
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _WebNavItem(
                                  title: 'Lobby',
                                  icon: Iconsax.home_2,
                                  isSelected: currentIndex == 0,
                                  onTap: () => controller.changeIndex(0),
                                ),
                                const SizedBox(width: 6),
                                _WebNavItem(
                                  title: isCompact ? 'Games' : 'Games Arena',
                                  icon: Iconsax.game,
                                  isSelected: currentIndex == 1,
                                  onTap: () => controller.changeIndex(1),
                                ),
                                const SizedBox(width: 6),
                                _WebNavItem(
                                  title: isCompact ? 'Aviator' : 'Aviator Crash',
                                  icon: Icons.flight_takeoff_rounded,
                                  isSpecial: true,
                                  isSelected: false,
                                  onTap: () => Get.toNamed(AppRoute.aviatorScreen),
                                ),
                                const SizedBox(width: 6),
                                _WebNavItem(
                                  title: 'Wallet',
                                  icon: Iconsax.wallet_3,
                                  isSelected: currentIndex == 2,
                                  onTap: () => controller.changeIndex(2),
                                ),
                                const SizedBox(width: 6),
                                _WebNavItem(
                                  title: 'VIP',
                                  icon: Iconsax.crown,
                                  isSelected: currentIndex == 3,
                                  onTap: () => controller.changeIndex(3),
                                ),
                                const SizedBox(width: 6),
                                _WebNavItem(
                                  title: 'Profile',
                                  icon: Iconsax.user,
                                  isSelected: currentIndex == 4,
                                  onTap: () => controller.changeIndex(4),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // 3. USER BALANCE, NOTIFICATIONS & QUICK ACTIONS
                    StreamBuilder<UserModel?>(
                      stream: repository.currentUserStream,
                      initialData: repository.currentUser,
                      builder: (context, userSnapshot) {
                        final user = userSnapshot.data;

                        return StreamBuilder<WalletModel?>(
                          stream: repository.walletStream,
                          initialData: repository.currentWallet,
                          builder: (context, walletSnapshot) {
                            final wallet = walletSnapshot.data;
                            final balance = wallet?.cashBalance ?? 0.0;
                            final credits = wallet?.creditBalance ?? 0.0;

                            if (user != null) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Live Balance Glass Card
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isCompact ? 10 : 14,
                                      vertical: 7,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF131A26),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xFF26334D),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
                                            ),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              '\$',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              '\$${balance.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: isCompact ? 12 : 13,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            Text(
                                              '${credits.toInt()} Credits',
                                              style: const TextStyle(
                                                color: Color(0xFF8B9CB5),
                                                fontSize: 9.5,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),

                                  // Glowing "+ Deposit" Button
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF00E676), Color(0xFF00B0FF)],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF00E676).withValues(alpha: 0.35),
                                          blurRadius: 12,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () => Get.toNamed(AppRoute.depositScreen),
                                        borderRadius: BorderRadius.circular(12),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: isCompact ? 12 : 16,
                                            vertical: 9,
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.add_circle_outline, color: Colors.black, size: 15),
                                              const SizedBox(width: 5),
                                              Text(
                                                isCompact ? 'Deposit' : '+ Deposit',
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 12.5,
                                                  letterSpacing: 0.3,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),

                                  // Notification Bell Icon with Glass Effect
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF131A26),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: const Color(0xFF222C3F)),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Iconsax.notification, color: Color(0xFFB0C0D6), size: 18),
                                      tooltip: 'Notifications',
                                      constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
                                      padding: EdgeInsets.zero,
                                      onPressed: () => Get.toNamed(AppRoute.notificationsScreen),
                                    ),
                                  ),
                                  const SizedBox(width: 8),

                                  // Profile Avatar Chip
                                  InkWell(
                                    onTap: () => controller.changeIndex(4),
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isCompact ? 8 : 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF131A26),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: const Color(0xFF26334D)),
                                      ),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 13,
                                            backgroundColor: AppColors.gold.withValues(alpha: 0.2),
                                            child: Text(
                                              user.username.isNotEmpty ? user.username[0].toUpperCase() : 'U',
                                              style: const TextStyle(
                                                color: AppColors.gold,
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          if (!isCompact) ...[
                                            const SizedBox(width: 7),
                                            Text(
                                              user.username,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  OutlinedButton(
                                    onPressed: () => Get.toNamed(AppRoute.loginScreen),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: Color(0xFF2E3D59)),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    ),
                                    child: const Text(
                                      'Sign In',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF00E676), Color(0xFF00B0FF)],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF00E676).withValues(alpha: 0.35),
                                          blurRadius: 12,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () => Get.toNamed(AppRoute.loginScreen),
                                        borderRadius: BorderRadius.circular(10),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                                          child: Row(
                                            children: [
                                              Icon(Icons.person_add_alt_1_rounded, color: Colors.black, size: 15),
                                              SizedBox(width: 5),
                                              Text(
                                                'Sign Up',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 12.5,
                                                  letterSpacing: 0.3,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _WebNavItem extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final bool isSpecial;
  final VoidCallback onTap;

  const _WebNavItem({
    required this.title,
    required this.icon,
    required this.isSelected,
    this.isSpecial = false,
    required this.onTap,
  });

  @override
  State<_WebNavItem> createState() => _WebNavItemState();
}

class _WebNavItemState extends State<_WebNavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isSelected;
    final special = widget.isSpecial;

    Color bg;
    if (special) {
      bg = const Color(0xFFFF3B30).withValues(alpha: _isHovered ? 0.25 : 0.15);
    } else if (active) {
      bg = const Color(0xFF1A2336);
    } else if (_isHovered) {
      bg = const Color(0xFF131A26).withValues(alpha: 0.8);
    } else {
      bg = Colors.transparent;
    }

    Color borderColor;
    if (special) {
      borderColor = const Color(0xFFFF3B30).withValues(alpha: 0.4);
    } else if (active) {
      borderColor = const Color(0xFF384B6E);
    } else if (_isHovered) {
      borderColor = const Color(0xFF26334D);
    } else {
      borderColor = Colors.transparent;
    }

    Color contentColor;
    if (special) {
      contentColor = const Color(0xFFFF453A);
    } else if (active) {
      contentColor = const Color(0xFF00E676);
    } else if (_isHovered) {
      contentColor = Colors.white;
    } else {
      contentColor = const Color(0xFF8B9CB5);
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: const Color(0xFF00E676).withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: contentColor, size: 16),
              const SizedBox(width: 6),
              Text(
                widget.title,
                style: TextStyle(
                  color: contentColor,
                  fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                  fontSize: 12.5,
                  letterSpacing: 0.2,
                ),
              ),
              if (special) ...[
                const SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF3B30),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'HOT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
