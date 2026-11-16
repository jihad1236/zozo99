import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zozo99/core/common/styles/global_text_style.dart';
import 'package:zozo99/core/utils/constants/colors.dart';
import 'package:zozo99/core/utils/constants/icon_path.dart';
import 'package:zozo99/core/utils/constants/sizer.dart';
import 'package:zozo99/features/authentication/controllers/auth_controller.dart';

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
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              // App Brand Header
              _buildBrandHeader(),
              SizedBox(height: 28.h),

              // Quick Demo Credentials Selector Card
              _buildDemoSelectorCard(),
              SizedBox(height: 24.h),

              // Tab Bar (Login vs Register)
              Container(
                decoration: BoxDecoration(
                  color: AppColors.darkSurfaceVariant,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: AppColors.darkBorder),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    gradient: AppColors.aviatorGradient,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.darkTextSecondary,
                  labelStyle: AppTextStyle().boldTextStyle(fontSize: 14.sp),
                  tabs: const [
                    Tab(text: 'Sign In'),
                    Tab(text: 'Register'),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Tab Views
              SizedBox(
                height: 380.h,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildLoginForm(),
                    _buildRegisterForm(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandHeader() {
    return Column(
      children: [
        Container(
          width: 76.w,
          height: 76.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.35),
                blurRadius: 24,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Image.asset(IconPath.appLogo, fit: BoxFit.contain),
        ),
        SizedBox(height: 12.h),
        Text(
          'ZOZO 99',
          style: AppTextStyle().boldTextStyle(
            fontSize: 28.sp,
            color: Colors.white,
            letterSpacing: 2.0,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Next-Gen Esports & Casino Experience',
          style: AppTextStyle().mediumTextStyle(
            fontSize: 13.sp,
            color: AppColors.darkTextSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDemoSelectorCard() {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Iconsax.flash_1, size: 18.sp, color: AppColors.gold),
              SizedBox(width: 8.w),
              Text(
                'QUICK DEMO ONE-TAP LOGIN',
                style: AppTextStyle().boldTextStyle(
                  fontSize: 11.sp,
                  color: AppColors.gold,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: _buildQuickLoginChip(
                  title: 'Customer',
                  subtitle: 'AlexRider (Gold)',
                  icon: Iconsax.user,
                  color: AppColors.neonCyan,
                  onTap: () {
                    controller.emailController.text = 'user@zozo99.com';
                    controller.passwordController.text = '123456';
                    controller.login();
                  },
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _buildQuickLoginChip(
                  title: 'Admin',
                  subtitle: 'ChiefAdmin (VIP)',
                  icon: Iconsax.security_user,
                  color: AppColors.aviatorRed,
                  onTap: () {
                    controller.emailController.text = 'admin@zozo99.com';
                    controller.passwordController.text = 'admin123';
                    controller.login();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLoginChip({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20.sp, color: color),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyle().boldTextStyle(fontSize: 12.sp, color: Colors.white),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyle().regularTextStyle(fontSize: 9.sp, color: AppColors.darkTextSecondary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        _buildTextField(
          controller: controller.emailController,
          hintText: 'Email address',
          prefixIcon: Iconsax.sms,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 14.h),
        Obx(
          () => _buildTextField(
            controller: controller.passwordController,
            hintText: 'Password',
            prefixIcon: Iconsax.lock,
            obscureText: !controller.isPasswordVisible.value,
            suffixIcon: IconButton(
              icon: Icon(
                controller.isPasswordVisible.value ? Iconsax.eye : Iconsax.eye_slash,
                color: AppColors.darkTextSecondary,
                size: 20.sp,
              ),
              onPressed: controller.togglePasswordVisibility,
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Obx(
          () => SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: controller.isLoading.value ? null : controller.login,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.aviatorRed,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                elevation: 4,
                shadowColor: AppColors.aviatorRed.withValues(alpha: 0.5),
              ),
              child: controller.isLoading.value
                  ? SizedBox(
                      height: 20.h,
                      width: 20.h,
                      child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text(
                      'Sign In to Zozo99',
                      style: AppTextStyle().boldTextStyle(fontSize: 15.sp, color: Colors.white),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      children: [
        _buildTextField(
          controller: controller.usernameController,
          hintText: 'Username',
          prefixIcon: Iconsax.user,
        ),
        SizedBox(height: 12.h),
        _buildTextField(
          controller: controller.emailController,
          hintText: 'Email address',
          prefixIcon: Iconsax.sms,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 12.h),
        _buildTextField(
          controller: controller.phoneController,
          hintText: 'Phone (+880...)',
          prefixIcon: Iconsax.call,
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 12.h),
        Obx(
          () => _buildTextField(
            controller: controller.passwordController,
            hintText: 'Create Password',
            prefixIcon: Iconsax.lock,
            obscureText: !controller.isPasswordVisible.value,
            suffixIcon: IconButton(
              icon: Icon(
                controller.isPasswordVisible.value ? Iconsax.eye : Iconsax.eye_slash,
                color: AppColors.darkTextSecondary,
                size: 20.sp,
              ),
              onPressed: controller.togglePasswordVisibility,
            ),
          ),
        ),
        SizedBox(height: 18.h),
        Obx(
          () => SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: controller.isLoading.value ? null : controller.register,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.neonGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                elevation: 4,
                shadowColor: AppColors.neonGreen.withValues(alpha: 0.4),
              ),
              child: controller.isLoading.value
                  ? SizedBox(
                      height: 20.h,
                      width: 20.h,
                      child: const CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                    )
                  : Text(
                      'Create Account (+500 Credits)',
                      style: AppTextStyle().boldTextStyle(fontSize: 15.sp, color: Colors.black),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: AppTextStyle().mediumTextStyle(fontSize: 14.sp, color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyle().regularTextStyle(fontSize: 14.sp, color: AppColors.darkTextDisabled),
          prefixIcon: Icon(prefixIcon, color: AppColors.darkTextSecondary, size: 20.sp),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        ),
      ),
    );
  }
}
