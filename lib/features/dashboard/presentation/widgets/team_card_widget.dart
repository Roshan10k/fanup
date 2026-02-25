import 'package:fanup/app/themes/theme.dart';
import 'package:fanup/core/utils/responsive_utils.dart';
import 'package:flutter/material.dart';

class TeamCardWidget extends StatelessWidget {
  final String league;
  final String dateTime;
  final String teamA;
  final String teamB;
  final String teamName;
  final int points;
  final VoidCallback? onViewTeam;

  const TeamCardWidget({
    super.key,
    required this.league,
    required this.dateTime,
    required this.teamA,
    required this.teamB,
    required this.teamName,
    required this.points,
    this.onViewTeam,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 500;
        final fontScale = context.fontScale;
        final padding = isTablet ? 18.0 : 14.0;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withAlpha(15),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, fontScale),
                SizedBox(height: isTablet ? 14 : 10),
                _buildTeamName(context, fontScale),
                SizedBox(height: isTablet ? 14 : 10),
                _buildTeamsVs(context, isTablet, fontScale),
                SizedBox(height: isTablet ? 14 : 10),
                _buildPointsCard(context, fontScale),
                SizedBox(height: isTablet ? 16 : 12),
                _buildViewTeamButton(context, fontScale),
              ],
            ),
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
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              league,
              style: AppTextStyles.poppinsSemiBold13.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
                fontSize: 11 * fontScale,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          flex: 3,
          child: Text(
            dateTime,
            style: AppTextStyles.poppinsRegular15.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
              fontSize: 11 * fontScale,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildTeamName(BuildContext context, double fontScale) {
    return Text(
      teamName,
      style: AppTextStyles.poppinsSemiBold18.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 16 * fontScale,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  Widget _buildTeamsVs(BuildContext context, bool isTablet, double fontScale) {
    final tokenSize = isTablet ? 56.0 : 48.0;

    return Container(
      padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _TeamToken(name: teamA, size: tokenSize, fontScale: fontScale),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'VS',
              style: AppTextStyles.poppinsSemiBold13.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
                fontSize: 12 * fontScale,
              ),
            ),
          ),
          _TeamToken(name: teamB, size: tokenSize, fontScale: fontScale),
        ],
      ),
    );
  }

  Widget _buildPointsCard(BuildContext context, double fontScale) {
    return Container(
      padding: EdgeInsets.all(10 * fontScale),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              'Total Points: ',
              style: AppTextStyles.poppinsSemiBold15.copyWith(
                color: Colors.green.shade700,
                fontSize: 14 * fontScale,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '$points',
            style: AppTextStyles.poppinsBold24.copyWith(
              color: Colors.green.shade700,
              fontSize: 20 * fontScale,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewTeamButton(BuildContext context, double fontScale) {
    return SizedBox(
      width: double.infinity,
      height: 44 * fontScale,
      child: ElevatedButton(
        onPressed: onViewTeam,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'View Team',
          style: AppTextStyles.poppinsSemiBold15.copyWith(
            color: Colors.white,
            fontSize: 14 * fontScale,
          ),
        ),
      ),
    );
  }
}

class _TeamToken extends StatelessWidget {
  final String name;
  final double size;
  final double fontScale;

  const _TeamToken({
    required this.name,
    required this.size,
    required this.fontScale,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          name,
          style: AppTextStyles.poppinsSemiBold15.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 13 * fontScale,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }
}
