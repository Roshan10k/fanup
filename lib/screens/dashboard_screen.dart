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
        items: const[
        BottomNavigationBarItem(icon: Icon(Icons.home),
        label: 'Home',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.leaderboard),
        label: 'LeaderBoard',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.wallet),
        label: 'Wallet',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person),
        label: 'Profile',
        ),
      ],
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.red,
      selectedLabelStyle: TextStyle(fontFamily: "assets/fonts/Poppins-Bold.ttf",fontSize: 18),
      unselectedLabelStyle: TextStyle(fontFamily: "assets/fonts/Poppins-SemiBold.ttf",fontSize: 16),
    )
    );
  }
}