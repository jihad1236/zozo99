import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zozo99/core/common/styles/global_text_style.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/core/utils/constants/sizer.dart';
import 'package:zozo99/features/notifications/controllers/notifications_controller.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<NotificationsController>()
        ? Get.find<NotificationsController>()
        : Get.put(NotificationsController());

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        title: Text(
          'Notifications',
          style: AppTextStyle().boldTextStyle(fontSize: 18.sp, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.trash, color: AppColors.darkTextSecondary),
            onPressed: controller.clearAll,
          ),
        ],
      ),
      body: ResponsiveLayout(
        child: Obx(() {
          final list = controller.notifications;
          if (list.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Iconsax.notification_bing, size: 48.sp, color: AppColors.darkTextDisabled),
                  SizedBox(height: 12.h),
                  Text(
                    'No notifications right now',
                    style: AppTextStyle().mediumTextStyle(fontSize: 14.sp, color: AppColors.darkTextSecondary),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            itemCount: list.length,
            separatorBuilder: (_, _) => SizedBox(height: 10.h),
            itemBuilder: (context, index) {
              final n = list[index];
              return RepaintBoundary(
                child: InkWell(
                  onTap: () => controller.markAsRead(n.id),
                  borderRadius: BorderRadius.circular(14.r),
                  child: Container(
                    padding: EdgeInsets.all(14.r),
                    decoration: BoxDecoration(
                      color: n.isRead ? AppColors.darkSurface : const Color(0xFF1F2433),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: n.isRead ? AppColors.darkBorder : AppColors.accent.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: _getNotificationColor(n.type).withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getNotificationIcon(n.type),
                            color: _getNotificationColor(n.type),
                            size: 20.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                n.title,
                                style: AppTextStyle().boldTextStyle(fontSize: 13.sp, color: Colors.white),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                n.message,
                                style: AppTextStyle().regularTextStyle(fontSize: 11.sp, color: AppColors.darkTextSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Color _getNotificationColor(String type) {
    switch (type.toUpperCase()) {
      case 'WALLET':
        return AppColors.neonGreen;
      case 'TIER':
        return AppColors.gold;
      case 'BONUS':
        return AppColors.accent;
      default:
        return AppColors.info;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type.toUpperCase()) {
      case 'WALLET':
        return Iconsax.wallet_3;
      case 'TIER':
        return Iconsax.crown;
      case 'BONUS':
        return Iconsax.gift;
      default:
        return Iconsax.info_circle;
    }
  }
}
