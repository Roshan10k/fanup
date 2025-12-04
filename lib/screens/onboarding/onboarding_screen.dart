import 'package:flutter/material.dart';
import 'onboarding_data.dart';
import 'onboarding_slide.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int step = 0;

  void next() {
    if (step == onboardingSlides.length - 1) {
      widget.onComplete();
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
                  const Text("Getting Started"),
                  TextButton(
                    onPressed: widget.onComplete,
                    child: const Text("Skip"),
                  ),
                ],
              ),

              // Slide
              Expanded(
                child: OnboardingSlide(data: onboardingSlides[step]),
              ),

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
                      color: i == step ? Colors.blue : Colors.grey.shade300,
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
                  onPressed: next,
                  child: Text(isLast ? "Get Started" : "Next"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
