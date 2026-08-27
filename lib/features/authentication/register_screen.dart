import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/route_names.dart';
import '../../core/services/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/flow_cycle_theme_extension.dart';
import '../../shared/providers/app_scope.dart';
import '../../shared/widgets/brand/flow_cycle_brand_header.dart';
import '../../shared/widgets/buttons/app_icon_button.dart';
import '../../shared/widgets/buttons/primary_button.dart';
import '../../shared/widgets/inputs/primary_text_field.dart';
import 'widgets/auth_floral_background.dart';
import 'widgets/auth_terms_and_privacy_sheet.dart';
import 'widgets/password_strength_meter.dart';
import 'widgets/social_auth_buttons.dart';

/// Sign Up / Registration screen for FlowCycle with signature brand header,
/// interactive password strength meter, terms sheet, and device-adaptive social sign-up.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _agreeToTerms = false;
  bool _termsError = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
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

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _openTermsAndPrivacySheet({int tabIndex = 0}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AuthTermsAndPrivacySheet(
        initialTabIndex: tabIndex,
        onAccept: () {
          setState(() {
            _agreeToTerms = true;
            _termsError = false;
          });
        },
      ),
    );
  }

  Future<void> _handleCreateAccount() async {
    final isFormValid = _formKey.currentState?.validate() ?? false;

    setState(() {
      _termsError = !_agreeToTerms;
    });

    if (!isFormValid || !_agreeToTerms) {
      if (!_agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Please review and accept the Terms of Service & Privacy Policy.',
            ),
            backgroundColor: AppColors.warning,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

      final result = await AuthService.instance.registerWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text.trim(),
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (result.isSuccess) {
        try {
          final cycleController = AppScope.read(context);
          cycleController.updateUserProfile(
            name: _nameController.text.trim(),
          );
        } catch (_) {}

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Account created for ${_nameController.text.trim()}! Welcome to FlowCycle.',
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        );

        try {
          context.go(AppRoutes.onboardingPath);
        } catch (_) {}
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.errorMessage ?? 'Account creation failed.'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
  }

  Future<void> _handleSocialSignUp(String provider) async {
    setState(() => _isLoading = true);
    final result = provider.toLowerCase().contains('google')
        ? await AuthService.instance.signInWithGoogle()
        : await AuthService.instance.signInWithApple();

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.isSuccess) {
      try {
        final cycleController = AppScope.read(context);
        cycleController.updateUserProfile(
          name: result.user?.displayName ?? 'Amina',
        );
      } catch (_) {}

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registered via $provider! Welcome to FlowCycle.'),
          backgroundColor: const Color(0xFF7C5CE7),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      );

      try {
        context.go(AppRoutes.onboardingPath);
      } catch (_) {}
    }
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
                      // 1. Top Navigation Bar: Back Button + FlowCycle Brand Logo + Security Emblem
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
                          Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: theme.containerLight,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.auto_awesome,
                                color: theme.primary,
                                size: 18.0,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20.0),

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
                                        'Create Your Account',
                                        style: TextStyle(
                                          fontSize: 26.0,
                                          fontWeight: FontWeight.w900,
                                          color: theme.textPrimary,
                                          letterSpacing: -0.5,
                                          fontFamily: 'serif',
                                        ),
                                      ),
                                      const SizedBox(width: 6.0),
                                      const Text('✨', style: TextStyle(fontSize: 20.0)),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  'Start your personalized\ncycle & fertility journey',
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
                          Opacity(
                            opacity: 0.9,
                            child: Image.asset(
                              'assets/images/ttc_flower.png',
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

                      const SizedBox(height: 22.0),

                      // 3. Form Input Fields
                      PrimaryTextField(
                        label: 'Full Name',
                        hintText: 'Your name',
                        controller: _nameController,
                        validator: _validateName,
                        prefixIcon: Icons.person_outline_rounded,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(height: 14.0),

                      PrimaryTextField(
                        label: 'Email Address',
                        hintText: 'name@example.com',
                        controller: _emailController,
                        validator: _validateEmail,
                        prefixIcon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(height: 14.0),

                      PrimaryTextField(
                        label: 'Password',
                        hintText: 'At least 8 characters',
                        controller: _passwordController,
                        validator: _validatePassword,
                        isPassword: true,
                        prefixIcon: Icons.lock_outline_rounded,
                        textInputAction: TextInputAction.next,
                        onChanged: (val) => setState(() {}),
                      ),

                      const SizedBox(height: 8.0),

                      // Password strength meter
                      PasswordStrengthMeter(password: _passwordController.text),

                      const SizedBox(height: 14.0),

                      PrimaryTextField(
                        label: 'Confirm Password',
                        hintText: 'Re-enter your password',
                        controller: _confirmPasswordController,
                        validator: _validateConfirmPassword,
                        isPassword: true,
                        prefixIcon: Icons.lock_outline_rounded,
                        textInputAction: TextInputAction.done,
                      ),

                      const SizedBox(height: 16.0),

                      // 4. Terms of Service & Privacy Policy Checkbox
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 24.0,
                            height: 24.0,
                            child: Checkbox(
                              value: _agreeToTerms,
                              activeColor: theme.primary,
                              checkColor: Colors.white,
                              side: BorderSide(
                                color: _termsError
                                    ? AppColors.error
                                    : theme.chipBorder,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              onChanged: (bool? val) {
                                setState(() {
                                  _agreeToTerms = val ?? false;
                                  if (_agreeToTerms) _termsError = false;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  'I agree to the ',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: theme.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () =>
                                      _openTermsAndPrivacySheet(tabIndex: 0),
                                  child: Text(
                                    'Terms of Service',
                                    style: TextStyle(
                                      color: theme.primary,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                      fontSize: 12.5,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                                Text(
                                  ' and ',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: theme.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () =>
                                      _openTermsAndPrivacySheet(tabIndex: 1),
                                  child: Text(
                                    'Privacy Policy',
                                    style: TextStyle(
                                      color: theme.primary,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                      fontSize: 12.5,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      if (_termsError) ...[
                        const SizedBox(height: 6.0),
                        const Text(
                          'Please accept the Terms of Service to continue',
                          style: TextStyle(
                            color: AppColors.error,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],

                      const SizedBox(height: 20.0),

                      // 5. Primary CTA Button: Create Account →
                      PrimaryButton(
                        label: 'Create Account',
                        height: 52.0,
                        gradient: theme.primaryGradient,
                        trailingIcon: Icons.arrow_forward_rounded,
                        isLoading: _isLoading,
                        onPressed: _handleCreateAccount,
                      ),

                      const SizedBox(height: 20.0),

                      // 6. Device-Adaptive Social Sign-Up (Google for Android, Apple for iOS)
                      SocialAuthButtons(
                        actionPrefix: 'Sign up',
                        onGoogleSignIn: () => _handleSocialSignUp('Google'),
                        onAppleSignIn: () => _handleSocialSignUp('Apple'),
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

                      // 8. Bottom Navigation to Sign In
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: TextStyle(
                              color: theme.textSecondary,
                              fontSize: 13.5,
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          GestureDetector(
                            onTap: () {
                              context.pushReplacement(AppRoutes.loginPath);
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 4.0,
                              ),
                              child: Text(
                                'Sign In',
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
