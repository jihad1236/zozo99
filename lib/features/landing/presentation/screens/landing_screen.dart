import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zozo99/features/landing/controllers/landing_controller.dart';
import 'package:zozo99/features/landing/presentation/widgets/landing_ambassadors.dart';
import 'package:zozo99/features/landing/presentation/widgets/landing_category_bar.dart';
import 'package:zozo99/features/landing/presentation/widgets/landing_footer.dart';
import 'package:zozo99/features/landing/presentation/widgets/landing_games_grid.dart';
import 'package:zozo99/features/landing/presentation/widgets/landing_header.dart';
import 'package:zozo99/features/landing/presentation/widgets/landing_hero_carousel.dart';
import 'package:zozo99/features/landing/presentation/widgets/landing_sponsorships.dart';
import 'package:zozo99/features/landing/presentation/widgets/landing_ticker.dart';
import 'package:zozo99/features/landing/presentation/widgets/landing_vip_section.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<LandingController>()
        ? Get.find<LandingController>()
        : Get.put(LandingController());

    return Scaffold(
      backgroundColor: const Color(0xFF0A0D14),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF00B67A),
          backgroundColor: const Color(0xFF141923),
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 250));
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: EdgeInsets.zero,
            children: [
              // 1. Header (Logo & Balance/Auth)
              RepaintBoundary(
                child: LandingHeader(controller: controller),
              ),

              // 2. Hero Carousel (Isolated sliding animations)
              RepaintBoundary(
                child: LandingHeroCarousel(controller: controller),
              ),

              // 3. Static Live Ticker Marquee
              const RepaintBoundary(
                child: LandingTicker(),
              ),

              // 4. Interactive Category Bar
              RepaintBoundary(
                child: LandingCategoryBar(controller: controller),
              ),

              // 5. Multi-Provider Games Grid
              RepaintBoundary(
                child: LandingGamesGrid(controller: controller),
              ),

              // 6. VIP Club Section (Cached static layout)
              const RepaintBoundary(
                child: LandingVipSection(),
              ),

              // 7. Official Sponsorships (Cached static layout)
              const RepaintBoundary(
                child: LandingSponsorships(),
              ),

              // 8. Brand Ambassadors (Cached static layout)
              const RepaintBoundary(
                child: LandingAmbassadors(),
              ),

              // 9. Multi-Column Footer & Compliance
              const RepaintBoundary(
                child: LandingFooter(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
