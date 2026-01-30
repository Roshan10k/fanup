import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  // Configuration
  static const bool isPhysicalDevice = false;
  static const String _ipAddress = '192.168.1.1';
  static const int _port = 3001;

  // Base URLs
  static String get _host {
    if (isPhysicalDevice) return _ipAddress;
    if (kIsWeb || Platform.isIOS) return 'localhost';
    if (Platform.isAndroid) return '10.0.2.2';
    return 'localhost';
  }

  static String get serverUrl => 'http://$_host:$_port';
  static String get baseUrl => '$serverUrl/api';
  static String get mediaServerUrl => serverUrl;

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ================= Auth Endpoints =================

  static const String auth = '/auth';

  /// POST
  static const String login = '/auth/login';

  /// POST
  static const String register = '/auth/register';



 // ================= Profile Endpoints =================
  static const String whoami = 'auth/whoami';
  static const String updateProfile = 'auth/update-profile';

  /// POST - Upload profile photo
  static const String uploadProfilePhoto = '/auth/upload-profile-photo';
  
  /// Helper method to build profile picture URL from filename
  
  /// Example: profilePicture('abc123.jpg') returns 'http://10.0.2.2:3001/uploads/profile-pictures/abc123.jpg'
  static String profilePicture(String filename) {
    // If filename is already a full URL, return it as-is
    if (filename.startsWith('http://') || filename.startsWith('https://')) {
      return filename;
    }
    
    // Remove any leading slashes from filename
    final cleanFilename = filename.startsWith('/') ? filename.substring(1) : filename;
    
    // Build the full URL with the CORRECT path
    return '$mediaServerUrl/uploads/profile-pictures/$cleanFilename';
  }
}