import 'package:flutter/material.dart';
import 'package:fanup/themes/theme.dart';
import 'package:fanup/widgets/balance_card_widget.dart';
import 'package:fanup/widgets/match_card_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo and Title
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  
                  Image.asset(
                    "assets/images/logo.png",
                    height: 90,
                    width: 90,
                    fit: BoxFit.contain,
                  ),
        
                  const SizedBox(width: 14),
        
                 
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
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
        
                     
        
                      Text(
                        "Build your dream team",
                        style: AppTextStyles.poppinsRegular16.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
        
              const SizedBox(height: 10),
        
              // Balance Card
              BalanceCardWidget(credit: 100.0, onAddCredit: () {}),
              const SizedBox(height: 10),
        
              // Upcoming Matches Title
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
      ),
    );
  }
}
