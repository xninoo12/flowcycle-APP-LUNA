import 'package:flutter/material.dart';
import '../../../core/theme/flow_cycle_theme_extension.dart';

enum BrandHeaderSize {
  compact,
  standard,
  large,
}

/// Reusable FlowCycle Brand Header displaying the signature brand logo (`🌸 FlowCycle 🍃`)
/// and the inspirational tagline (`Know your body. Live better. ✨`).
///
/// Fully dynamic with multi-theme support (`context.flowTheme`), flexible alignments (start/center),
/// and configurable size variants (compact/standard/large).
class FlowCycleBrandHeader extends StatelessWidget {
  final CrossAxisAlignment crossAxisAlignment;
  final BrandHeaderSize size;
  final bool showTagline;
  final Color? titleColor;
  final Color? subtitleColor;
  final Color? accentColor;

  const FlowCycleBrandHeader({
    super.key,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.size = BrandHeaderSize.standard,
    this.showTagline = true,
    this.titleColor,
    this.subtitleColor,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.flowTheme;

    final double flowerSize;
    final double titleFontSize;
    final double leafSize;
    final double taglineFontSize;
    final double liveBetterFontSize;
    final double sparkleSize;
    final double verticalSpacing;

    switch (size) {
      case BrandHeaderSize.compact:
        flowerSize = 15.0;
        titleFontSize = 18.0;
        leafSize = 11.0;
        taglineFontSize = 9.5;
        liveBetterFontSize = 10.0;
        sparkleSize = 8.5;
        verticalSpacing = 1.0;
        break;
      case BrandHeaderSize.standard:
        flowerSize = 18.0;
        titleFontSize = 22.0;
        leafSize = 13.0;
        taglineFontSize = 10.5;
        liveBetterFontSize = 11.0;
        sparkleSize = 10.0;
        verticalSpacing = 2.0;
        break;
      case BrandHeaderSize.large:
        flowerSize = 22.0;
        titleFontSize = 26.0;
        leafSize = 15.0;
        taglineFontSize = 12.0;
        liveBetterFontSize = 12.5;
        sparkleSize = 11.5;
        verticalSpacing = 3.0;
        break;
    }

    final effectiveTitleColor = titleColor ?? theme.textPrimary;
    final effectiveSubtitleColor = subtitleColor ?? theme.textSecondary;
    final effectiveAccentColor = accentColor ?? theme.primary;

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Brand Logo Row: 🌸 FlowCycle 🍃
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('🌸', style: TextStyle(fontSize: flowerSize)),
            const SizedBox(width: 4.0),
            Text(
              'FlowCycle',
              style: TextStyle(
                fontFamily: 'serif',
                fontWeight: FontWeight.w900,
                fontSize: titleFontSize,
                color: effectiveTitleColor,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(width: 3.0),
            Text('🍃', style: TextStyle(fontSize: leafSize)),
          ],
        ),

        if (showTagline) ...[
          SizedBox(height: verticalSpacing),
          // 2. Tagline Row: Know your body. Live better. ✨
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Know your body. ',
                style: TextStyle(
                  fontSize: taglineFontSize,
                  color: effectiveSubtitleColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Live better.',
                style: TextStyle(
                  fontSize: liveBetterFontSize,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  color: effectiveAccentColor,
                ),
              ),
              const SizedBox(width: 2.0),
              Text('✨', style: TextStyle(fontSize: sparkleSize)),
            ],
          ),
        ],
      ],
    );
  }
}
