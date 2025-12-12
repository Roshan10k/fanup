import 'package:fanup/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:fanup/widgets/balance_card_widget.dart';
import 'package:fanup/widgets/match_card_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'LeaderBoard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        unselectedItemColor: AppColors.textSecondary,
        selectedItemColor: AppColors.primary,
        selectedLabelStyle: AppTextStyles.poppinsSemiBold15,
        unselectedLabelStyle: AppTextStyles.poppinsSemiBold13,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(left: 8.0 ),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Fan",
                      style: AppTextStyles.poppinsBold24.copyWith(
                        color: AppColors.textDark,
                      ),
                    ),
                    TextSpan(
                      text: "Up",
                      style: AppTextStyles.poppinsBold24.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:8.0, bottom: 10.0),
              child: Text(
                "Build your dream team",
                style: AppTextStyles.poppinsRegular16.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Balance Card
            BalanceCardWidget(credit: 100.0, onAddCredit: () {}),
            const SizedBox(height: 10),

            // Upcoming Matches
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Upcoming Matches',
                style: AppTextStyles.poppinsSemiBold18.copyWith(
                  color: AppColors.textDark,
                ),
              ),
            ),

            // Match Cards
            MatchCard(
              league: "NPL",
              dateTime: "4th Nov, 26, 3:15 PM",
              teamA: "IND",
              teamB: "AUS",
              onCreateTeam: () {},
            ),
            MatchCard(
              league: "NPL",
              dateTime: "4th Nov, 26, 3:15 PM",
              teamA: "IND",
              teamB: "AUS",
              onCreateTeam: () {},
            ),
            MatchCard(
              league: "BBL",
              dateTime: "5th Nov, 26, 5:30 PM",
              teamA: "PAK",
              teamB: "SL",
              onCreateTeam: () {},
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
