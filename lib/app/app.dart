import 'package:fanup/features/splash/splash_screen.dart';
import 'package:fanup/app/themes/theme.dart';

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