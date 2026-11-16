import 'package:get/get.dart';
import 'package:zozo99/core/models/betting_models.dart';
import 'package:zozo99/core/repositories/betting_repository.dart';

class NotificationsController extends GetxController {
  final BettingRepository _repository = Get.find<BettingRepository>();

  final RxList<AppNotificationModel> notifications = <AppNotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    notifications.bindStream(_repository.notificationsStream);
  }

  Future<void> markAsRead(String id) async {
    await _repository.markNotificationAsRead(id);
  }

  Future<void> clearAll() async {
    await _repository.clearAllNotifications();
  }
}
