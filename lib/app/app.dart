import 'package:fanup/features/splash/splash_screen.dart';
import 'package:fanup/app/themes/theme.dart';
import 'package:fanup/core/providers/theme_provider.dart';
import 'package:fanup/core/providers/sensor_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    ref.watch(sensorProvider); // start sensor listeners for auto theme
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getLightTheme(),
      darkTheme: getDarkTheme(),
      themeMode: themeMode,
      home: SplashScreen(),
    );
  }
}