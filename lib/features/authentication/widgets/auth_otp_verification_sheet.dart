import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_text_styles.dart';

/// Modal sheet for entering a 4-digit verification code with countdown resend timer.
class AuthOtpVerificationSheet extends StatefulWidget {
  final String email;
  final VoidCallback onVerificationSuccess;

  const AuthOtpVerificationSheet({
    super.key,
    required this.email,
    required this.onVerificationSuccess,
  });

  @override
  State<AuthOtpVerificationSheet> createState() =>
      _AuthOtpVerificationSheetState();
}

class _AuthOtpVerificationSheetState extends State<AuthOtpVerificationSheet> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  int _resendCountdown = 45;
  Timer? _countdownTimer;
  bool _isVerifying = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    setState(() {
      _resendCountdown = 45;
    });
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_resendCountdown > 0) {
        setState(() => _resendCountdown--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _otpCode => _controllers.map((c) => c.text).join();

  void _handleVerify() {
    if (_otpCode.length < 4) {
      setState(() {
        _errorMessage = 'Please enter the complete 4-digit code';
      });
      return;
    }

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    // Simulate verification
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _isVerifying = false);
      Navigator.pop(context);
      widget.onVerificationSuccess();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.70,
      decoration: const BoxDecoration(
        color: Color(0xFFFAF8FC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          children: [
            // Handle pill
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFDDD6FE),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            // Icon
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: Color(0xFFF3EDFA),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mark_email_read_rounded,
                color: Color(0xFF7C5CE7),
                size: 26,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Enter Verification Code',
              style: AppTextStyles.subtitle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF1E1A3C),
              ),
            ),

            const SizedBox(height: 4),

            Text(
              'We sent a 4-digit code to\n${widget.email}',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                fontSize: 12,
                color: const Color(0xFF6B627A),
                height: 1.35,
              ),
            ),

            const SizedBox(height: 24),

            // 4 OTP Boxes
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  width: 54,
                  height: 58,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppRadius.medium,
                    border: Border.all(
                      color: _controllers[index].text.isNotEmpty
                          ? const Color(0xFF7C5CE7)
                          : const Color(0xFFE5E5EB),
                      width: _controllers[index].text.isNotEmpty ? 2.0 : 1.0,
                    ),
                  ),
                  child: Center(
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E1A3C),
                      ),
                      decoration: const InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                      ),
                      onChanged: (val) {
                        if (val.isNotEmpty && index < 3) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (val.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                        setState(() {});
                      },
                    ),
                  ),
                );
              }),
            ),

            if (_errorMessage != null) ...[
              const SizedBox(height: 10),
              Text(
                _errorMessage!,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFEF4444),
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Resend Countdown
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Didn\'t receive code? ',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                GestureDetector(
                  onTap: _resendCountdown == 0 ? _startCountdown : null,
                  child: Text(
                    _resendCountdown > 0
                        ? 'Resend in ${_resendCountdown}s'
                        : 'Resend Now',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _resendCountdown > 0
                          ? AppColors.textTertiary
                          : const Color(0xFF7C5CE7),
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Verify Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isVerifying ? null : _handleVerify,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C5CE7),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isVerifying
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text(
                        'Verify & Proceed',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
