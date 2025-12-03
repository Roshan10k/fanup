import 'dart:async';
import 'package:fanup/screens/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int activeDot = 0;

  @override
  void initState() {
    super.initState();

    // Animating dots every 400ms
    Timer.periodic(const Duration(milliseconds: 400), (timer) {
      setState(() {
        activeDot = (activeDot + 1) % 3;
      });
    });

    // Move to next screen
   Timer(const Duration(milliseconds: 2500), () {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => LoginScreen()),
  );
});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFD300), Color(0xFFFF8C00)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo
          Image.asset('assets/images/logo.png', width: 487, height: 300),
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: "Fan",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 36,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "Up",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 36,
                    color: Color(0xFFFF3B30), // Red
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 10),

          Text(
            "Build your Dream Team",
            style: TextStyle(
              fontFamily: "Poppins",
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.none,
            ),
          ),

          const SizedBox(height: 120),

          // Loading Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDot(0),
              const SizedBox(width: 10),
              _buildDot(1),
              const SizedBox(width: 10),
              _buildDot(2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    bool isActive = activeDot == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isActive ? 12 : 10,
      height: isActive ? 12 : 10,
      decoration: BoxDecoration(
        color: const Color(0xFFFF3B30), // Red dots
        shape: BoxShape.circle,
      ),
    );
  }
}
