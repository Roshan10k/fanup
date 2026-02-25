import 'package:fanup/app/themes/theme.dart';
import 'package:flutter/material.dart';
import 'onboarding_data.dart';

class OnboardingSlide extends StatelessWidget {
  final OnboardingSlideData data;

  const OnboardingSlide({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final secondary = onSurface.withAlpha(179);
    final circleFill = theme.colorScheme.surfaceContainerHighest;
    final iconColor = theme.colorScheme.primary;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTablet = constraints.maxWidth >= 600;

        // Responsive sizes
        final double iconContainerSize = isTablet ? 250 : constraints.maxWidth * 0.5;
        final double iconSize = isTablet ? 120 : constraints.maxWidth * 0.25;
        final double spacingLarge = isTablet ? 40 : 30;
        final double spacingMedium = isTablet ? 20 : 12;
        final double titleFontSize = isTablet ? 28 : 24;
        final double descriptionFontSize = isTablet ? 18 : 16;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Container
            Container(
              height: iconContainerSize,
              width: iconContainerSize,
              decoration: BoxDecoration(
                color: circleFill,
                shape: BoxShape.circle,
              ),
              child: Icon(
                data.icon,
                size: iconSize,
                color: iconColor,
              ),
            ),

            SizedBox(height: spacingLarge),

            // Title
            Text(
              data.title,
              style: AppTextStyles.poppinsBold24.copyWith(
                fontSize: titleFontSize,
                color: onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: spacingMedium),

            // Description
            Text(
              data.description,
              style: AppTextStyles.poppinsRegular16.copyWith(
                color: secondary,
                fontSize: descriptionFontSize,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }
}
