import 'package:fanup/app/themes/theme.dart';
import 'package:fanup/core/utils/responsive_utils.dart';
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 500;
        final padding = isTablet ? 20.0 : 14.0;
        final verticalMargin = isTablet ? 12.0 : 8.0;
        final fontScale = context.fontScale;

        return Container(
          margin: EdgeInsets.symmetric(vertical: verticalMargin, horizontal: 8),
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withAlpha(31),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildHeader(context, fontScale),
              SizedBox(height: isTablet ? 20 : 14),
              _buildTeamsRow(context, isTablet, fontScale),
              SizedBox(height: isTablet ? 22 : 16),
              _buildCreateTeamButton(fontScale),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, double fontScale) {
    return Row(
      children: [
        Flexible(
          flex: 2,
          child: _leagueBadge(context, fontScale),
        ),
        const SizedBox(width: 8),
        Flexible(
          flex: 3,
          child: _dateLiveIndicator(context, fontScale),
        ),
      ],
    );
  }

  Widget _leagueBadge(BuildContext context, double fontScale) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        league,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 13 * fontScale,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  Widget _dateLiveIndicator(BuildContext context, double fontScale) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        dateTime,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
          fontSize: 12 * fontScale,
        ),
        textAlign: TextAlign.right,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  Widget _buildTeamsRow(BuildContext context, bool isTablet, double fontScale) {
    final avatarSize = isTablet ? 55.0 : 42.0;
    final initialsSize = isTablet ? 20.0 : 16.0;

    return Row(
      children: [
        Expanded(
          child: _teamColumn(context, teamA, avatarSize, initialsSize, fontScale),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'VS',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(128),
              fontSize: 14 * fontScale,
            ),
          ),
        ),
        Expanded(
          child: _teamColumn(context, teamB, avatarSize, initialsSize, fontScale),
        ),
      ],
    );
  }

  Widget _teamColumn(BuildContext context, String teamName, double avatarSize, double initialsSize, double fontScale) {
    final initials = _getInitials(teamName);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: avatarSize,
          width: avatarSize,
          decoration: const BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              initials,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: initialsSize,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          teamName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 13 * fontScale,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          textAlign: TextAlign.center,
        ),
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

  Widget _buildCreateTeamButton(double fontScale) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onCreateTeam,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          buttonLabel,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15 * fontScale,
            color: Colors.white,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }
}
