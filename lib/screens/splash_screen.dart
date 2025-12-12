import 'dart:async';
import 'package:fanup/screens/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import '../themes/theme.dart'; // make sure to import your theme

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int activeDot = 0;

  @override
  void initState() {
    super.initState();

    // Animate dots every 400ms
    Timer.periodic(const Duration(milliseconds: 400), (timer) {
      setState(() {
        activeDot = (activeDot + 1) % 3;
      });
    });

    // Navigate to onboarding after 2.5s
    Timer(const Duration(milliseconds: 2500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.splashGradientStart,
            AppColors.splashGradientEnd
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo
          Image.asset(
            'assets/images/logo.png',
            width: 487,
            height: 300,
          ),

          // Rich Text Logo
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Fan",
                  style: AppTextStyles.poppinsBold36.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
                TextSpan(
                  text: "Up",
                  style: AppTextStyles.poppinsBold36.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Text(
            "Build your Dream Team",
            style: AppTextStyles.poppinsRegular16.copyWith(
              color: Colors.white,
              decoration: TextDecoration.none
            ),
          ),

          const SizedBox(height: 120),

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
  }

  Widget _buildDot(int index) {
    bool isActive = activeDot == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isActive ? 12 : 10,
      height: isActive ? 12 : 10,
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
    );
  }
}
