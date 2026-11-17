import 'package:get/get.dart';
import 'package:zozo99/core/repositories/betting_repository.dart';
import 'package:zozo99/core/repositories/mock_betting_repository.dart';
import 'package:zozo99/core/services/network/internet_service.dart';
import 'package:zozo99/features/admin/controllers/admin_controller.dart';
import 'package:zozo99/features/authentication/controllers/auth_controller.dart';
import 'package:zozo99/features/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:zozo99/features/games/aviator/controllers/aviator_controller.dart';
import 'package:zozo99/features/games/puzzle/controllers/puzzle_controller.dart';
import 'package:zozo99/features/games/spin/controllers/spin_controller.dart';
import 'package:zozo99/features/landing/controllers/landing_controller.dart';
import 'package:zozo99/features/notifications/controllers/notifications_controller.dart';
import 'package:zozo99/features/points/controllers/points_controller.dart';
import 'package:zozo99/features/splash/controllers/splash_controller.dart';
import 'package:zozo99/features/wallet/controllers/wallet_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put<InternetService>(InternetService(), permanent: true);
    Get.put<BettingRepository>(MockBettingRepository(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<SplashController>(SplashController(), permanent: true);
    Get.lazyPut<BottomNavController>(() => BottomNavController(), fenix: true);
    Get.lazyPut<LandingController>(() => LandingController(), fenix: true);
    Get.lazyPut<WalletController>(() => WalletController(), fenix: true);
    Get.lazyPut<PointsController>(() => PointsController(), fenix: true);
    Get.lazyPut<NotificationsController>(() => NotificationsController(), fenix: true);
    Get.lazyPut<AdminController>(() => AdminController(), fenix: true);
    Get.lazyPut<SpinController>(() => SpinController(), fenix: true);
    Get.lazyPut<PuzzleController>(() => PuzzleController(), fenix: true);
    Get.lazyPut<AviatorController>(() => AviatorController(), fenix: true);
  }
}
