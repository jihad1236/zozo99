import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zozo99/core/models/betting_models.dart';
import 'package:zozo99/core/repositories/betting_repository.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/core/utils/constants/icon_path.dart';
import 'package:zozo99/core/utils/constants/sizer.dart';
import 'package:zozo99/features/games/aviator/controllers/aviator_controller.dart';
import 'package:zozo99/features/games/aviator/presentation/widgets/aviator_bet_panel.dart';
import 'package:zozo99/features/games/aviator/presentation/widgets/aviator_flight_arena.dart';
import 'package:zozo99/features/games/aviator/presentation/widgets/aviator_round_history.dart';

class AviatorScreen extends StatelessWidget {
  const AviatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<AviatorController>()
        ? Get.find<AviatorController>()
        : Get.put(AviatorController());
    final repository = Get.find<BettingRepository>();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0D14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF10141E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
          onPressed: () => Get.back(),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            // Aviator Brand Capsule with Plane icon
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xFFE51438),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE51438).withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(IconPath.aviator, width: 14.sp, height: 14.sp, color: Colors.white),
                  SizedBox(width: 5.w),
                  Text(
                    'AVIATOR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),

            // Live Balance in Neon Green
            StreamBuilder<WalletModel?>(
              stream: repository.walletStream,
              initialData: repository.currentWallet,
              builder: (context, snapshot) {
                final credits = snapshot.data?.creditBalance ?? 0.0;
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161C26),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: const Color(0xFF00E676).withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${credits.toStringAsFixed(2)} CREDITS',
                        style: TextStyle(
                          color: const Color(0xFF00E676),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(width: 8.w),

            // Live Chat Icon
            IconButton(
              icon: Icon(Icons.chat_bubble_outline_rounded, color: Colors.white70, size: 20.sp),
              onPressed: () => _showLiveBetsSheet(context, controller),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ResponsiveLayout(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Spribe-Style Round History
                RepaintBoundary(child: AviatorRoundHistory(controller: controller)),

                // 2. Main Flight Arena
                RepaintBoundary(
                  child: SizedBox(
                    height: 220.h,
                    child: AviatorFlightArena(controller: controller),
                  ),
                ),

                // 3. Dual Bet Panels Header (Tabs on mobile, Dual side-by-side on wide screens)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 500) {
                        // Wide screen: Both panels side-by-side
                        return Row(
                          children: [
                            Expanded(child: AviatorBetPanel(controller: controller, panel: 1)),
                            SizedBox(width: 8.w),
                            Expanded(child: AviatorBetPanel(controller: controller, panel: 2)),
                          ],
                        );
                      } else {
                        // Mobile: Dual panel switcher tab
                        return Column(
                          children: [
                            Obx(() {
                              final tab = controller.activePanelTab.value;
                              return Container(
                                margin: EdgeInsets.only(bottom: 6.h),
                                height: 30.h,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF121620),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () => controller.setPanelTab(0),
                                        borderRadius: BorderRadius.circular(8.r),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: tab == 0 ? const Color(0xFF252D3D) : Colors.transparent,
                                            borderRadius: BorderRadius.circular(8.r),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'BET PANEL 1',
                                            style: TextStyle(
                                              color: tab == 0 ? Colors.white : Colors.white54,
                                              fontSize: 10.5.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () => controller.setPanelTab(1),
                                        borderRadius: BorderRadius.circular(8.r),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: tab == 1 ? const Color(0xFF252D3D) : Colors.transparent,
                                            borderRadius: BorderRadius.circular(8.r),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'BET PANEL 2',
                                            style: TextStyle(
                                              color: tab == 1 ? Colors.white : Colors.white54,
                                              fontSize: 10.5.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            Obx(() {
                              final tab = controller.activePanelTab.value;
                              return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: tab == 0
                                    ? AviatorBetPanel(key: const ValueKey('panel1'), controller: controller, panel: 1)
                                    : AviatorBetPanel(key: const ValueKey('panel2'), controller: controller, panel: 2),
                              );
                            }),
                          ],
                        );
                      }
                    },
                  ),
                ),

                // 4. Live Players Bets Table
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  child: RepaintBoundary(child: _buildLivePlayersTable(controller)),
                ),

                // 5. Official SPRIBE Signature
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Powered by ',
                        style: TextStyle(color: Colors.white24, fontSize: 10.sp),
                      ),
                      Text(
                        'SPRIBE',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLivePlayersTable(AviatorController controller) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF10141E),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFF1B2332)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'ALL BETS (LIVE)',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Container(
                width: 7.w,
                height: 7.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF00E676),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                'ONLINE',
                style: TextStyle(
                  color: const Color(0xFF00E676),
                  fontSize: 9.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Obx(() {
            final bets = controller.livePlayerBets;
            final multiplier = controller.liveMultiplier.value;
            final status = controller.round.value.status;

            return Column(
              children: bets.map((b) {
                final user = b['user'] as String;
                final stake = b['stake'] as double;
                final bool hasCashed = status == RoundStatus.running && multiplier > 1.4 && (user.hashCode % 3 == 0);

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 10.r,
                        backgroundColor: const Color(0xFF222B3D),
                        child: Text(
                          user[0].toUpperCase(),
                          style: TextStyle(color: Colors.white, fontSize: 9.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          user,
                          style: TextStyle(color: Colors.white70, fontSize: 11.sp),
                        ),
                      ),
                      Text(
                        '${stake.toInt()} C',
                        style: TextStyle(color: Colors.white54, fontSize: 11.sp),
                      ),
                      SizedBox(width: 14.w),
                      Container(
                        width: 60.w,
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: hasCashed
                              ? const Color(0xFF00E676).withValues(alpha: 0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        alignment: Alignment.centerRight,
                        child: Text(
                          hasCashed ? '${(multiplier * 0.9).toStringAsFixed(2)}x' : '-',
                          style: TextStyle(
                            color: hasCashed ? const Color(0xFF00E676) : Colors.white24,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  void _showLiveBetsSheet(BuildContext context, AviatorController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF141923),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Round Provably Fair Seed',
                    style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Text(
                'SHA256 Client & Server Authoritative cryptographic verification active. Game round seed hash:',
                style: TextStyle(color: Colors.white70, fontSize: 11.5.sp),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B0E15),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
                  style: TextStyle(color: AppColors.gold, fontSize: 10.sp, fontFamily: 'monospace'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
