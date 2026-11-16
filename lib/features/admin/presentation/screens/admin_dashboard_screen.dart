import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zozo99/core/common/styles/global_text_style.dart';
import 'package:zozo99/core/models/betting_models.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/core/utils/constants/sizer.dart';
import 'package:zozo99/features/admin/controllers/admin_controller.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AdminController controller = Get.put(AdminController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.aviatorRed,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                'ADMIN',
                style: AppTextStyle().boldTextStyle(fontSize: 11.sp, color: Colors.white, letterSpacing: 1.0),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              'Management Console',
              style: AppTextStyle().boldTextStyle(fontSize: 18.sp, color: Colors.white),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // KPI Metric Cards
          _buildKpiMetrics(controller),
          SizedBox(height: 12.h),

          // Admin Tabs
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: AppColors.darkSurfaceVariant,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppColors.aviatorRed,
                borderRadius: BorderRadius.circular(10.r),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.darkTextSecondary,
              labelStyle: AppTextStyle().boldTextStyle(fontSize: 11.sp),
              tabs: const [
                Tab(text: 'Users'),
                Tab(text: 'Withdrawals'),
                Tab(text: 'Games'),
                Tab(text: 'Audit Logs'),
              ],
            ),
          ),
          SizedBox(height: 12.h),

          // Tab views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildUsersTab(controller),
                _buildWithdrawalsTab(controller),
                _buildGamesTab(controller),
                _buildAuditLogsTab(controller),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiMetrics(AdminController controller) {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            Expanded(
              child: _buildMetricTile(
                label: 'TOTAL USERS',
                value: controller.totalUsers.toString(),
                icon: Iconsax.profile_2user,
                color: AppColors.neonCyan,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _buildMetricTile(
                label: 'DEPOSITS',
                value: '\$${controller.totalDeposits.toInt()}',
                icon: Iconsax.money_recive,
                color: AppColors.neonGreen,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _buildMetricTile(
                label: 'PENDING WTH',
                value: controller.pendingWithdrawalsCount.toString(),
                icon: Iconsax.timer,
                color: controller.pendingWithdrawalsCount > 0 ? AppColors.gold : AppColors.darkTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18.sp),
          SizedBox(height: 6.h),
          Text(
            value,
            style: AppTextStyle().boldTextStyle(fontSize: 16.sp, color: Colors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: AppTextStyle().boldTextStyle(fontSize: 9.sp, color: AppColors.darkTextSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildUsersTab(AdminController controller) {
    return Obx(() {
      final users = controller.users;
      return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        itemCount: users.length,
        separatorBuilder: (_, _) => SizedBox(height: 10.h),
        itemBuilder: (context, index) {
          final u = users[index];
          final isBlocked = u.isBlocked;

          return Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: u.isAdmin ? AppColors.aviatorRed : AppColors.accent,
                  child: Text(u.username[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              u.username,
                              style: AppTextStyle().boldTextStyle(fontSize: 14.sp, color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: isBlocked ? AppColors.error.withValues(alpha: 0.2) : AppColors.neonGreen.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              u.status.name.toUpperCase(),
                              style: AppTextStyle().boldTextStyle(
                                fontSize: 9.sp,
                                color: isBlocked ? AppColors.error : AppColors.neonGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Text(u.email, style: AppTextStyle().regularTextStyle(fontSize: 11.sp, color: AppColors.darkTextSecondary)),
                      Text('${u.tier.label} VIP  •  ${u.points} Points', style: AppTextStyle().mediumTextStyle(fontSize: 10.sp, color: AppColors.gold)),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white70),
                  color: AppColors.darkSurfaceVariant,
                  onSelected: (val) {
                    if (val == 'toggle_block') {
                      controller.toggleBlock(u.uid);
                    } else if (val == 'adjust') {
                      _showAdjustDialog(context, controller, u);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'toggle_block',
                      child: Text(
                        isBlocked ? 'Unblock User' : 'Block User',
                        style: TextStyle(color: isBlocked ? AppColors.neonGreen : AppColors.error),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'adjust',
                      child: Text('Adjust Balance / Points', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _buildWithdrawalsTab(AdminController controller) {
    return Obx(() {
      final reqs = controller.withdrawalRequests;
      if (reqs.isEmpty) {
        return Center(
          child: Text('No withdrawal requests found', style: AppTextStyle().mediumTextStyle(fontSize: 14.sp, color: AppColors.darkTextSecondary)),
        );
      }

      return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        itemCount: reqs.length,
        separatorBuilder: (_, _) => SizedBox(height: 10.h),
        itemBuilder: (context, index) {
          final req = reqs[index];
          final isPending = req.status == TransactionStatus.pending;

          return Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${req.amount.toStringAsFixed(2)}',
                      style: AppTextStyle().boldTextStyle(fontSize: 18.sp, color: Colors.white),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: isPending ? AppColors.gold.withValues(alpha: 0.15) : AppColors.neonGreen.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        req.status.code,
                        style: AppTextStyle().boldTextStyle(
                          fontSize: 10.sp,
                          color: isPending ? AppColors.gold : AppColors.neonGreen,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text('Method: ${req.method}  •  Account: ${req.accountNumber}', style: AppTextStyle().regularTextStyle(fontSize: 11.sp, color: AppColors.darkTextSecondary)),
                Text('Name: ${req.accountName}  •  Ref: ${req.referenceId}', style: AppTextStyle().regularTextStyle(fontSize: 10.sp, color: AppColors.darkTextDisabled)),
                if (isPending) ...[
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => controller.rejectWithdrawal(req.id, 'Risk check / Ineligible details'),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.error),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                          ),
                          child: Text('Reject & Refund', style: AppTextStyle().boldTextStyle(fontSize: 11.sp, color: AppColors.error)),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => controller.approveWithdrawal(req.id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.neonGreen,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                          ),
                          child: Text('Approve & Dispatch', style: AppTextStyle().boldTextStyle(fontSize: 11.sp, color: Colors.black)),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      );
    });
  }

  Widget _buildGamesTab(AdminController controller) {
    return Obx(() {
      final games = controller.games;
      return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        itemCount: games.length,
        separatorBuilder: (_, _) => SizedBox(height: 10.h),
        itemBuilder: (context, index) {
          final g = games[index];
          return Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(g.name, style: AppTextStyle().boldTextStyle(fontSize: 14.sp, color: Colors.white)),
                      SizedBox(height: 4.h),
                      Text('Min Stake: ${g.minStake.toInt()}  •  Max Stake: ${g.maxStake.toInt()}', style: AppTextStyle().regularTextStyle(fontSize: 11.sp, color: AppColors.darkTextSecondary)),
                    ],
                  ),
                ),
                Switch(
                  value: g.enabled,
                  onChanged: (_) => controller.toggleGame(g.id),
                  activeThumbColor: AppColors.neonGreen,
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _buildAuditLogsTab(AdminController controller) {
    return Obx(() {
      final logs = controller.auditLogs;
      if (logs.isEmpty) {
        return Center(
          child: Text('No audit logs recorded', style: AppTextStyle().mediumTextStyle(fontSize: 14.sp, color: AppColors.darkTextSecondary)),
        );
      }

      return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        itemCount: logs.length,
        separatorBuilder: (_, _) => SizedBox(height: 10.h),
        itemBuilder: (context, index) {
          final log = logs[index];
          return Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      log.actionType,
                      style: AppTextStyle().boldTextStyle(fontSize: 12.sp, color: AppColors.gold),
                    ),
                    Text(
                      '${log.createdAt.hour}:${log.createdAt.minute.toString().padLeft(2, '0')}',
                      style: AppTextStyle().regularTextStyle(fontSize: 10.sp, color: AppColors.darkTextDisabled),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(log.details, style: AppTextStyle().regularTextStyle(fontSize: 11.sp, color: Colors.white70)),
                SizedBox(height: 4.h),
                Text('Admin: ${log.adminUsername}  •  Target: ${log.targetUid}', style: AppTextStyle().regularTextStyle(fontSize: 9.sp, color: AppColors.darkTextDisabled)),
              ],
            ),
          );
        },
      );
    });
  }

  void _showAdjustDialog(BuildContext context, AdminController controller, UserModel user) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text('Adjust: ${user.username}', style: AppTextStyle().boldTextStyle(fontSize: 16.sp, color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller.adjustCashController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Cash Delta (+/- \$)', labelStyle: TextStyle(color: Colors.white70)),
              ),
              TextField(
                controller: controller.adjustCreditController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Credits Delta (+/- ⚡)', labelStyle: TextStyle(color: Colors.white70)),
              ),
              TextField(
                controller: controller.adjustPointsController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Points Delta (+/- pts)', labelStyle: TextStyle(color: Colors.white70)),
              ),
              TextField(
                controller: controller.adjustReasonController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Audit Reason (Required)', labelStyle: TextStyle(color: Colors.white70)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => controller.submitBalanceAdjustment(user.uid),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.aviatorRed),
            child: const Text('Apply Adjustment', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
