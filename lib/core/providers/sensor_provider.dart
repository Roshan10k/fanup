import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:light/light.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'theme_provider.dart';

class SensorState {
  final double? lux;
  final bool? isNear;

  const SensorState({this.lux, this.isNear});

  SensorState copyWith({double? lux, bool? isNear}) {
    return SensorState(lux: lux ?? this.lux, isNear: isNear ?? this.isNear);
  }
}

/// Provides proximity and ambient light readings and optionally drives theme
final shakeEnabledProvider = NotifierProvider<ShakeEnabledNotifier, bool>(
  ShakeEnabledNotifier.new,
);

final shakeEventProvider = NotifierProvider<ShakeEventNotifier, int>(
  ShakeEventNotifier.new,
);

final sensorProvider = NotifierProvider<SensorNotifier, SensorState>(
  SensorNotifier.new,
);

class ShakeEnabledNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setEnabled(bool value) {
    state = value;
  }
}

class ShakeEventNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void trigger() {
    state++;
  }
}

class SensorNotifier extends Notifier<SensorState> {
  static const double _darkThreshold =
      10.0; // Very low light triggers dark mode
  static const double _lightThreshold =
      200.0; // Higher threshold for light mode (wider hysteresis gap)
  static const double _shakeThreshold =
      20.0; // Stronger shake needed to trigger
  static const Duration _shakeCooldown = Duration(milliseconds: 800);
  static const Duration _themeCooldown = Duration(
    seconds: 3,
  ); // Debounce theme changes

  StreamSubscription<int>? _proximitySub;
  StreamSubscription<int>? _lightSub;
  StreamSubscription<UserAccelerometerEvent>? _accelerometerSub;
  DateTime _lastShake = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime _lastThemeChange = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  SensorState build() {
    ref.onDispose(() {
      _proximitySub?.cancel();
      _lightSub?.cancel();
      _accelerometerSub?.cancel();
    });

    _startListeners();
    return const SensorState();
  }

  void _startListeners() {
    _proximitySub = ProximitySensor.events.listen((event) {
      state = state.copyWith(isNear: event > 0);
    });

    final light = Light();
    _lightSub = light.lightSensorStream.listen(
      _handleLux,
      onError: (Object e) {
        debugPrint('Light sensor error: $e');
      },
    );

    _accelerometerSub = userAccelerometerEventStream().listen(
      _handleUserAccelerometer,
      onError: (Object e) => debugPrint('Accelerometer error: $e'),
    );
  }

  void _handleLux(int lux) {
    final luxValue = lux.toDouble();
    state = state.copyWith(lux: luxValue);

    final autoEnabled = ref.read(autoThemeEnabledProvider);
    if (!autoEnabled) return;

    // Debounce theme changes to prevent flickering
    final now = DateTime.now();
    if (now.difference(_lastThemeChange) < _themeCooldown) return;

    final themeNotifier = ref.read(themeModeProvider.notifier);
    final currentMode = ref.read(themeModeProvider);

    if (luxValue < _darkThreshold && currentMode != ThemeMode.dark) {
      _lastThemeChange = now;
      themeNotifier.setThemeMode(ThemeMode.dark);
    } else if (luxValue > _lightThreshold && currentMode != ThemeMode.light) {
      _lastThemeChange = now;
      themeNotifier.setThemeMode(ThemeMode.light);
    }
  }

  void _handleUserAccelerometer(UserAccelerometerEvent event) {
    if (!ref.read(shakeEnabledProvider)) return;

    final magnitude = math.sqrt(
      (event.x * event.x) + (event.y * event.y) + (event.z * event.z),
    );

    if (magnitude < _shakeThreshold) return;

    final now = DateTime.now();
    if (now.difference(_lastShake) < _shakeCooldown) return;

    _lastShake = now;
    ref.read(shakeEventProvider.notifier).trigger();
    debugPrint('Shake detected (magnitude=${magnitude.toStringAsFixed(2)})');
  }
}
