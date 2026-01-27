import 'package:flutter/material.dart';
import 'package:fanup/app/themes/theme.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildTopThree(),
              const SizedBox(height: 24),
              _buildLeaderList(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Leaderboard", style: AppTextStyles.headerTitle),
          const SizedBox(height: 4),
          Text("Top Performers", style: AppTextStyles.headerSubtitle),
        ],
      ),
    );
  }

  Widget _buildTopThree() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD54F), Color(0xFFFFA726)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFA726).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildPodiumItem(
            icon: Icons.person,
            name: "Nishad M.",
            pts: "200 Pts",
            score: "50.0",
            position: 2,
          ),
          _buildWinnerItem(),
          _buildPodiumItem(
            icon: Icons.military_tech,
            name: "Sworup P.",
            pts: "199 Pts",
            score: "30.0",
            position: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildWinnerItem() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.emoji_events, size: 42, color: Colors.orange),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Text("Roshan K.", style: AppTextStyles.cardTitle),
              const SizedBox(height: 4),
              Text("300 Pts", style: AppTextStyles.cardSubtitle),
              const SizedBox(height: 4),
              Text(
                "100.0",
                style: AppTextStyles.amountSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPodiumItem({
    required IconData icon,
    required String name,
    required String pts,
    required String score,
    required int position,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.white.withOpacity(0.3),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Text(
                name,
                style: AppTextStyles.cardSubtitle.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(pts, style: AppTextStyles.labelText),
              const SizedBox(height: 4),
              Text(
                score,
                style: AppTextStyles.cardValue.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: List.generate(
          5,
          (index) {
            final rank = index + 4;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(
                    "$rank.",
                    style: AppTextStyles.cardSubtitle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Player Name", style: AppTextStyles.cardTitle),
                        const SizedBox(height: 4),
                        Text("150 Pts", style: AppTextStyles.labelText),
                      ],
                    ),
                  ),
                  Text(
                    "20.0",
                    style: AppTextStyles.amountSmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}