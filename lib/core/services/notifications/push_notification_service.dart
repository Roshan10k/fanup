import 'dart:async';
import 'dart:io';

import 'package:fanup/features/notifications/domain/usecases/register_device_token_usecase.dart';
import 'package:fanup/features/notifications/domain/usecases/unregister_device_token_usecase.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pushNotificationServiceProvider = Provider<PushNotificationService>((
  ref,
) {
  return PushNotificationService(
    registerDeviceTokenUsecase: ref.read(registerDeviceTokenUsecaseProvider),
    unregisterDeviceTokenUsecase: ref.read(
      unregisterDeviceTokenUsecaseProvider,
    ),
  );
});

class PushNotificationService {
  final RegisterDeviceTokenUsecase _registerDeviceTokenUsecase;
  final UnregisterDeviceTokenUsecase _unregisterDeviceTokenUsecase;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<RemoteMessage>? _foregroundMessageSubscription;
  bool _initialized = false;

  PushNotificationService({
    required RegisterDeviceTokenUsecase registerDeviceTokenUsecase,
    required UnregisterDeviceTokenUsecase unregisterDeviceTokenUsecase,
  }) : _registerDeviceTokenUsecase = registerDeviceTokenUsecase,
       _unregisterDeviceTokenUsecase = unregisterDeviceTokenUsecase;

  String get _platform {
    if (kIsWeb) return 'web';
    if (Platform.isIOS) return 'ios';
    return 'android';
  }

  Future<void> initializeForAuthenticatedUser() async {
    if (!_initialized) {
      _initialized = true;
      await _messaging.requestPermission(alert: true, badge: true, sound: true);

      _foregroundMessageSubscription = FirebaseMessaging.onMessage.listen((
        message,
      ) {
        debugPrint('Foreground push: ${message.messageId}');
      });

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        debugPrint('Push tap opened app: ${message.messageId}');
      });
    }

    await registerCurrentToken();

    _tokenRefreshSubscription ??= _messaging.onTokenRefresh.listen((newToken) {
      void registerRefreshedToken() async {
        await _registerDeviceTokenUsecase(
          RegisterDeviceTokenParams(
            token: newToken,
            platform: _platform,
            appVersion: null,
            deviceId: null,
          ),
        );
      }

      registerRefreshedToken();
    });
  }

  Future<void> registerCurrentToken() async {
    final token = await _messaging.getToken();
    if (token == null || token.isEmpty) return;

    await _registerDeviceTokenUsecase(
      RegisterDeviceTokenParams(
        token: token,
        platform: _platform,
        appVersion: null,
        deviceId: null,
      ),
    );
  }

  Future<void> unregisterCurrentToken() async {
    final token = await _messaging.getToken();
    if (token == null || token.isEmpty) return;

    await _unregisterDeviceTokenUsecase(
      UnregisterDeviceTokenParams(token: token),
    );
  }

  Future<void> dispose() async {
    await _tokenRefreshSubscription?.cancel();
    await _foregroundMessageSubscription?.cancel();
    _tokenRefreshSubscription = null;
    _foregroundMessageSubscription = null;
    _initialized = false;
  }
}
