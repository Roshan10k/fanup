import 'package:fanup/app/app.dart';
import 'package:fanup/core/services/hive/hive_service.dart';
import 'package:fanup/core/services/storage/user_session_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main () async{
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive
  final hiveService = HiveService();
  await hiveService.init();

  //shared preferences initialization
  final sharedPrefs = await SharedPreferences.getInstance();
  await sharedPrefs.clear(); // Clear existing data for fresh start 
  runApp(ProviderScope(overrides: [sharedPreferencesProvider.overrideWithValue(sharedPrefs)],
    child: const App()));
}