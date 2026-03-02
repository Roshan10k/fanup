import 'package:fanup/app/app.dart';
import 'package:fanup/core/services/hive/hive_service.dart';
import 'package:fanup/core/services/storage/token_service.dart';
import 'package:fanup/core/services/storage/user_session_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final hiveService = HiveService();
  await hiveService.init();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize Google Sign-In.
  
  await GoogleSignIn.instance.initialize(
    serverClientId: const String.fromEnvironment(
      'GOOGLE_SERVER_CLIENT_ID',
      defaultValue: 'Y181810254605-2bn9fe9odmgbrint54n0c195b22gnj63.apps.googleusercontent.com',
    ),
  );

  final sharedPrefs = await SharedPreferences.getInstance();

  // Hydrate token from secure storage into memory cache
  final tokenService = TokenService();
  await tokenService.init();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPrefs),
        tokenServiceProvider.overrideWithValue(tokenService),
      ],
      child: const App(),
    ),
  );
}
