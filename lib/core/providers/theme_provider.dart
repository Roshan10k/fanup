import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fanup/core/services/storage/user_session_service.dart';

const String _themeStorageKey = 'fanup_theme_mode';
const String _autoThemeStorageKey = 'fanup_auto_theme';

/// Provider for the ThemeService
final themeServiceProvider = Provider<ThemeService>((ref) {
  return ThemeService(prefs: ref.read(sharedPreferencesProvider));
});

/// Provider for auto theme toggle preference
final autoThemeEnabledProvider = NotifierProvider<AutoThemeNotifier, bool>(() {
  return AutoThemeNotifier();
});

/// Provider for the current theme mode state using Notifier (Riverpod 3.x)
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(() {
  return ThemeModeNotifier();
});

/// Convenience provider to check if dark mode is active
final isDarkModeProvider = Provider<bool>((ref) {
  return ref.watch(themeModeProvider) == ThemeMode.dark;
});

/// Service to persist theme preference
class ThemeService {
  final SharedPreferences _prefs;

  ThemeService({required SharedPreferences prefs}) : _prefs = prefs;

  bool getAutoThemeEnabled() {
    return _prefs.getBool(_autoThemeStorageKey) ?? true;
  }

  Future<void> setAutoThemeEnabled(bool enabled) async {
    await _prefs.setBool(_autoThemeStorageKey, enabled);
  }

  ThemeMode getThemeMode() {
    final savedTheme = _prefs.getString(_themeStorageKey);
    if (savedTheme == 'dark') {
      return ThemeMode.dark;
    } else if (savedTheme == 'light') {
      return ThemeMode.light;
    }
    return ThemeMode.system;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    String value;
    switch (mode) {
      case ThemeMode.dark:
        value = 'dark';
        break;
      case ThemeMode.light:
        value = 'light';
        break;
      case ThemeMode.system:
        value = 'system';
        break;
    }
    await _prefs.setString(_themeStorageKey, value);
  }
}

/// Notifier to manage theme mode changes (Riverpod 3.x pattern)
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final themeService = ref.read(themeServiceProvider);
    return themeService.getThemeMode();
  }

  void toggleTheme() {
    final themeService = ref.read(themeServiceProvider);
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    state = newMode;
    themeService.setThemeMode(newMode);
  }

  void setThemeMode(ThemeMode mode) {
    final themeService = ref.read(themeServiceProvider);
    state = mode;
    themeService.setThemeMode(mode);
  }
}

/// Notifier to manage auto theme preference
class AutoThemeNotifier extends Notifier<bool> {
  @override
  bool build() {
    final themeService = ref.read(themeServiceProvider);
    return themeService.getAutoThemeEnabled();
  }

  Future<void> setAutoThemeEnabled(bool enabled) async {
    final themeService = ref.read(themeServiceProvider);
    state = enabled;
    await themeService.setAutoThemeEnabled(enabled);
  }
}
