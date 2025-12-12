import 'package:flutter/material.dart';
import 'package:fanup/themes/theme.dart';
import 'package:fanup/screens/bottom_navigation_screens/home_screen.dart';
import 'package:fanup/screens/bottom_navigation_screens/leaderboard_screen.dart';
import 'package:fanup/screens/bottom_navigation_screens/wallet_screen.dart';
import 'package:fanup/screens/bottom_navigation_screens/profile_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    LeaderboardScreen(),
    WalletScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home, "Home", 0),
                _buildNavItem(Icons.leaderboard, "Leaderboard", 1),
                _buildNavItem(Icons.wallet, "Wallet", 2),
                _buildNavItem(Icons.person, "Profile", 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Top Indicator Bar
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 4,
            width: isSelected ? 32 : 0,
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [Color(0xFFFCE043), Color(0xFFFF5E62)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  : null,
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          const SizedBox(height: 6),

          Icon(
            icon,
            size: 24,
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
          ),

          Text(
            label,
            style: isSelected
                ? AppTextStyles.poppinsSemiBold13.copyWith(
                    color: AppColors.primary,
                  )
                : AppTextStyles.poppinsSemiBold13.copyWith(
                    color: AppColors.textSecondary,
                  ),
          ),
        ],
      ),
    );
  }
}
