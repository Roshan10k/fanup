import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  // Set to true when testing on physical device
  static const bool isPhysicalDevice = false;
  // Replace with your computer's local IP (run `ifconfig | grep inet` to find it)
  static const String configuredPhysicalDeviceIp = String.fromEnvironment(
    'API_HOST',
    defaultValue: '192.168.1.111',
  );
  static const int port = int.fromEnvironment('API_PORT', defaultValue: 3001);

  static String get _host {
    if (isPhysicalDevice) return configuredPhysicalDeviceIp;
    if (kIsWeb || Platform.isIOS) return 'localhost';
    if (Platform.isAndroid) return '10.0.2.2';
    return 'localhost';
  }

  static String get serverUrl => 'http://$_host:$port';
  static String get baseUrl => '$serverUrl/api';
  static String get mediaServerUrl => serverUrl;

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String uploadProfilePhoto = '/auth/upload-profile-photo';

  // User/Profile
  static const String whoami = '/users/profile';
  static const String updateProfile = '/users/profile';
  static const String profileStats = '/users/profile/stats';

  // Home dashboard
  static const String matches = '/matches';
  static const String completedMatches = '/matches/completed';
  static const String myContestEntries = '/leaderboard/my-entries';
  static const String players = '/players';
  static String submitContestEntry(String matchId) =>
      '/leaderboard/contests/$matchId/entry';
  static const String leaderboardContests = '/leaderboard/contests';
  static String leaderboardContestByMatch(String matchId) =>
      '/leaderboard/contests/$matchId';
  static String deleteContestEntry(String matchId) =>
      '/leaderboard/contests/$matchId/entry';

  // Wallet
  static const String walletSummary = '/wallet/summary';
  static const String walletTransactions = '/wallet/transactions';
  static const String walletDailyBonus = '/wallet/daily-bonus';

  // Notifications
  static const String notifications = '/notifications';
  static const String notificationsUnreadCount = '/notifications/unread-count';
  static const String registerDeviceToken = '/notifications/devices/register';
  static String unregisterDeviceToken(String token) =>
      '/notifications/devices/$token';

  static String profilePicture(String filename) {
    if (filename.startsWith('http://') || filename.startsWith('https://')) {
      return filename;
    }

    final cleanFilename = filename.startsWith('/')
        ? filename.substring(1)
        : filename;

    return '$mediaServerUrl/uploads/profile-pictures/$cleanFilename';
  }
}
