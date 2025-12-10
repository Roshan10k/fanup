import 'package:fanup/widgets/match_card_widget.dart';
import 'package:flutter/material.dart';


class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'LeaderBoard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
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
        child: Column(
          children: [
            const SizedBox(height: 10),
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
