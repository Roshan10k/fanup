import 'package:fanup/widgets/balance_card_widget.dart';
import 'package:fanup/widgets/match_card_widget.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
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
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.red,
        selectedLabelStyle: const TextStyle(
          fontFamily: "Poppins-Bold",
          fontSize: 15,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: "Poppins-SemiBold",
          fontSize: 13,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Fan",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.grey.shade800,
                          fontFamily: "Poppins-SemiBold",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(
                        text: "Up",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.red,
                          fontFamily: "Poppins-Bold",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsGeometry.only(left: 8.0),
                child: Text(
                  "Build your dream team",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    fontFamily: "Poppins-Regular",
                  ),
                ),
              ),
              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BalanceCardWidget(
                  credit: 100.0,
                  onAddCredit: () {
                    // Your action
                  },
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Upcoming Matches',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),

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
