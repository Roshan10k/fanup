import 'package:fanup/app/app.dart';
import 'package:fanup/core/services/hive/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main () async{
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive
  final hiveService = HiveService();
  await hiveService.init();
  runApp(ProviderScope(child: const App()));
}