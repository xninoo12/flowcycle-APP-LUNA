import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/route_names.dart';
import '../../core/services/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/flow_cycle_theme_extension.dart';
import '../../shared/widgets/brand/flow_cycle_brand_header.dart';
import '../../shared/widgets/buttons/app_icon_button.dart';
import '../../shared/widgets/buttons/app_text_button.dart';
import '../../shared/widgets/buttons/primary_button.dart';
import '../../shared/widgets/inputs/primary_text_field.dart';
import 'widgets/auth_floral_background.dart';
import 'widgets/auth_otp_verification_sheet.dart';

/// Forgot Password screen for FlowCycle with signature brand header, email validation,
/// OTP modal, and reassuring success state.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;
  bool _isSuccess = false;

  @override
  void dispose() {
    _emailController.dispose();
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

  Future<void> _handleSendResetLink() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      final result = await AuthService.instance.sendPasswordResetEmail(
        _emailController.text,
      );

      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _isSuccess = result.isSuccess;
      });

      if (!result.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.errorMessage ?? 'Failed to send reset link.'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _openOtpVerificationSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AuthOtpVerificationSheet(
        email: _emailController.text.trim(),
        onVerificationSuccess: () {
          if (mounted) {
            ScaffoldMessenger.maybeOf(context)?.showSnackBar(
              SnackBar(
                content: const Text(
                  'Code verified! Password reset link confirmed.',
                ),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            );

            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.loginPath);
            }
          }
        },
      ),
    );
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Navigation Bar with FlowCycle Branding
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
                              context.go(AppRoutes.loginPath);
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
                              Icons.lock_reset_rounded,
                              color: theme.primary,
                              size: 20.0,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24.0),

                    if (_isSuccess)
                      _buildSuccessView(theme)
                    else
                      _buildRequestView(theme),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestView(FlowCycleThemeExtension theme) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Botanical Flower
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
                            'Forgot Password?',
                            style: TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.w900,
                              color: theme.textPrimary,
                              letterSpacing: -0.5,
                              fontFamily: 'serif',
                            ),
                          ),
                          const SizedBox(width: 6.0),
                          const Text('🔒', style: TextStyle(fontSize: 20.0)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Enter your email address to receive\na secure reset link & verification code',
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

          const SizedBox(height: 28.0),

          // Email Input
          PrimaryTextField(
            label: 'Email Address',
            hintText: 'name@example.com',
            controller: _emailController,
            validator: _validateEmail,
            prefixIcon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
          ),

          const SizedBox(height: 24.0),

          // Send Reset Link Button
          PrimaryButton(
            label: 'Send Reset Link',
            height: 52.0,
            gradient: theme.primaryGradient,
            trailingIcon: Icons.send_rounded,
            isLoading: _isLoading,
            onPressed: _handleSendResetLink,
          ),

          const SizedBox(height: 16.0),

          // Quick Action: I have a code
          Center(
            child: AppTextButton(
              label: 'Already have a verification code? Enter here',
              color: theme.primary,
              onPressed: () {
                if (_emailController.text.trim().isNotEmpty) {
                  _openOtpVerificationSheet();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter your email address first.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
          ),

          const SizedBox(height: 24.0),

          // Back to Sign In
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Remember your password?',
                style: TextStyle(
                  color: theme.textSecondary,
                  fontSize: 13.5,
                ),
              ),
              const SizedBox(width: 4.0),
              GestureDetector(
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(AppRoutes.loginPath);
                  }
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
        ],
      ),
    );
  }

  Widget _buildSuccessView(FlowCycleThemeExtension theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20.0),

        // Success Icon with Glow
        Container(
          width: 80.0,
          height: 80.0,
          decoration: BoxDecoration(
            color: theme.containerLight,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: theme.primary.withValues(alpha: 0.2),
                blurRadius: 16.0,
                spreadRadius: 2.0,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.mark_email_read_rounded,
              size: 40.0,
              color: theme.primary,
            ),
          ),
        ),

        const SizedBox(height: 24.0),

        Text(
          'Check Your Inbox',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w900,
            color: theme.textPrimary,
            fontFamily: 'serif',
          ),
        ),

        const SizedBox(height: 8.0),

        Text(
          'We sent a password reset link and 4-digit verification code to:',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.0,
            color: theme.textSecondary,
            height: 1.4,
          ),
        ),

        const SizedBox(height: 6.0),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: theme.cardBackground,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: theme.cardBorder),
          ),
          child: Text(
            _emailController.text,
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w700,
              color: theme.textPrimary,
            ),
          ),
        ),

        const SizedBox(height: 24.0),

        // Enter Code Modal Button
        PrimaryButton(
          label: 'Enter 4-Digit Code',
          height: 52.0,
          gradient: theme.primaryGradient,
          trailingIcon: Icons.lock_open_rounded,
          onPressed: _openOtpVerificationSheet,
        ),

        const SizedBox(height: 14.0),

        // Resend option
        AppTextButton(
          label: 'Didn\'t receive email? Resend',
          color: theme.primary,
          onPressed: _handleSendResetLink,
        ),

        const SizedBox(height: 16.0),

        // Return to Login
        GestureDetector(
          onTap: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.loginPath);
            }
          },
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_back_rounded,
                  size: 16.0,
                  color: theme.textSecondary,
                ),
                const SizedBox(width: 4.0),
                Text(
                  'Back to Sign In',
                  style: TextStyle(
                    color: theme.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
