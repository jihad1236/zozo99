import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zozo99/core/common/styles/global_text_style.dart';
import 'package:zozo99/core/models/betting_models.dart';
import 'package:zozo99/core/repositories/betting_repository.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/core/utils/constants/icon_path.dart';
import 'package:zozo99/core/utils/constants/sizer.dart';
import 'package:zozo99/features/games/aviator/presentation/screens/aviator_screen.dart';
import 'package:zozo99/features/games/puzzle/presentation/screens/puzzle_screen.dart';
import 'package:zozo99/features/games/spin/presentation/screens/spin_screen.dart';

class GamesHubScreen extends StatefulWidget {
  const GamesHubScreen({super.key});

  @override
  State<GamesHubScreen> createState() => _GamesHubScreenState();
}

class _GamesHubScreenState extends State<GamesHubScreen> {
  final BettingRepository _repository = Get.find<BettingRepository>();
  String selectedCategory = 'ALL';

  @override
  Widget build(BuildContext context) {
    final isWideWeb = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: isWideWeb
          ? null
          : AppBar(
              backgroundColor: AppColors.darkBackground,
              elevation: 0,
              title: Text(
                'Games Arena',
                style: AppTextStyle().boldTextStyle(fontSize: 20.sp, color: Colors.white),
              ),
              actions: [
                StreamBuilder<WalletModel?>(
                  stream: _repository.walletStream,
                  initialData: _repository.currentWallet,
                  builder: (context, snapshot) {
                    final credits = snapshot.data?.creditBalance ?? 0.0;
                    return Container(
                      margin: EdgeInsets.only(right: 14.w),
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFF131A26),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: AppColors.gold.withValues(alpha: 0.35)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.bolt_rounded, color: AppColors.gold, size: 16.sp),
                          SizedBox(width: 4.w),
                          Text(
                            '${credits.toInt()} Credits',
                            style: AppTextStyle().boldTextStyle(fontSize: 12.sp, color: Colors.white),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
      body: ResponsiveLayout(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isWideWeb ? 24 : 16.w,
            vertical: isWideWeb ? 24 : 12.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isWideWeb) ...[
                // Web Top Glass Banner
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F1524).withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFF222C40)),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF162035).withValues(alpha: 0.7),
                        const Color(0xFF0C1019).withValues(alpha: 0.5),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00E676).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFF00E676).withValues(alpha: 0.3)),
                        ),
                        child: const Icon(Icons.sports_esports_rounded, color: Color(0xFF00E676), size: 28),
                      ),
                      const SizedBox(width: 16),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'GAMES ARENA',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 0.6,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Provably fair crash games, cyber match arcade, and lucky fortune spins',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF8B9CB5),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      StreamBuilder<WalletModel?>(
                        stream: _repository.walletStream,
                        initialData: _repository.currentWallet,
                        builder: (context, snapshot) {
                          final credits = snapshot.data?.creditBalance ?? 0.0;
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF131A26),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.bolt_rounded, color: AppColors.gold, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  '${credits.toInt()} Game Credits',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],

              // 1. Smooth Category Filter Pills Bar
              _buildCategoryPills(),
              SizedBox(height: 20.h),

              // 2. Responsive Game Cards Grid / List
              LayoutBuilder(
                builder: (context, constraints) {
                  final cards = _buildFilteredGameCards();

                  if (isWideWeb && constraints.maxWidth > 650) {
                    final columns = constraints.maxWidth > 1100 ? 3 : 2;
                    final cardWidth = (constraints.maxWidth - ((columns - 1) * 20)) / columns;

                    return Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: cards
                          .map(
                            (c) => SizedBox(
                              width: cardWidth,
                              child: c,
                            ),
                          )
                          .toList(),
                    );
                  }

                  return Column(
                    children: cards
                        .map(
                          (c) => Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: c,
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryPills() {
    final categories = [
      {'id': 'ALL', 'title': 'All Arenas', 'icon': Iconsax.category},
      {'id': 'CRASH', 'title': 'Crash Games', 'icon': Icons.flight_takeoff_rounded},
      {'id': 'ARCADE', 'title': 'Arcade & Puzzle', 'icon': Icons.extension_rounded},
      {'id': 'WHEEL', 'title': 'Daily Spins', 'icon': Icons.album_rounded},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: categories.map((cat) {
          final isSelected = selectedCategory == cat['id'];
          return _CategoryFilterPill(
            title: cat['title'] as String,
            icon: cat['icon'] as IconData,
            isSelected: isSelected,
            onTap: () {
              setState(() {
                selectedCategory = cat['id'] as String;
              });
            },
          );
        }).toList(),
      ),
    );
  }

  List<Widget> _buildFilteredGameCards() {
    final List<Widget> cards = [];

    if (selectedCategory == 'ALL' || selectedCategory == 'CRASH') {
      cards.add(
        _GameHubCard(
          title: 'Aviator Crash',
          subtitle: 'Multiplayer Real-time Cashout',
          badge: 'HOTTEST 🔥',
          multiplier: 'Up to 100X',
          minStake: 10,
          maxStake: 5000,
          accentColor: AppColors.aviatorRed,
          icon: Icons.flight_takeoff_rounded,
          imageAsset: IconPath.aviator,
          gradient: const LinearGradient(
            colors: [Color(0xFF2C141D), Color(0xFF131722)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          onTap: () => Get.to(() => const AviatorScreen()),
        ),
      );
    }

    if (selectedCategory == 'ALL' || selectedCategory == 'ARCADE') {
      cards.add(
        _GameHubCard(
          title: 'Cyber Match Rush',
          subtitle: 'Strategy Gem Combo Multipliers',
          badge: 'ARCADE 🧩',
          multiplier: 'Up to 3.5X',
          minStake: 20,
          maxStake: 2000,
          accentColor: AppColors.neonCyan,
          icon: Icons.extension_rounded,
          imageAsset: IconPath.puzzle,
          gradient: const LinearGradient(
            colors: [Color(0xFF12232F), Color(0xFF131722)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          onTap: () => Get.to(() => const PuzzleScreen()),
        ),
      );
    }

    if (selectedCategory == 'ALL' || selectedCategory == 'WHEEL') {
      cards.add(
        _GameHubCard(
          title: 'Lucky Fortune Wheel',
          subtitle: 'Daily Jackpot & Guaranteed Credits',
          badge: 'DAILY WHEEL 🎡',
          multiplier: 'Free Bonus Credits',
          minStake: 25,
          maxStake: 2500,
          accentColor: AppColors.gold,
          icon: Icons.album_rounded,
          imageAsset: IconPath.fortuneWheel,
          gradient: const LinearGradient(
            colors: [Color(0xFF2A2213), Color(0xFF131722)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          onTap: () => Get.to(() => const SpinScreen()),
        ),
      );
    }

    return cards;
  }
}

class _CategoryFilterPill extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryFilterPill({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_CategoryFilterPill> createState() => _CategoryFilterPillState();
}

class _CategoryFilterPillState extends State<_CategoryFilterPill> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isSelected;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          margin: EdgeInsets.only(right: 10.w),
          decoration: BoxDecoration(
            color: active
                ? const Color(0xFF1E283D)
                : (_isHovered ? const Color(0xFF181F2D) : const Color(0xFF111622)),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: active
                  ? const Color(0xFF00E676)
                  : (_isHovered ? const Color(0xFF33435F) : const Color(0xFF202A3C)),
              width: active ? 1.5 : 1,
            ),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: const Color(0xFF00E676).withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 15.sp,
                color: active ? const Color(0xFF00E676) : const Color(0xFF8B9CB5),
              ),
              SizedBox(width: 8.w),
              Text(
                widget.title,
                style: TextStyle(
                  color: active ? Colors.white : const Color(0xFF8B9CB5),
                  fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                  fontSize: 12.sp,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GameHubCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String badge;
  final String multiplier;
  final int minStake;
  final int maxStake;
  final Color accentColor;
  final IconData icon;
  final String? imageAsset;
  final Gradient gradient;
  final VoidCallback onTap;

  const _GameHubCard({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.multiplier,
    required this.minStake,
    required this.maxStake,
    required this.accentColor,
    required this.icon,
    this.imageAsset,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<_GameHubCard> createState() => _GameHubCardState();
}

class _GameHubCardState extends State<_GameHubCard> {
  bool _isCardHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isCardHovered = true),
      onExit: (_) => setState(() => _isCardHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(
              color: widget.accentColor.withValues(
                alpha: _isCardHovered ? 0.65 : 0.30,
              ),
              width: _isCardHovered ? 1.5 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.accentColor.withValues(
                  alpha: _isCardHovered ? 0.25 : 0.10,
                ),
                blurRadius: _isCardHovered ? 24 : 14,
                offset: Offset(0, _isCardHovered ? 8 : 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22.r),
                  gradient: widget.gradient,
                ),
                padding: EdgeInsets.all(18.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row: Icon/Asset + Titles + Badge
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 56.w,
                          height: 56.w,
                          padding: EdgeInsets.all(widget.imageAsset != null ? 8.r : 12.r),
                          decoration: BoxDecoration(
                            color: widget.accentColor.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: widget.accentColor.withValues(alpha: 0.35),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: widget.accentColor.withValues(alpha: 0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: widget.imageAsset != null
                              ? Image.asset(widget.imageAsset!, fit: BoxFit.contain)
                              : Icon(widget.icon, color: widget.accentColor, size: 28.sp),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      widget.title,
                                      style: AppTextStyle().boldTextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                                    decoration: BoxDecoration(
                                      color: widget.accentColor.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(6.r),
                                      border: Border.all(
                                        color: widget.accentColor.withValues(alpha: 0.35),
                                        width: 0.8,
                                      ),
                                    ),
                                    child: Text(
                                      widget.badge,
                                      style: AppTextStyle().boldTextStyle(
                                        fontSize: 9.5.sp,
                                        color: widget.accentColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                widget.subtitle,
                                style: AppTextStyle().regularTextStyle(
                                  fontSize: 11.5.sp,
                                  color: const Color(0xFF8B9CB5),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Potential: ${widget.multiplier}',
                                style: AppTextStyle().boldTextStyle(
                                  fontSize: 12.sp,
                                  color: widget.accentColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    const Divider(height: 1, color: Color(0xFF222C3F)),
                    SizedBox(height: 14.h),

                    // Bottom Row: Stakes Info + Smooth Standard Action Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F1522).withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: const Color(0xFF1E283A)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.bolt_rounded, color: AppColors.gold, size: 14),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    '${widget.minStake} - ${widget.maxStake} Stakes',
                                    style: AppTextStyle().regularTextStyle(
                                      fontSize: 11.sp,
                                      color: const Color(0xFFB0C0D6),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        _GamePlayButton(
                          label: 'PLAY NOW',
                          icon: Icons.play_arrow_rounded,
                          accentColor: widget.accentColor,
                          onTap: widget.onTap,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GamePlayButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;

  const _GamePlayButton({
    required this.label,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });

  @override
  State<_GamePlayButton> createState() => _GamePlayButtonState();
}

class _GamePlayButtonState extends State<_GamePlayButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 10.h,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.accentColor,
                Color.lerp(widget.accentColor, Colors.white, 0.25)!,
              ],
            ),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: widget.accentColor.withValues(alpha: _isHovered ? 0.65 : 0.35),
                blurRadius: _isHovered ? 16 : 10,
                offset: Offset(0, _isHovered ? 4 : 2),
                spreadRadius: _isHovered ? 1 : 0,
              ),
            ],
          ),
          transform: Matrix4.diagonal3Values(_isHovered ? 1.04 : 1.0, _isHovered ? 1.04 : 1.0, 1.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 16.sp, color: Colors.black),
              SizedBox(width: 6.w),
              Text(
                widget.label,
                style: AppTextStyle().boldTextStyle(
                  fontSize: 12.sp,
                  color: Colors.black,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
