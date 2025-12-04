import 'package:lucide_icons/lucide_icons.dart';

class OnboardingSlideData {
  final String title;
  final String description;
  final dynamic icon;

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
    icon: LucideIcons.trophy,
  ),
  OnboardingSlideData(
    title: "Join exciting contests",
    description: "Compete with other fans and climb the leaderboard.",
    icon: LucideIcons.users,
  ),
  OnboardingSlideData(
    title: "Track wins & rewards",
    description: "Follow live scores and grow your winnings.",
    icon: LucideIcons.wallet,
  ),
];
