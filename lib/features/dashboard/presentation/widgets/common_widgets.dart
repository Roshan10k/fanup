import 'package:flutter/material.dart';
import 'package:fanup/app/themes/theme.dart';

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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.headerTitle),
          const SizedBox(height: 4),
          Text(subtitle, style: AppTextStyles.headerSubtitle),
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
}