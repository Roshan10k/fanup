import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Center(
        child: Text(
          'Leaderboard Screen',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}