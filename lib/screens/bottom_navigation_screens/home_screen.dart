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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isTablet = constraints.maxWidth >= 600;

            // Responsive sizes
            final double logoSize = isTablet ? 120 : 90;
            final double spacingBetweenLogoAndText = isTablet ? 20 : 14;
            final double verticalSpacing = isTablet ? 16 : 10;
            final double titleFontSize = isTablet ? 28 : 24;
            final double subtitleFontSize = isTablet ? 18 : 16;
            final double sectionTitleFontSize = isTablet ? 22 : 18;

            return SingleChildScrollView(
              padding: EdgeInsets.all(isTablet ? 24 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo and Title
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/logo.png",
                        height: logoSize,
                        width: logoSize,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: spacingBetweenLogoAndText),
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
                                    fontSize: titleFontSize,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                TextSpan(
                                  text: "Up",
                                  style: AppTextStyles.poppinsBold24.copyWith(
                                    fontSize: titleFontSize,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: verticalSpacing / 2),
                          Text(
                            "Build your dream team",
                            style: AppTextStyles.poppinsRegular16.copyWith(
                              fontSize: subtitleFontSize,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: verticalSpacing),

                  // Balance Card
                  BalanceCardWidget(
                    credit: 100.0,
                    onAddCredit: () {},
                  ),
                  SizedBox(height: verticalSpacing),

                  // Upcoming Matches Title
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isTablet ? 12 : 8),
                    child: Text(
                      'Upcoming Matches',
                      style: AppTextStyles.poppinsSemiBold18.copyWith(
                        fontSize: sectionTitleFontSize,
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

                  SizedBox(height: verticalSpacing * 2),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
