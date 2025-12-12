import 'package:fanup/themes/theme.dart';
import 'package:flutter/material.dart';

class MatchCard extends StatelessWidget {
  final String league;
  final String dateTime;
  final String teamA;
  final String teamB;
  final VoidCallback onCreateTeam;

  const MatchCard({
    super.key,
    required this.league,
    required this.dateTime,
    required this.teamA,
    required this.teamB,
    required this.onCreateTeam,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 18),
          _buildTeamsRow(),
          const SizedBox(height: 20),
          _buildCreateTeamButton(),
        ],
      ),
    );
  }

  /// Header: League Badge + Date + Live Indicator
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _leagueBadge(),
        _dateLiveIndicator(),
      ],
    );
  }

  Widget _leagueBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        league,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _dateLiveIndicator() {
    return Row(
      children: [
        Text(dateTime, style: TextStyle(color: Colors.grey.shade600)),
        const SizedBox(width: 60),
        const Icon(Icons.circle, color: Colors.red, size: 10),
        const SizedBox(width: 4),
        const Text(
          "Live",
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// Teams Row
  Widget _buildTeamsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _teamColumn(teamA),
        const Text(
          "VS",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        _teamColumn(teamB),
      ],
    );
  }

  /// Individual Team Widget
  Widget _teamColumn(String teamName) {
    return Column(
      children: [
        Container(
          height: 45,
          width: 45,
          decoration: const BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 6),
        Text(teamName, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  /// Create Team Button
  Widget _buildCreateTeamButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onCreateTeam,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          "Create Team",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
