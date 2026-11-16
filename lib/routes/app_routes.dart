import 'package:get/get.dart';
import 'package:zozo99/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:zozo99/features/authentication/presentation/screens/login_screen.dart';
import 'package:zozo99/features/bottom_nav/presentaion/UI/bottom_nav_screen.dart';
import 'package:zozo99/features/games/aviator/presentation/screens/aviator_screen.dart';
import 'package:zozo99/features/games/presentation/screens/game_history_screen.dart';
import 'package:zozo99/features/games/puzzle/presentation/screens/puzzle_screen.dart';
import 'package:zozo99/features/games/spin/presentation/screens/spin_screen.dart';
import 'package:zozo99/features/landing/presentation/screens/landing_screen.dart';
import 'package:zozo99/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:zozo99/features/splash/presentaion/UI/splash_screen.dart';
import 'package:zozo99/features/wallet/presentation/screens/deposit_screen.dart';
import 'package:zozo99/features/wallet/presentation/screens/wallet_screen.dart';
import 'package:zozo99/features/wallet/presentation/screens/withdrawal_screen.dart';

class AppRoute {
  static const String loginScreen = "/loginScreen";
  static const String splashScreen = "/splashScreen";
  static const String bottomNavScreen = "/bottomNavScreen";
  static const String walletScreen = "/walletScreen";
  static const String depositScreen = "/depositScreen";
  static const String withdrawalScreen = "/withdrawalScreen";
  static const String aviatorScreen = "/aviatorScreen";
  static const String puzzleScreen = "/puzzleScreen";
  static const String spinScreen = "/spinScreen";
  static const String gameHistoryScreen = "/gameHistoryScreen";
  static const String landingScreen = "/landingScreen";
  static const String adminDashboardScreen = "/adminDashboardScreen";
  static const String notificationsScreen = "/notificationsScreen";

  static String getLoginScreen() => loginScreen;
  static String getSplashScreen() => splashScreen;
  static String getBottomNavScreen() => bottomNavScreen;

  static List<GetPage> routes = [
    GetPage(name: loginScreen, page: () => const LoginScreen()),
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: bottomNavScreen, page: () => const BottomNavScreen()),
    GetPage(name: walletScreen, page: () => const WalletScreen()),
    GetPage(name: depositScreen, page: () => const DepositScreen()),
    GetPage(name: withdrawalScreen, page: () => const WithdrawalScreen()),
    GetPage(name: aviatorScreen, page: () => const AviatorScreen()),
    GetPage(name: puzzleScreen, page: () => const PuzzleScreen()),
    GetPage(name: spinScreen, page: () => const SpinScreen()),
    GetPage(name: gameHistoryScreen, page: () => const GameHistoryScreen()),
    GetPage(name: landingScreen, page: () => const LandingScreen()),
    GetPage(name: adminDashboardScreen, page: () => const AdminDashboardScreen()),
    GetPage(name: notificationsScreen, page: () => const NotificationsScreen()),
  ];
}
