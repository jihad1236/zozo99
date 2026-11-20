import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zozo99/core/models/betting_models.dart';
import 'package:zozo99/core/repositories/betting_repository.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/routes/app_routes.dart';

class AuthController extends GetxController {
  final BettingRepository _repository = Get.find<BettingRepository>();

  // State
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;

  // Form Controllers
  final emailController = TextEditingController(text: 'testuser1@gmail.com');
  final passwordController = TextEditingController(text: 'Test123456@');
  final usernameController = TextEditingController(text: 'testuser1');
  final phoneController = TextEditingController(text: '+880 1700 000001');

  bool get isLoggedIn => user.value != null;
  bool get isAdmin => user.value?.isAdmin ?? false;

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_repository.currentUserStream);
    user.value = _repository.currentUser;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter both email and password.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.warning.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      final loggedInUser = await _repository.login(email: email, password: password);
      user.value = loggedInUser;
      Get.offAllNamed(AppRoute.bottomNavScreen);
      Get.snackbar(
        'Welcome Back! 👋',
        'Signed in as ${loggedInUser.username}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Login Failed',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || username.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Required',
        'Please fill in all required fields.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.warning.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      final registeredUser = await _repository.register(
        email: email,
        phone: phone.isNotEmpty ? phone : '+8801700000000',
        username: username,
        password: password,
      );
      user.value = registeredUser;
      Get.offAllNamed(AppRoute.bottomNavScreen);
      Get.snackbar(
        'Welcome to Zozo99! 🚀',
        '500 Demo Credits added to your account!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Registration Failed',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> switchDemoAccount(UserRole role) async {
    await _repository.switchDemoRole(role);
    user.value = _repository.currentUser;
    Get.snackbar(
      'Account Switched',
      'Now viewing as ${role.name.toUpperCase()}: ${user.value?.username}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.info.withValues(alpha: 0.9),
      colorText: Colors.white,
    );
  }

  Future<void> logout() async {
    await _repository.logout();
    user.value = null;
    Get.offAllNamed(AppRoute.loginScreen);
  }
}
