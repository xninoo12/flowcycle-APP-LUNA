import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/flow_cycle_theme_extension.dart';
import '../../core/theme/phase_ambient_aura.dart';
import '../../shared/providers/app_scope.dart';
import '../../shared/widgets/responsive_layout.dart';

/// Main Shell widget hosting the Docked Bottom Navigation Bar.
///
/// Features:
/// 1. Docked Layout with a smooth recessed Bézier-curved cradle notch.
/// 2. Central 52dp "Log" action button with theme/phase-reactive glowing gradient.
/// 3. 4 Symmetrical flanking tabs (Home, Calendar | Insights, AI Companion).
/// 4. Responsive horizontal layout ensuring the center button stays proportional.
class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    // Reactive Theme & Cycle Phase Aura integration
    final controller = AppScope.of(context);
    final theme = context.flowTheme;
    final cycleState = controller.calculateCurrentCycleState();
    final phase = cycleState.phase;
    final auraColors = PhaseAmbientAura.getAuraColors(phase);
    final primaryAura = theme.isDark
        ? theme.accent
        : PhaseAmbientAura.getPrimaryAuraColor(phase);

    const double barHeight = 64.0;
    final double totalHeight = barHeight + bottomPadding;

    return Scaffold(
      body: ResponsiveLayout(
        maxWidth: 640.0,
        child: navigationShell,
      ),
      bottomNavigationBar: Container(
        height: totalHeight,
        color: Colors.transparent,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            // 1. Custom-painted Docked Bar with recessed cradle cutout
            Positioned.fill(
              child: CustomPaint(
                painter: DockedNotchPainter(
                  backgroundColor: theme.cardBackground,
                  borderColor: theme.cardBorder,
                  shadowColor: theme.isDark
                      ? const Color(0x40000000)
                      : const Color(0x12000000),
                ),
              ),
            ),

            // 2. Flanking Navigation Tabs Row
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: barHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Row(
                  children: [
                    // Left Tab 0: Home
                    Expanded(
                      child: _buildNavItem(
                        index: 0,
                        currentIndex: currentIndex,
                        icon: Icons.home_outlined,
                        selectedIcon: Icons.home_rounded,
                        label: 'Home',
                        activeColor: primaryAura,
                        inactiveColor: theme.textSecondary,
                      ),
                    ),

                    // Left Tab 1: Calendar
                    Expanded(
                      child: _buildNavItem(
                        index: 1,
                        currentIndex: currentIndex,
                        icon: Icons.access_time_rounded,
                        selectedIcon: Icons.access_time_filled_rounded,
                        label: 'Calendar',
                        activeColor: primaryAura,
                        inactiveColor: theme.textSecondary,
                      ),
                    ),

                    // Center Spacer for Docked Log Action Button (56dp target)
                    const SizedBox(width: 68.0),

                    // Right Tab 3: Insights
                    Expanded(
                      child: _buildNavItem(
                        index: 3,
                        currentIndex: currentIndex,
                        icon: Icons.bar_chart_outlined,
                        selectedIcon: Icons.bar_chart_rounded,
                        label: 'Insights',
                        activeColor: primaryAura,
                        inactiveColor: theme.textSecondary,
                      ),
                    ),

                    // Right Tab 4: AI Companion
                    Expanded(
                      child: _buildNavItem(
                        index: 4,
                        currentIndex: currentIndex,
                        icon: Icons.auto_awesome_outlined,
                        selectedIcon: Icons.auto_awesome,
                        label: 'AI Companion',
                        activeColor: primaryAura,
                        inactiveColor: theme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. Central Docked "Log" Action Button
            Positioned(
              top: 4.0,
              child: _buildDockedLogButton(
                index: 2,
                currentIndex: currentIndex,
                themeGradient: theme.primaryGradient,
                auraGlow: theme.auraGlow,
                primaryAura: primaryAura,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Individual flanking navigation item with smooth ink ripple and semantic labels
  Widget _buildNavItem({
    required int index,
    required int currentIndex,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required Color activeColor,
    required Color inactiveColor,
  }) {
    final bool isSelected = index == currentIndex;

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: () => _onDestinationSelected(index),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? selectedIcon : icon,
                size: 22.0,
                color: isSelected ? activeColor : inactiveColor,
              ),
              const SizedBox(height: 3.0),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? activeColor : inactiveColor,
                  letterSpacing: -0.1,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Central docked action button with theme-reactive glowing gradient (52dp diameter)
  Widget _buildDockedLogButton({
    required int index,
    required int currentIndex,
    required LinearGradient themeGradient,
    required Color auraGlow,
    required Color primaryAura,
  }) {
    return Semantics(
      button: true,
      label: 'Log',
      child: GestureDetector(
        onTap: () => _onDestinationSelected(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 52.0,
          height: 52.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: themeGradient,
            boxShadow: [
              // Soft diffuse ambient aura matching active theme
              BoxShadow(
                color: auraGlow.withValues(alpha: 0.42),
                blurRadius: 14.0,
                spreadRadius: 1.5,
                offset: const Offset(0, 3),
              ),
              BoxShadow(
                color: auraGlow.withValues(alpha: 0.28),
                blurRadius: 6.0,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 22.0,
              ),
              SizedBox(height: 1.0),
              Text(
                'Log',
                style: TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.2,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom painter for the Docked Bottom Navigation Bar with a smooth recessed Bézier cradle notch.
class DockedNotchPainter extends CustomPainter {
  final Color backgroundColor;
  final Color borderColor;
  final Color shadowColor;

  const DockedNotchPainter({
    this.backgroundColor = Colors.white,
    this.borderColor = const Color(0xFFEFE9F3),
    this.shadowColor = const Color(0x12000000),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double hostWidth = size.width;
    final double hostHeight = size.height;
    final double centerX = hostWidth / 2.0;

    // Notch geometry dimensions matching 52dp docked button + 8dp breathing clearance
    const double notchRadius = 32.0;
    const double notchDepth = 22.0;
    const double cornerRadius = 14.0;

    final Path path = Path();
    path.moveTo(0, 0);

    // Left straight edge to start of cradle notch
    final double notchLeft = centerX - notchRadius - cornerRadius;
    path.lineTo(notchLeft, 0);

    // Left entrance convex corner
    path.quadraticBezierTo(
      centerX - notchRadius,
      0,
      centerX - notchRadius + 4.0,
      notchDepth * 0.35,
    );

    // Central concave cradle dip
    path.quadraticBezierTo(
      centerX,
      notchDepth * 1.35,
      centerX + notchRadius - 4.0,
      notchDepth * 0.35,
    );

    // Right exit convex corner
    final double notchRight = centerX + notchRadius + cornerRadius;
    path.quadraticBezierTo(
      centerX + notchRadius,
      0,
      notchRight,
      0,
    );

    // Right straight edge to bottom-right
    path.lineTo(hostWidth, 0);
    path.lineTo(hostWidth, hostHeight);
    path.lineTo(0, hostHeight);
    path.close();

    // 1. Draw subtle top elevation shadow
    final Paint shadowPaint = Paint()
      ..color = shadowColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 8.0);
    canvas.drawPath(path, shadowPaint);

    // 2. Draw solid surface background
    final Paint fillPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // 3. Draw clean top contour border stroke
    final Path borderPath = Path();
    borderPath.moveTo(0, 0);
    borderPath.lineTo(notchLeft, 0);
    borderPath.quadraticBezierTo(
      centerX - notchRadius,
      0,
      centerX - notchRadius + 4.0,
      notchDepth * 0.35,
    );
    borderPath.quadraticBezierTo(
      centerX,
      notchDepth * 1.35,
      centerX + notchRadius - 4.0,
      notchDepth * 0.35,
    );
    borderPath.quadraticBezierTo(
      centerX + notchRadius,
      0,
      notchRight,
      0,
    );
    borderPath.lineTo(hostWidth, 0);

    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(borderPath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant DockedNotchPainter oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.shadowColor != shadowColor;
  }
}
