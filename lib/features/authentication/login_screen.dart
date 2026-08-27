import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/route_names.dart';
import '../../core/services/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/flow_cycle_theme_extension.dart';
import '../../shared/widgets/brand/flow_cycle_brand_header.dart';
import '../../shared/widgets/buttons/app_icon_button.dart';
import '../../shared/widgets/buttons/primary_button.dart';
import '../../shared/widgets/inputs/primary_text_field.dart';
import 'widgets/auth_floral_background.dart';
import 'widgets/social_auth_buttons.dart';

/// Sign In screen for FlowCycle with signature brand aesthetics, full validation,
/// password toggle, guest fast-track, and device-adaptive social auth.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  Future<void> _handleSignIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      final result = await AuthService.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (result.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Welcome back, ${result.user?.displayName ?? "User"}! Authentication successful.',
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        );

        try {
          context.go(AppRoutes.homePath);
        } catch (_) {}
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.errorMessage ?? 'Authentication failed.'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _handleSocialSignIn(String provider) async {
    setState(() => _isLoading = true);

    final result = await AuthService.instance.signInWithSocialProvider(provider);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Signed in via $provider! Welcome to FlowCycle.'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      try {
        context.go(AppRoutes.homePath);
      } catch (_) {}
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.errorMessage ?? 'Social sign-in failed.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _handleForgotPassword() {
    context.push(AppRoutes.forgotPasswordPath);
  }

  void _handleGuestExplore() {
    try {
      context.go(AppRoutes.onboardingPath);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.flowTheme;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: AuthFloralBackground(
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Top Navigation Bar: Symmetrical Back Button + FlowCycle Brand Logo
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppIconButton(
                            icon: Icons.arrow_back_ios_new_rounded,
                            iconSize: 18.0,
                            onPressed: () {
                              if (context.canPop()) {
                                context.pop();
                              } else {
                                context.go(AppRoutes.splashPath);
                              }
                            },
                          ),
                          const FlowCycleBrandHeader(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            size: BrandHeaderSize.standard,
                            showTagline: true,
                          ),
                          // Symmetrical right placeholder / security badge
                          Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: theme.containerLight,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.shield_outlined,
                                color: theme.primary,
                                size: 18.0,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24.0),

                      // 2. Screen Title & Subtitle with Hero Visual
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Text(
                                        'Welcome Back',
                                        style: TextStyle(
                                          fontSize: 26.0,
                                          fontWeight: FontWeight.w900,
                                          color: theme.textPrimary,
                                          letterSpacing: -0.5,
                                          fontFamily: 'serif',
                                        ),
                                      ),
                                      const SizedBox(width: 6.0),
                                      const Text('💗', style: TextStyle(fontSize: 20.0)),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  'Sign in to continue your personalized\ncycle & fertility journey',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: theme.textSecondary,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Botanical Flower Emblem
                          Opacity(
                            opacity: 0.9,
                            child: Image.asset(
                              'assets/images/cycle_wellness_flower.png',
                              width: 58.0,
                              height: 58.0,
                              fit: BoxFit.contain,
                              errorBuilder: (_, _, _) => const Text(
                                '🌸',
                                style: TextStyle(fontSize: 34.0),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24.0),

                      // 3. Form Input Fields
                      PrimaryTextField(
                        label: 'Email Address',
                        hintText: 'name@example.com',
                        controller: _emailController,
                        validator: _validateEmail,
                        prefixIcon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(height: 16.0),

                      PrimaryTextField(
                        label: 'Password',
                        hintText: 'Enter your password',
                        controller: _passwordController,
                        validator: _validatePassword,
                        isPassword: true,
                        prefixIcon: Icons.lock_outline_rounded,
                        textInputAction: TextInputAction.done,
                      ),

                      const SizedBox(height: 10.0),

                      // 4. Forgot Password Link
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: _handleForgotPassword,
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 4.0,
                            ),
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: theme.primary,
                                fontSize: 13.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20.0),

                      // 5. Primary CTA Button: Sign In →
                      PrimaryButton(
                        label: 'Sign In',
                        height: 52.0,
                        gradient: theme.primaryGradient,
                        trailingIcon: Icons.arrow_forward_rounded,
                        isLoading: _isLoading,
                        onPressed: _handleSignIn,
                      ),

                      const SizedBox(height: 22.0),

                      // 6. Device-Adaptive Social Sign-In (Google for Android, Apple for iOS)
                      SocialAuthButtons(
                        actionPrefix: 'Sign in',
                        onGoogleSignIn: () => _handleSocialSignIn('Google'),
                        onAppleSignIn: () => _handleSocialSignIn('Apple'),
                      ),

                      const SizedBox(height: 16.0),

                      // 7. Privacy Reassurance Footer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock_rounded,
                            size: 13.0,
                            color: theme.primary.withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 5.0),
                          Text(
                            'Your data is private and secure.',
                            style: TextStyle(
                              color: theme.textSecondary,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14.0),

                      // 8. Bottom Navigation to Register & Guest
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account?',
                            style: TextStyle(
                              color: theme.textSecondary,
                              fontSize: 13.5,
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          GestureDetector(
                            onTap: () {
                              context.pushReplacement(AppRoutes.registerPath);
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 4.0,
                              ),
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: theme.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10.0),

                      Center(
                        child: GestureDetector(
                          onTap: _handleGuestExplore,
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 8.0,
                            ),
                            child: Text(
                              'Explore App as Guest',
                              style: TextStyle(
                                color: theme.secondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 13.0,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
