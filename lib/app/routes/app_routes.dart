import 'package:flutter/material.dart';

/// Custom fade-slide page route transition
class _FadeSlideRoute<T> extends PageRouteBuilder<T> {
  _FadeSlideRoute({required WidgetBuilder builder})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionDuration: const Duration(milliseconds: 350),
          reverseTransitionDuration: const Duration(milliseconds: 250),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved =
                CurvedAnimation(parent: animation, curve: Curves.easeInOut);
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.05, 0),
                  end: Offset.zero,
                ).animate(curved),
                child: child,
              ),
            );
          },
        );
}

/// Simple navigation utility class
class AppRoutes {
  AppRoutes._();

  /// Push a new route onto the stack (fade + slide)
  static Future<T?> push<T>(BuildContext context, Widget page) {
    return Navigator.push<T>(
      context,
      _FadeSlideRoute<T>(builder: (_) => page),
    );
  }

  /// Replace current route with a new one (fade + slide)
  static void pushReplacement(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      _FadeSlideRoute(builder: (_) => page),
    );
  }

  /// Push a new route and remove all previous routes (fade + slide)
  static void pushAndRemoveUntil(BuildContext context, Widget page) {
    Navigator.pushAndRemoveUntil(
      context,
      _FadeSlideRoute(builder: (_) => page),
      (route) => false,
    );
  }

  /// Pop the current route
  static void pop(BuildContext context) {
    Navigator.pop(context);
  }

  /// Pop to first route (root)
  static void popToFirst(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}
