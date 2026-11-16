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

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AuthController controller = Get.find<AuthController>();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.index != _currentIndex) {
      setState(() {
        _currentIndex = _tabController.index;
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
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
          // 1. Static Background isolated with RepaintBoundary (Zero Overdraw during typing)
          const _AuthBackground(),

          // 2. Interactive Authentication Form
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

                  // // Quick Demo Credentials Selector
                  // AuthDemoSwitcher(controller: controller),
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

                        // Optimized Form Switcher using IndexedStack (Zero Rebuilds on Swipes)
                        IndexedStack(
                          index: _currentIndex,
                          children: [
                            AuthLoginForm(controller: controller),
                            AuthRegisterForm(controller: controller),
                          ],
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

class _AuthBackground extends StatelessWidget {
  const _AuthBackground();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            IconPath.splashBg,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Container(color: const Color(0xFF080B10)),
          ),

          // Ambient Glow Orbs
          Positioned(
            top: -60.h,
            left: -40.w,
            child: Container(
              width: 240.w,
              height: 240.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00B67A).withValues(alpha: 0.16),
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
                color: const Color(0xFFFFB800).withValues(alpha: 0.10),
              ),
            ),
          ),

          // Vignette Scrim
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
        ],
      ),
    );
  }
}
