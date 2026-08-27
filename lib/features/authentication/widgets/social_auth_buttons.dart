import 'package:flutter/material.dart';

/// Social authentication buttons for Google and Apple sign-in,
/// dynamically adapting to display the designated provider for the user's device
/// (Google for Android phones, Apple for iPhones, or dual-row on web/desktop).
class SocialAuthButtons extends StatelessWidget {
  final VoidCallback onGoogleSignIn;
  final VoidCallback onAppleSignIn;
  final String actionPrefix; // "Sign in" or "Sign up"
  final bool? forceBoth; // If true, displays both providers side-by-side

  const SocialAuthButtons({
    super.key,
    required this.onGoogleSignIn,
    required this.onAppleSignIn,
    this.actionPrefix = 'Sign in',
    this.forceBoth,
  });

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    final bool isAppleDevice = platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;
    final bool isAndroidDevice = platform == TargetPlatform.android;
    final bool showDual = forceBoth ?? (!isAppleDevice && !isAndroidDevice);

    return Column(
      children: [
        // "OR CONTINUE WITH" Divider
        Row(
          children: [
            const Expanded(
              child: Divider(color: Color(0xFFEFE8ED), thickness: 1),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                'OR CONTINUE WITH',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF9E95A8),
                  letterSpacing: 0.8,
                ),
              ),
            ),
            const Expanded(
              child: Divider(color: Color(0xFFEFE8ED), thickness: 1),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // Device Adaptive Action Card(s)
        if (showDual) ...[
          // Dual layout for Web / Desktop / Explicit Dual
          Row(
            children: [
              Expanded(
                child: _buildGoogleCard(
                  label: 'Google',
                  isCompact: true,
                  onTap: onGoogleSignIn,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildAppleCard(
                  label: 'Apple',
                  isCompact: true,
                  onTap: onAppleSignIn,
                ),
              ),
            ],
          ),
        ] else if (isAppleDevice) ...[
          // Apple for iPhone / iPad
          _buildAppleCard(
            label: 'Continue with Apple',
            isCompact: false,
            onTap: onAppleSignIn,
          ),
        ] else ...[
          // Google for Android Phones
          _buildGoogleCard(
            label: 'Continue with Google',
            isCompact: false,
            onTap: onGoogleSignIn,
          ),
        ],
      ],
    );
  }

  Widget _buildGoogleCard({
    required String label,
    required bool isCompact,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: const Color(0xFFEFE8F0), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1A3C).withValues(alpha: 0.03),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Authentic 4-color Google G mark
                const _GoogleGLogo(size: 20),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C243B),
                      letterSpacing: -0.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppleCard({
    required String label,
    required bool isCompact,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: const Color(0xFFEFE8F0), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1A3C).withValues(alpha: 0.03),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.apple,
                  size: 22,
                  color: Colors.black,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C243B),
                      letterSpacing: -0.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Vector 4-color Google G mark
class _GoogleGLogo extends StatelessWidget {
  final double size;

  const _GoogleGLogo({this.size = 20.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GoogleGLogoPainter(),
      ),
    );
  }
}

class _GoogleGLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double s = size.width;
    final center = Offset(s / 2, s / 2);
    final radius = s * 0.44;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.22
      ..isAntiAlias = true;

    // Blue arc
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -0.78,
      1.57,
      false,
      paint,
    );

    // Green arc
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0.79,
      1.57,
      false,
      paint,
    );

    // Yellow arc
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      2.36,
      1.57,
      false,
      paint,
    );

    // Red arc
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.93,
      1.57,
      false,
      paint,
    );

    // Blue crossbar
    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(center.dx - (s * 0.05), center.dy - (s * 0.11), s * 0.50, s * 0.22),
        Radius.circular(s * 0.04),
      ),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
