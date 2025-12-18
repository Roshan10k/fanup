import 'dart:async';
import 'package:fanup/screens/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import '../themes/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int activeDot = 0;
  Timer? dotTimer;

  @override
  void initState() {
    super.initState();

    // Animate dots
    dotTimer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
      setState(() {
        activeDot = (activeDot + 1) % 3;
      });
    });

    // Navigate to onboarding
    Timer(const Duration(milliseconds: 2500), () {
      dotTimer?.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }

  @override
  void dispose() {
    dotTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTablet = constraints.maxWidth >= 600;

        // Responsive sizing
        final double logoWidth = isTablet ? 420 : constraints.maxWidth * 0.7;
        final double logoHeight = isTablet ? 260 : 200;
        final double bottomSpacing = isTablet ? 80 : 120;

        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.splashGradientStart,
                AppColors.splashGradientEnd,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/images/logo.png',
                width: logoWidth,
                height: logoHeight,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 16),

              // Rich Text Logo
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Fan",
                      style: AppTextStyles.poppinsBold36.copyWith(
                        color: AppColors.textDark,
                        fontSize: isTablet ? 40 : 36,
                      ),
                    ),
                    TextSpan(
                      text: "Up",
                      style: AppTextStyles.poppinsBold36.copyWith(
                        color: AppColors.primary,
                        fontSize: isTablet ? 40 : 36,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Tagline
              Text(
                "Build your Dream Team",
                style: AppTextStyles.poppinsRegular16.copyWith(
                  color: Colors.white,
                  fontSize: isTablet ? 18 : 16,
                  decoration: TextDecoration.none,
                ),
              ),

              SizedBox(height: bottomSpacing),

              // Loading dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDot(0),
                  const SizedBox(width: 10),
                  _buildDot(1),
                  const SizedBox(width: 10),
                  _buildDot(2),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDot(int index) {
    final bool isActive = activeDot == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isActive ? 12 : 10,
      height: isActive ? 12 : 10,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
    );
  }
}
