import 'package:get/get.dart';
import 'package:zozo99/core/repositories/betting_repository.dart';
import 'package:zozo99/core/repositories/mock_betting_repository.dart';
import 'package:zozo99/core/services/network/internet_service.dart';
import 'package:zozo99/features/authentication/controllers/auth_controller.dart';
import 'package:zozo99/features/splash/controllers/splash_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put<InternetService>(InternetService(), permanent: true);
    Get.put<BettingRepository>(MockBettingRepository(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<SplashController>(SplashController(), permanent: true);
  }
}
