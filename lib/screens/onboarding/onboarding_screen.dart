import 'package:fanup/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:fanup/screens/login_screen.dart';
import 'onboarding_data.dart';
import 'onboarding_slide.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int step = 0;

  void next() {
    if (step == onboardingSlides.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      setState(() => step++);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isTablet = constraints.maxWidth >= 600;

            // Responsive sizes
            final double horizontalPadding =
                isTablet ? constraints.maxWidth * 0.15 : constraints.maxWidth * 0.06;
            final double verticalPadding =
                isTablet ? constraints.maxHeight * 0.03 : constraints.maxHeight * 0.02;
            final double slideHeight =
                isTablet ? constraints.maxHeight * 0.55 : constraints.maxHeight * 0.60;
            final double spacingSmall = isTablet ? constraints.maxHeight * 0.025 : constraints.maxHeight * 0.02;
            final double spacingMedium = isTablet ? constraints.maxHeight * 0.09 : constraints.maxHeight * 0.08;
             final double spacingLarge = isTablet ? constraints.maxHeight * 0.06 : constraints.maxHeight * 0.045;
            final double buttonPadding = isTablet ? constraints.maxHeight * 0.025 : constraints.maxHeight * 0.02;
            final double fontSizeHeader = isTablet ? 20 : 16;
            final double fontSizeButton = isTablet ? 18 : 16;

            final isLast = step == onboardingSlides.length - 1;

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: Column(
                  children: [
                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Getting Started",
                          style: TextStyle(
                            fontSize: fontSizeHeader,
                            fontFamily: 'Poppins Regular',
                            color: AppColors.textDark,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginScreen()),
                            );
                          },
                          child: Text(
                            "Skip",
                            style: TextStyle(
                              fontSize: fontSizeHeader,
                              fontFamily: 'Poppins SemiBold',
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: spacingSmall),

                    // Slide
                    SizedBox(
                      height: slideHeight,
                      child: OnboardingSlide(data: onboardingSlides[step]),
                    ),

                    SizedBox(height: spacingMedium),

                    // Indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        onboardingSlides.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          height: 6,
                          width: i == step ? 22 : 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: i == step
                                ? AppColors.primary
                                : AppColors.textSecondary.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: spacingLarge),

                    // Next / Get Started Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: buttonPadding),
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: next,
                        child: Text(
                          isLast ? "Get Started" : "Next",
                          style: AppTextStyles.poppinsSemiBold13.copyWith(
                            fontSize: fontSizeButton,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
