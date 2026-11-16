import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zozo99/core/utils/constants/icon_path.dart';
import 'package:zozo99/core/utils/constants/sizer.dart';
import 'package:zozo99/features/authentication/controllers/auth_controller.dart';
import 'package:zozo99/features/authentication/presentation/widgets/auth_demo_switcher.dart';
import 'package:zozo99/features/authentication/presentation/widgets/auth_glass_card.dart';
import 'package:zozo99/features/authentication/presentation/widgets/auth_header.dart';
import 'package:zozo99/features/authentication/presentation/widgets/auth_login_form.dart';
import 'package:zozo99/features/authentication/presentation/widgets/auth_register_form.dart';
import 'package:zozo99/features/authentication/presentation/widgets/auth_social_footer.dart';
import 'package:zozo99/features/authentication/presentation/widgets/auth_tab_selector.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AuthController controller = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080B10),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Splash Background Image
          Image.asset(
            IconPath.splashBg,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: const Color(0xFF080B10),
            ),
          ),

          // 2. Ambient Blurred Orbs for Glassmorphism Reflections
          Positioned(
            top: -60.h,
            left: -40.w,
            child: Container(
              width: 240.w,
              height: 240.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00B67A).withValues(alpha: 0.18),
              ),
            ),
          ),
          Positioned(
            bottom: 80.h,
            right: -60.w,
            child: Container(
              width: 260.w,
              height: 260.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFB800).withValues(alpha: 0.12),
              ),
            ),
          ),

          // 3. Dark Vignette Scrim
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF080B10).withValues(alpha: 0.75),
                  const Color(0xFF080B10).withValues(alpha: 0.88),
                  const Color(0xFF080B10).withValues(alpha: 0.98),
                ],
                stops: const [0.0, 0.45, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // 4. Scrollable Glassmorphic Authentication Content
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Brand & Logo Header
                  const AuthHeader(),
                  SizedBox(height: 16.h),

                  // Quick Demo Credentials Selector
                  AuthDemoSwitcher(controller: controller),
                  SizedBox(height: 14.h),

                  // Central Glassmorphic Form Card
                  AuthGlassCard(
                    padding: EdgeInsets.all(16.w),
                    borderRadius: 22.r,
                    child: Column(
                      children: [
                        // Glass Tab Selector (Sign In vs Register)
                        AuthTabSelector(tabController: _tabController),
                        SizedBox(height: 16.h),

                        // Form Switcher View
                        AnimatedBuilder(
                          animation: _tabController.animation ?? _tabController,
                          builder: (context, child) {
                            final index = _tabController.index;
                            return index == 0
                                ? AuthLoginForm(controller: controller)
                                : AuthRegisterForm(controller: controller);
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 18.h),

                  // Quick Access & Social Footer
                  const AuthSocialFooter(),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
