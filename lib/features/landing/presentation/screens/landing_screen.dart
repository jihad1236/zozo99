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
    final controller = Get.put(LandingController());

    return Scaffold(
      backgroundColor: const Color(0xFF0A0D14),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF00B67A),
          backgroundColor: const Color(0xFF141923),
          onRefresh: () async {
            // Trigger quick refresh
            await Future.delayed(const Duration(milliseconds: 300));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LandingHeader(controller: controller),
                LandingHeroCarousel(controller: controller),
                const LandingTicker(),
                LandingCategoryBar(controller: controller),
                LandingGamesGrid(controller: controller),
                const LandingVipSection(),
                const LandingSponsorships(),
                const LandingAmbassadors(),
                const LandingFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
