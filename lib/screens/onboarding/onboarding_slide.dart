import 'package:fanup/themes/theme.dart';
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
        // Icon Container
        Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            color: AppColors.inputBackground, // centralized color
            shape: BoxShape.circle,
          ),
          child: Icon(
            data.icon,
            size: 100,
            color: AppColors.primary, // use primary app color
          ),
        ),

        const SizedBox(height: 30),

        // Title
        Text(
          data.title,
          style: AppTextStyles.poppinsBold24,
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 12),

        // Description
        Text(
          data.description,
          style: AppTextStyles.poppinsRegular16.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
