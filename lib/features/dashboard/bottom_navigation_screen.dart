import 'package:fanup/features/dashboard/bottom_navigation_screens/home_screen.dart';
import 'package:fanup/features/dashboard/bottom_navigation_screens/leaderboard_screen.dart';
import 'package:fanup/features/dashboard/bottom_navigation_screens/profile_screen.dart';
import 'package:fanup/features/dashboard/bottom_navigation_screens/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:fanup/app/themes/theme.dart';

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTablet = constraints.maxWidth >= 600;

        // Responsive sizes
        final double navBarHeight = isTablet ? 80 : 60;
        final double iconSize = isTablet ? 28 : 24;
        final double indicatorWidth = isTablet ? 40 : 32;
        final double indicatorHeight = isTablet ? 5 : 4;
        final double spacing = isTablet ? 8 : 6;
        final double fontSize = isTablet ? 16 : 13;

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
                height: navBarHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      Icons.home,
                      "Home",
                      0,
                      iconSize,
                      fontSize,
                      indicatorWidth,
                      indicatorHeight,
                      spacing,
                    ),
                    _buildNavItem(
                      Icons.leaderboard,
                      "Leaderboard",
                      1,
                      iconSize,
                      fontSize,
                      indicatorWidth,
                      indicatorHeight,
                      spacing,
                    ),
                    _buildNavItem(
                      Icons.wallet,
                      "Wallet",
                      2,
                      iconSize,
                      fontSize,
                      indicatorWidth,
                      indicatorHeight,
                      spacing,
                    ),
                    _buildNavItem(
                      Icons.person,
                      "Profile",
                      3,
                      iconSize,
                      fontSize,
                      indicatorWidth,
                      indicatorHeight,
                      spacing,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    int index,
    double iconSize,
    double fontSize,
    double indicatorWidth,
    double indicatorHeight,
    double spacing,
  ) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Top Indicator Bar
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: indicatorHeight,
            width: isSelected ? indicatorWidth : 0,
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

          SizedBox(height: spacing),

          Icon(
            icon,
            size: iconSize,
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
          ),

          Text(
            label,
            style: isSelected
                ? AppTextStyles.poppinsSemiBold13.copyWith(
                    fontSize: fontSize,
                    color: AppColors.primary,
                  )
                : AppTextStyles.poppinsSemiBold13.copyWith(
                    fontSize: fontSize,
                    color: AppColors.textSecondary,
                  ),
          ),
        ],
      ),
    );
  }
}
