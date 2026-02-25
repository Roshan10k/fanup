import 'package:flutter/material.dart';

/// Responsive breakpoints and utilities for the FanUp app.
/// Use these to create adaptive layouts that work on all screen sizes.
class ResponsiveUtils {
  /// Screen width breakpoints
  static const double mobileBreakpoint = 360;
  static const double tabletBreakpoint = 600;
  static const double desktopBreakpoint = 1024;

  /// Check if the screen is a small mobile device
  static bool isSmallMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobileBreakpoint;

  /// Check if the screen is a regular mobile device
  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < tabletBreakpoint;

  /// Check if the screen is a tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= tabletBreakpoint && width < desktopBreakpoint;
  }

  /// Check if the screen is desktop-sized
  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= desktopBreakpoint;

  /// Get responsive value based on screen size
  static T responsiveValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context)) return desktop ?? tablet ?? mobile;
    if (isTablet(context)) return tablet ?? mobile;
    return mobile;
  }

  /// Get screen width
  static double screenWidth(BuildContext context) =>
      MediaQuery.sizeOf(context).width;

  /// Get screen height
  static double screenHeight(BuildContext context) =>
      MediaQuery.sizeOf(context).height;

  /// Get responsive padding based on screen size
  static EdgeInsets responsivePadding(BuildContext context) {
    if (isDesktop(context)) {
      return const EdgeInsets.symmetric(horizontal: 48, vertical: 24);
    }
    if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 20);
    }
    return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  }

  /// Get responsive horizontal padding value
  static double horizontalPadding(BuildContext context) {
    if (isDesktop(context)) return 48;
    if (isTablet(context)) return 32;
    return 16;
  }

  /// Get responsive font scale factor
  static double fontScale(BuildContext context) {
    final width = screenWidth(context);
    if (width < 320) return 0.85;
    if (width < 360) return 0.9;
    if (width < 400) return 0.95;
    if (width >= 600) return 1.1;
    return 1.0;
  }

  /// Get responsive icon size
  static double iconSize(BuildContext context, {double baseSize = 24}) {
    return baseSize * fontScale(context);
  }

  /// Get responsive spacing
  static double spacing(BuildContext context, {double baseSpacing = 16}) {
    if (isTablet(context)) return baseSpacing * 1.25;
    if (isDesktop(context)) return baseSpacing * 1.5;
    return baseSpacing;
  }

  /// Get text scale factor to prevent font from being too small
  static double textScaleFactor(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    // Clamp text scale to prevent extremes
    return mediaQuery.textScaler.scale(1.0).clamp(0.85, 1.3);
  }
}

/// Extension on BuildContext for easier responsive access
extension ResponsiveContext on BuildContext {
  bool get isSmallMobile => ResponsiveUtils.isSmallMobile(this);
  bool get isMobile => ResponsiveUtils.isMobile(this);
  bool get isTablet => ResponsiveUtils.isTablet(this);
  bool get isDesktop => ResponsiveUtils.isDesktop(this);
  double get screenWidth => ResponsiveUtils.screenWidth(this);
  double get screenHeight => ResponsiveUtils.screenHeight(this);
  double get fontScale => ResponsiveUtils.fontScale(this);
}

/// A widget that provides responsive layout capabilities
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, BoxConstraints constraints, bool isTablet) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= ResponsiveUtils.tabletBreakpoint;
        return builder(context, constraints, isTablet);
      },
    );
  }
}

/// A responsive text widget that prevents overflow
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow overflow;

  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
