import 'package:flutter/material.dart';
import 'package:fanup/app/themes/theme.dart';
import 'package:fanup/core/utils/responsive_utils.dart';

/// Reusable Screen Header
class ScreenHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const ScreenHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final fontScale = context.fontScale;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 20 * fontScale,
        vertical: 16 * fontScale,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.headerTitle.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 20 * fontScale,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTextStyles.headerSubtitle.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
              fontSize: 13 * fontScale,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}

/// Consistent Spacing Values
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 40.0;

  /// Get responsive spacing value based on context
  static double responsive(BuildContext context, double base) {
    return base * context.fontScale;
  }
}