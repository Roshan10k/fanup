import 'package:fanup/screens/login_screen.dart';
import 'package:flutter/material.dart';
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
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      ;
    } else {
      setState(() => step++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLast = step == onboardingSlides.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Getting Started",style: TextStyle(fontFamily: "assets/fonts/Poppins-SemiBold.ttf"),),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: const Text("Skip",style: TextStyle(fontFamily: "assets/fonts/Poppins-SemiBold.ttf"),),
                  ),
                ],
              ),

              // Slide
              Expanded(child: OnboardingSlide(data: onboardingSlides[step])),

              // Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onboardingSlides.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 6,
                    width: i == step ? 20 : 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: i == step ? Colors.red : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  
                  onPressed: next,
                  child: Text(isLast ? "Get Started" : "Next",style: TextStyle(fontFamily:"assets/fonts/Poppins-SemiBold.ttf", fontSize: 18 ),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
