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
    final size = MediaQuery.of(context).size;
    final isLast = step == onboardingSlides.length - 1;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.06,
              vertical: size.height * 0.02,
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
                        fontSize: 16,
                        fontFamily: 'Poppins Regular',
                        color: AppColors.textDark,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                        );
                      },
                      child: Text(
                        "Skip",
                        style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins SemiBold',
                        color: AppColors.textDark,
                      ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: size.height * 0.02),

                // Slide
                SizedBox(
                  height: size.height * 0.60,
                  child: OnboardingSlide(data: onboardingSlides[step]),
                ),

                SizedBox(height: size.height * 0.03),

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

                SizedBox(height: size.height * 0.04),

                // Next / Get Started Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: size.height * 0.02),
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
                        fontSize: size.width * 0.05,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
