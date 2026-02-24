import 'package:fanup/app/themes/theme.dart';
import 'package:flutter/material.dart';

class MatchCard extends StatelessWidget {
  final String league;
  final String dateTime;
  final String teamA;
  final String teamB;
  final String buttonLabel;
  final VoidCallback onCreateTeam;

  const MatchCard({
    super.key,
    required this.league,
    required this.dateTime,
    required this.teamA,
    required this.teamB,
    this.buttonLabel = 'Create Team',
    required this.onCreateTeam,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
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

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_leagueBadge(), _dateLiveIndicator()],
    );
  }

  Widget _leagueBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(league, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _dateLiveIndicator() {
    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          dateTime,
          style: TextStyle(color: Colors.grey.shade600),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }

  Widget _buildTeamsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _teamColumn(teamA),
        const Text(
          'VS',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        _teamColumn(teamB),
      ],
    );
  }

  Widget _teamColumn(String teamName) {
    final initials = _getInitials(teamName);
    return Column(
      children: [
        Container(
          height: 45,
          width: 45,
          decoration: const BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              initials,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(teamName, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  String _getInitials(String text) {
    if (text.isEmpty) return '';
    final words = text.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return text.substring(0, 1).toUpperCase();
  }

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
        child: Text(
          buttonLabel,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
