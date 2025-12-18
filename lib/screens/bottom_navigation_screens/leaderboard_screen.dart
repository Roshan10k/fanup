import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isTablet = constraints.maxWidth >= 600;

            // Responsive sizes
            final double horizontalPadding = isTablet ? 32 : 20;
            final double verticalPadding = isTablet ? 24 : 16;
            final double spacingSmall = isTablet ? 16 : 12;
            final double spacingMedium = isTablet ? 24 : 16;
            final double iconSize = isTablet ? 48 : 36;
            final double circleRadius = isTablet ? 36 : 26;
            final double podiumPadding = isTablet ? 20 : 12;
            final double headerFontSize = isTablet ? 26 : 22;
            final double subtitleFontSize = isTablet ? 18 : 14;

            return Column(
              children: [
                _header(horizontalPadding, verticalPadding, headerFontSize, subtitleFontSize),
                SizedBox(height: spacingMedium),
                _topThree(iconSize, circleRadius, podiumPadding, spacingMedium),
                SizedBox(height: spacingMedium),
                Expanded(child: _leaderList(spacingSmall, podiumPadding, subtitleFontSize)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _header(double horizontalPadding, double verticalPadding, double headerFontSize, double subtitleFontSize) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Leaderboard",
              style: TextStyle(fontSize: headerFontSize, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              "Top Performers",
              style: TextStyle(color: Colors.grey, fontSize: subtitleFontSize),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topThree(double iconSize, double circleRadius, double podiumPadding, double spacingMedium) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: podiumPadding),
      padding: EdgeInsets.symmetric(vertical: spacingMedium),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD54F), Color(0xFFFFA726)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _podiumItem(icon: Icons.person, name: "Nishad M.", pts: "200 Pts", score: "50.0", circleRadius: circleRadius),
          _winnerItem(iconSize, podiumPadding),
          _podiumItem(icon: Icons.military_tech, name: "Sworup P.", pts: "199 Pts", score: "30.0", circleRadius: circleRadius),
        ],
      ),
    );
  }

  Widget _winnerItem(double iconSize, double padding) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(iconSize / 2),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.emoji_events, size: iconSize, color: Colors.orange),
        ),
        SizedBox(height: padding / 2),
        Container(
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding / 1.5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: const [
              Text(
                "Roshan K.",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text("300 Pts", style: TextStyle(color: Colors.grey)),
              SizedBox(height: 4),
              Text(
                "100.0",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _podiumItem({
    required IconData icon,
    required String name,
    required String pts,
    required String score,
    required double circleRadius,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: circleRadius,
          backgroundColor: Colors.white.withOpacity(0.3),
          child: Icon(icon, color: Colors.white),
        ),
        SizedBox(height: circleRadius / 2),
        Container(
          padding: EdgeInsets.symmetric(horizontal: circleRadius / 1.5, vertical: circleRadius / 2.5),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(height: 4),
              Text(pts),
              SizedBox(height: 4),
              Text(
                score,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _leaderList(double spacing, double padding, double fontSize) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: padding),
      itemCount: 4,
      itemBuilder: (context, index) {
        final rank = index + 4;
        return Container(
          margin: EdgeInsets.only(bottom: spacing),
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Text(
                "$rank.",
                style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Player Name",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text("pts", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const Text(
                "20.0",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
