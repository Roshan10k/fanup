import 'package:fanup/app/themes/theme.dart';
import 'package:fanup/core/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A toggle button to switch between light and dark themes

class ThemeToggleButton extends ConsumerWidget {
  final bool showLabel;
  final double iconSize;

  const ThemeToggleButton({
    super.key,
    this.showLabel = true,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    final themeNotifier = ref.read(themeModeProvider.notifier);

    return GestureDetector(
      onTap: () => themeNotifier.toggleTheme(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isDarkMode
              ? DarkColors.surface
              : LightColors.primary.withAlpha(25), // 0.1 * 255 ≈ 25
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode
                ? DarkColors.brandGold.withAlpha(153) // 0.6 * 255 ≈ 153
                : LightColors.primary.withAlpha(77), // 0.3 * 255 ≈ 77
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? DarkColors.brandGold.withAlpha(38) // 0.15 * 255 ≈ 38
                  : Colors.black.withAlpha(13), // 0.05 * 255 ≈ 13
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isDarkMode ? Icons.wb_sunny_rounded : Icons.dark_mode_rounded,
              size: iconSize,
              color: isDarkMode
                  ? DarkColors.brandGold
                  : LightColors.primary,
            ),
            if (showLabel) ...[
              const SizedBox(width: 8),
              Text(
                isDarkMode ? 'Light Mode' : 'Dark Mode',
                style: TextStyle(
                  fontFamily: 'Poppins SemiBold',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode
                      ? DarkColors.brandGold
                      : LightColors.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A simple icon-only theme toggle
class ThemeToggleIcon extends ConsumerWidget {
  final double size;
  final Color? color;

  const ThemeToggleIcon({
    super.key,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    final themeNotifier = ref.read(themeModeProvider.notifier);

    return IconButton(
      onPressed: () => themeNotifier.toggleTheme(),
      icon: Icon(
        isDarkMode ? Icons.wb_sunny_rounded : Icons.dark_mode_rounded,
        size: size,
        color: color ??
            (isDarkMode
                ? DarkColors.brandGold
                : Theme.of(context).colorScheme.onSurface),
      ),
      tooltip: isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
    );
  }
}

/// A switch-style theme toggle
class ThemeToggleSwitch extends ConsumerWidget {
  const ThemeToggleSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    final themeNotifier = ref.read(themeModeProvider.notifier);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.wb_sunny_rounded,
          size: 20,
          color: !isDarkMode
              ? LightColors.brandGold
              : Theme.of(context).colorScheme.onSurface.withAlpha(128), // 0.5 * 255 ≈ 128
        ),
        const SizedBox(width: 8),
        Switch(
          value: isDarkMode,
          onChanged: (_) => themeNotifier.toggleTheme(),
          activeThumbColor: DarkColors.primary,
          activeTrackColor: DarkColors.primary.withAlpha(128), // 0.5 * 255 ≈ 128
          inactiveThumbColor: LightColors.primary,
          inactiveTrackColor: LightColors.primary.withAlpha(77), // 0.3 * 255 ≈ 77
        ),
        const SizedBox(width: 8),
        Icon(
          Icons.dark_mode_rounded,
          size: 20,
          color: isDarkMode
              ? DarkColors.brandGold
              : Theme.of(context).colorScheme.onSurface.withAlpha(128), // 0.5 * 255 ≈ 128
        ),
      ],
    );
  }
}
