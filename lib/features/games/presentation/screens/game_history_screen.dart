import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zozo99/core/common/styles/global_text_style.dart';
import 'package:zozo99/core/models/betting_models.dart';
import 'package:zozo99/core/repositories/betting_repository.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/core/utils/constants/icon_path.dart';
import 'package:zozo99/core/utils/constants/sizer.dart';

class GameHistoryScreen extends StatefulWidget {
  const GameHistoryScreen({super.key});

  @override
  State<GameHistoryScreen> createState() => _GameHistoryScreenState();
}

class _GameHistoryScreenState extends State<GameHistoryScreen> {
  final BettingRepository _repository = Get.find<BettingRepository>();
  GameType? selectedType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        title: Text(
          'Game Bets History',
          style: AppTextStyle().boldTextStyle(fontSize: 18.sp, color: Colors.white),
        ),
      ),
      body: ResponsiveLayout(
        child: Column(
          children: [
            // Filter Tabs
            _buildFilterTabs(),
            SizedBox(height: 10.h),

            // Bets List
            Expanded(
              child: StreamBuilder<List<GameBetModel>>(
                stream: _repository.gameBetsStream,
                initialData: _repository.gameBets,
                builder: (context, snapshot) {
                  var bets = snapshot.data ?? [];
                  if (selectedType != null) {
                    bets = bets.where((b) => b.gameType == selectedType).toList();
                  }

                  if (bets.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Iconsax.game, size: 48.sp, color: AppColors.darkTextDisabled),
                          SizedBox(height: 12.h),
                          Text(
                            'No game bets placed yet.',
                            style: AppTextStyle().mediumTextStyle(fontSize: 14.sp, color: AppColors.darkTextSecondary),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    itemCount: bets.length,
                    separatorBuilder: (_, _) => SizedBox(height: 10.h),
                    itemBuilder: (context, index) {
                      final bet = bets[index];
                      final isWin = bet.isWin;

                      return RepaintBoundary(
                        child: Container(
                          padding: EdgeInsets.all(14.r),
                          decoration: BoxDecoration(
                            color: AppColors.darkSurface,
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(color: AppColors.darkBorder),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44.w,
                                height: 44.w,
                                padding: EdgeInsets.all(8.r),
                                decoration: BoxDecoration(
                                  color: _getGameColor(bet.gameType).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Image.asset(
                                  _getGameAsset(bet.gameType),
                                  fit: BoxFit.contain,
                                ),
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
                                            bet.gameType.name.toUpperCase(),
                                            style: AppTextStyle().boldTextStyle(fontSize: 13.sp, color: Colors.white),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        if (bet.cashoutMultiplier > 0)
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                            decoration: BoxDecoration(
                                              color: AppColors.gold.withValues(alpha: 0.15),
                                              borderRadius: BorderRadius.circular(4.r),
                                            ),
                                            child: Text(
                                              '${bet.cashoutMultiplier.toStringAsFixed(2)}x',
                                              style: AppTextStyle().boldTextStyle(fontSize: 9.sp, color: AppColors.gold),
                                            ),
                                          ),
                                      ],
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      'Stake: ${bet.stake.toInt()} Credits',
                                      style: AppTextStyle().regularTextStyle(fontSize: 11.sp, color: AppColors.darkTextSecondary),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    isWin ? '+${bet.payout.toInt()} ⚡' : '-${bet.stake.toInt()} ⚡',
                                    style: AppTextStyle().boldTextStyle(
                                      fontSize: 14.sp,
                                      color: isWin ? AppColors.neonGreen : AppColors.aviatorRed,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    bet.status.name.toUpperCase(),
                                    style: AppTextStyle().boldTextStyle(
                                      fontSize: 10.sp,
                                      color: isWin ? AppColors.neonGreen : AppColors.darkTextDisabled,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    final filters = <String, GameType?>{
      'All': null,
      'Aviator': GameType.aviator,
      'Puzzle': GameType.puzzle,
      'Lucky Spin': GameType.spin,
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: filters.entries.map((entry) {
          final isSelected = selectedType == entry.value;
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: ChoiceChip(
              selected: isSelected,
              label: Text(entry.key),
              labelStyle: AppTextStyle().boldTextStyle(
                fontSize: 11.sp,
                color: isSelected ? Colors.white : AppColors.darkTextSecondary,
              ),
              backgroundColor: AppColors.darkSurfaceVariant,
              selectedColor: AppColors.aviatorRed,
              onSelected: (_) {
                setState(() {
                  selectedType = entry.value;
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getGameAsset(GameType type) {
    switch (type) {
      case GameType.aviator:
        return IconPath.aviator;
      case GameType.puzzle:
        return IconPath.puzzle;
      case GameType.spin:
        return IconPath.fortuneWheel;
    }
  }

  Color _getGameColor(GameType type) {
    switch (type) {
      case GameType.aviator:
        return AppColors.aviatorRed;
      case GameType.puzzle:
        return AppColors.neonCyan;
      case GameType.spin:
        return AppColors.gold;
    }
  }
}
