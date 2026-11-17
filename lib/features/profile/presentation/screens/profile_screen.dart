import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zozo99/core/common/styles/global_text_style.dart';
import 'package:zozo99/core/controllers/theme_controller.dart';
import 'package:zozo99/core/models/betting_models.dart';
import 'package:zozo99/core/repositories/betting_repository.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/core/utils/constants/sizer.dart';
import 'package:zozo99/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:zozo99/features/authentication/controllers/auth_controller.dart';
import 'package:zozo99/features/games/presentation/screens/game_history_screen.dart';
import 'package:zozo99/features/notifications/presentation/screens/notifications_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = Get.find<BettingRepository>();
    final authController = Get.find<AuthController>();
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        title: Text(
          'My Profile',
          style: AppTextStyle().boldTextStyle(
            fontSize: 18.sp,
            color: Colors.white,
          ),
        ),
      ),
      body: ResponsiveLayout(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            children: [
              // User Info Header Card wrapped in RepaintBoundary
              RepaintBoundary(
                child: StreamBuilder<UserModel?>(
                  stream: repository.currentUserStream,
                  initialData: repository.currentUser,
                  builder: (context, snapshot) {
                    final user = snapshot.data;
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.r),
                      decoration: BoxDecoration(
                        color: AppColors.darkSurface,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: AppColors.darkBorder),
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 36.r,
                            backgroundColor: user?.isAdmin == true
                                ? AppColors.aviatorRed
                                : AppColors.gold,
                            child: Text(
                              user?.username.substring(0, 1).toUpperCase() ?? 'U',
                              style: AppTextStyle().boldTextStyle(
                                fontSize: 28.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            user?.username ?? 'Gamer',
                            style: AppTextStyle().boldTextStyle(
                              fontSize: 18.sp,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            user?.email ?? '',
                            style: AppTextStyle().regularTextStyle(
                              fontSize: 12.sp,
                              color: AppColors.darkTextSecondary,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.gold.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    color: AppColors.gold.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Iconsax.crown,
                                      color: AppColors.gold,
                                      size: 14.sp,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      '${user?.tier.label.toUpperCase()} VIP',
                                      style: AppTextStyle().boldTextStyle(
                                        fontSize: 10.sp,
                                        color: AppColors.gold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: user?.isAdmin == true
                                      ? AppColors.aviatorRed.withValues(alpha: 0.15)
                                      : AppColors.neonCyan.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    color: user?.isAdmin == true
                                        ? AppColors.aviatorRed.withValues(
                                            alpha: 0.3,
                                          )
                                        : AppColors.neonCyan.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Text(
                                  user?.role.name.toUpperCase() ?? 'CUSTOMER',
                                  style: AppTextStyle().boldTextStyle(
                                    fontSize: 10.sp,
                                    color: user?.isAdmin == true
                                        ? AppColors.aviatorRed
                                        : AppColors.neonCyan,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16.h),

              // Navigation Options List wrapped in RepaintBoundary
              RepaintBoundary(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: AppColors.darkBorder),
                  ),
                  child: Column(
                    children: [
                      // Admin Console (Available for Admin users)
                      StreamBuilder<UserModel?>(
                        stream: repository.currentUserStream,
                        initialData: repository.currentUser,
                        builder: (context, snapshot) {
                          final isAdmin = snapshot.data?.isAdmin ?? false;
                          if (!isAdmin) return const SizedBox();
                          return Column(
                            children: [
                              _buildProfileOption(
                                icon: Iconsax.security_user,
                                title: 'Admin Management Panel',
                                color: AppColors.aviatorRed,
                                onTap: () =>
                                    Get.to(() => const AdminDashboardScreen()),
                              ),
                              const Divider(height: 1, color: AppColors.darkBorder),
                            ],
                          );
                        },
                      ),
                      _buildProfileOption(
                        icon: Iconsax.game,
                        title: 'Game Bets History',
                        color: AppColors.gold,
                        onTap: () => Get.to(() => const GameHistoryScreen()),
                      ),
                      const Divider(height: 1, color: AppColors.darkBorder),
                      _buildProfileOption(
                        icon: Iconsax.notification,
                        title: 'Notifications',
                        color: AppColors.neonCyan,
                        onTap: () => Get.to(() => const NotificationsScreen()),
                      ),
                      const Divider(height: 1, color: AppColors.darkBorder),
                      _buildProfileOption(
                        icon: Iconsax.user_edit,
                        title: 'Edit Personal Profile',
                        color: AppColors.accent,
                        onTap: () => _showEditProfileDialog(context, repository),
                      ),
                      const Divider(height: 1, color: AppColors.darkBorder),
                      _buildProfileOption(
                        icon: Iconsax.moon,
                        title: 'Toggle Dark / Light Theme',
                        color: AppColors.neonGreen,
                        onTap: () {
                          themeController.toggleTheme();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Logout Button
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: OutlinedButton(
                  onPressed: authController.logout,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Iconsax.logout,
                        color: AppColors.error,
                        size: 20,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Log Out',
                        style: AppTextStyle().boldTextStyle(
                          fontSize: 14.sp,
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: color, size: 20.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                title,
                style: AppTextStyle().mediumTextStyle(
                  fontSize: 13.sp,
                  color: Colors.white,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.darkTextDisabled,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, BettingRepository repo) {
    final nameCtrl = TextEditingController(text: repo.currentUser?.username);
    final phoneCtrl = TextEditingController(text: repo.currentUser?.phone);

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Edit Profile',
          style: AppTextStyle().boldTextStyle(
            fontSize: 16.sp,
            color: Colors.white,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(color: Colors.white70),
              ),
            ),
            TextField(
              controller: phoneCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Phone',
                labelStyle: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await repo.updateProfile(
                username: nameCtrl.text,
                phone: phoneCtrl.text,
              );
              Get.back();
              Get.snackbar(
                'Saved',
                'Profile details updated.',
                backgroundColor: AppColors.success,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.neonGreen,
            ),
            child: const Text('Save', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
