import 'package:fanup/screens/splash_screen.dart';
import 'package:fanup/themes/theme.dart';

import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(), 
      home: SplashScreen(),
    );
  }
}