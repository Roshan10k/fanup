import 'package:fanup/app/themes/theme.dart';
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    league,
                    style: AppTextStyles.poppinsSemiBold13.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ),
                Text(
                  dateTime,
                  style: AppTextStyles.poppinsRegular15.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              teamName,
              style: AppTextStyles.poppinsSemiBold18.copyWith(
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _TeamToken(name: teamA),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'VS',
                      style: AppTextStyles.poppinsSemiBold13.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  _TeamToken(name: teamB),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.green.shade200,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total Points: ',
                    style: AppTextStyles.poppinsSemiBold15.copyWith(
                      color: Colors.green.shade700,
                    ),
                  ),
                  Text(
                    '$points',
                    style: AppTextStyles.poppinsBold24.copyWith(
                      color: Colors.green.shade700,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onViewTeam,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'View Team',
                  style: AppTextStyles.poppinsSemiBold15.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamToken extends StatelessWidget {
  final String name;

  const _TeamToken({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.dividerGrey,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          name,
          style: AppTextStyles.poppinsSemiBold15.copyWith(
            color: AppColors.textDark,
          ),
        ),
      ),
    );
  }
}
