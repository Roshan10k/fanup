import 'package:flutter/material.dart';
import 'onboarding_data.dart';

class OnboardingSlide extends StatelessWidget {
  final OnboardingSlideData data;

  const OnboardingSlide({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: Icon(data.icon, size: 100, color: Colors.orange,),
        ),
        const SizedBox(height: 30),
        Text(
          data.title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600,fontFamily: "assets/fonts/Poppins-Bold.ttf",),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          data.description,
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600,fontFamily: "assets/fonts/Poppins-Regular.ttf",),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
