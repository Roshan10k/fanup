import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OnboardingSlideData {
  final String title;
  final String description;
  final IconData icon;

  OnboardingSlideData({
    required this.title,
    required this.description,
    required this.icon,
  });
}

final onboardingSlides = [
  OnboardingSlideData(
    title: "Create your dream team",
    description: "Pick star players, balance credits & build your XI.",
    icon: FontAwesomeIcons.trophy,
  ),
  OnboardingSlideData(
    title: "Join exciting contests",
    description: "Compete with other fans and climb the leaderboard.",
    icon: FontAwesomeIcons.users,
  ),
  OnboardingSlideData(
    title: "Track wins & rewards",
    description: "Follow live scores and grow your winnings.",
    icon: FontAwesomeIcons.coins,
  ),
];
