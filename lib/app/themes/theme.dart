import 'package:flutter/material.dart';

/// Light theme colors matching web version
class LightColors {
  // Primary/Brand Colors (matching web --brand)
  static const Color primary = Color(0xFFE74B5B); // softer coral red
  static const Color primaryDark = Color(0xFFC73D4E);
  static const Color brandGold = Color(0xFFF6C453);

  // Gradient Colors
  static const Color gradientYellow = Color(0xFFFCE043);
  static const Color gradientOrange = Color(0xFFFF5E62);
  static const Color splashGradientStart = Color(0xFFFFD300);
  static const Color splashGradientEnd = Color(0xFFFF8C00);

  // Text Colors (matching web)
  static const Color foreground = Color(0xFF111827);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF4B5563); // --ink-soft
  static const Color textLight = Color(0xFF6B7280);
  static const Color textDark = Color(0xFF000000);

  // Background Colors (matching web)
  static const Color background = Color(0xFFF6F7FB); // --background
  static const Color surface = Color(0xFFFFFFFF); // --surface
  static const Color mutedSurface = Color(0xFFF9FAFB); // --muted-surface
  static const Color inputBackground = Color(0xFFFFFFFF);

  // Border/Line Colors
  static const Color line = Color(0xFFE5E7EB); // --line
  static const Color cardShadow = Color(0xFFE0E0E0);
  static const Color dividerGrey = Color(0xFFE5E7EB);

  // Other Colors
  static const Color liveIndicator = Colors.red;
  static const Color iconGrey = Color(0xFF6B7280);
}

/// Dark theme colors matching web version
class DarkColors {
  // Primary/Brand Colors (softened for dark mode)
  static const Color primary = Color(0xFFE74B5B);
  static const Color primaryDark = Color(0xFFC73D4E);
  static const Color brandGold = Color(0xFFF2C14E);

  // Gradient Colors
  static const Color gradientYellow = Color(0xFFFCE043);
  static const Color gradientOrange = Color(0xFFFF5E62);
  static const Color splashGradientStart = Color(0xFFFFD300);
  static const Color splashGradientEnd = Color(0xFFFF8C00);

  // Text Colors
  static const Color foreground = Color(0xFFE9EDF5);
  static const Color textPrimary = Color(0xFFE9EDF5);
  static const Color textSecondary = Color(0xFF9DA8BC);
  static const Color textLight = Color(0xFF7C879E);
  static const Color textDark = Color(0xFFFFFFFF);

  // Background Colors - high contrast for dark mode
  static const Color background = Color(0xFF050508);
  static const Color surface = Color(0xFF1A222E);
  static const Color surfaceElevated = Color(0xFF2A3448);
  static const Color mutedSurface = Color(0xFF343F52);
  static const Color inputBackground = Color(0xFF222C3A);

  // Border/Line Colors
  static const Color line = Color(0xFF1F2937);
  static const Color cardShadow = Color(0xCC0A0E17);
  static const Color dividerGrey = Color(0xFF1F2937);

  // Other Colors
  static const Color liveIndicator = Colors.red;
  static const Color iconGrey = Color(0xFF9DA8BC);
}

/// App colors that adapt based on theme (for static usage)
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFE74B5B);
  static const Color primaryDark = Color(0xFFC73D4E);

  // Gradient Colors
  static const Color gradientYellow = Color(0xFFFCE043);
  static const Color gradientOrange = Color(0xFFFF5E62);
  static const Color splashGradientStart = Color(0xFFFFD300);
  static const Color splashGradientEnd = Color(0xFFFF8C00);

  // Text Colors (light theme defaults)
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF4B5563);
  static const Color textLight = Color(0xFF6B7280);
  static const Color textDark = Color(0xFF000000);

  // Background Colors
  static const Color background = Color(0xFFF6F7FB);
  static const Color inputBackground = Color(0xFFFFFFFF);
  static const Color cardShadow = Color(0xFFE0E0E0);

  // Other Colors
  static const Color liveIndicator = Colors.red;
  static const Color iconGrey = Colors.grey;
  static const Color dividerGrey = Color(0xFFE5E7EB);
}

class AppTextStyles {
  // Poppins Bold
  static const TextStyle poppinsBold24 = TextStyle(
    fontFamily: 'Poppins Bold',
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle poppinsBold28 = TextStyle(
    fontFamily: 'Poppins Bold',
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle poppinsBold36 = TextStyle(
    fontFamily: 'Poppins Bold',
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  // Poppins SemiBold
  static const TextStyle poppinsSemiBold18 = TextStyle(
    fontFamily: 'Poppins SemiBold',
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle poppinsSemiBold15 = TextStyle(
    fontFamily: 'Poppins SemiBold',
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle poppinsSemiBold13 = TextStyle(
    fontFamily: 'Poppins SemiBold',
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );

  // Poppins Regular
  static const TextStyle poppinsRegular16 = TextStyle(
    fontFamily: 'Poppins Regular',
    fontSize: 14,
  );

  static const TextStyle poppinsRegular15 = TextStyle(
    fontFamily: 'Poppins Regular',
    fontSize: 13,
  );

  // Poppins Medium
  static const TextStyle poppinsMedium18 = TextStyle(
    fontFamily: 'Poppins Medium',
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  // App specific
  static TextStyle welcomeBack = poppinsBold28.copyWith(
    color: AppColors.textPrimary,
  );
  static TextStyle loginSubtitle = poppinsRegular16.copyWith(
    color: AppColors.textSecondary,
  );
  static TextStyle subtitle = poppinsRegular16.copyWith(
    color: AppColors.textSecondary,
  );
  static TextStyle buttonText = poppinsSemiBold18.copyWith(color: Colors.white);

  

  // ========== SCREEN HEADERS ==========
  static TextStyle headerTitle = poppinsBold24.copyWith(
    fontSize: 18,
    color: AppColors.textDark,
  );
  
  static TextStyle headerSubtitle = poppinsRegular16.copyWith(
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  // ========== SECTION TITLES ==========
  static TextStyle sectionTitle = poppinsSemiBold18.copyWith(
    fontSize: 14,
    color: AppColors.textDark,
  );

  // ========== CARD CONTENT ==========
  static TextStyle cardTitle = poppinsSemiBold15.copyWith(
    fontSize: 12,
    color: AppColors.textDark,
  );
  
  static TextStyle cardSubtitle = poppinsRegular15.copyWith(
    fontSize: 11,
    color: AppColors.textSecondary,
  );
  
  static TextStyle cardValue = poppinsSemiBold18.copyWith(
    fontSize: 14,
    color: AppColors.textDark,
  );

  // ========== MENU ITEMS ==========
  static TextStyle menuItemTitle = poppinsMedium18.copyWith(
    fontSize: 14,
    color: AppColors.textDark,
  );
  
  static TextStyle menuItemSubtitle = poppinsRegular15.copyWith(
    fontSize: 10,
    color: AppColors.textSecondary,
  );

  // ========== LABELS & CAPTIONS ==========
  static TextStyle labelText = poppinsRegular15.copyWith(
    fontSize: 11,
    color: AppColors.textSecondary,
  );
  
  static TextStyle captionText = poppinsRegular15.copyWith(
    fontSize: 10,
    color: AppColors.textLight,
  );

  // ========== AMOUNTS & NUMBERS ==========
  static TextStyle amountLarge = poppinsBold28.copyWith(
    fontSize: 24,
    color: AppColors.textDark,
  );
  
  static TextStyle amountMedium = poppinsBold24.copyWith(
    fontSize: 18,
    color: AppColors.textDark,
  );
  
  static TextStyle amountSmall = poppinsSemiBold15.copyWith(
    fontSize: 14,
    color: AppColors.textDark,
  );
}

/// Light theme configuration
ThemeData getLightTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: LightColors.background,
    fontFamily: 'Poppins Regular',

    colorScheme: ColorScheme.light(
      primary: LightColors.primary,
      secondary: LightColors.brandGold,
      surface: LightColors.surface,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: LightColors.foreground,
      onError: Colors.white,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: LightColors.background,
      foregroundColor: LightColors.textPrimary,
      elevation: 0,
      titleTextStyle: AppTextStyles.poppinsSemiBold18.copyWith(
        color: LightColors.textPrimary,
      ),
      iconTheme: IconThemeData(color: LightColors.textPrimary),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: LightColors.primary,
        foregroundColor: Colors.white,
        textStyle: AppTextStyles.buttonText,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: LightColors.primary,
        textStyle: AppTextStyles.poppinsSemiBold18,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: LightColors.inputBackground,
      labelStyle: TextStyle(
        color: LightColors.textSecondary,
        fontFamily: 'Poppins Regular',
      ),
      hintStyle: TextStyle(
        color: LightColors.textLight,
        fontFamily: 'Poppins Regular',
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: LightColors.line, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: LightColors.primary, width: 1),
      ),
      prefixIconColor: LightColors.iconGrey,
      suffixIconColor: LightColors.iconGrey,
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: LightColors.surface,
      selectedItemColor: LightColors.primary,
      unselectedItemColor: LightColors.iconGrey,
      selectedLabelStyle: AppTextStyles.poppinsSemiBold13.copyWith(fontSize: 15),
      unselectedLabelStyle: AppTextStyles.poppinsSemiBold13,
    ),

    cardTheme: CardThemeData(
      color: LightColors.surface,
      shadowColor: LightColors.cardShadow,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    dividerTheme: DividerThemeData(
      color: LightColors.dividerGrey,
      thickness: 1,
    ),

    iconTheme: IconThemeData(
      color: LightColors.iconGrey,
    ),

    textTheme: _buildTextTheme(isLight: true),
  );
}

/// Dark theme configuration
ThemeData getDarkTheme() {
  final ColorScheme darkScheme = ColorScheme.fromSeed(
    seedColor: DarkColors.primary,
    brightness: Brightness.dark,
    primary: DarkColors.primary,
    onPrimary: Colors.white,
    secondary: DarkColors.brandGold,
    onSecondary: Color(0xFF0B101A),
    background: DarkColors.background,
    onBackground: DarkColors.foreground,
    surface: DarkColors.surface,
    onSurface: DarkColors.foreground,
    surfaceVariant: DarkColors.surfaceElevated,
    onSurfaceVariant: DarkColors.textSecondary,
    tertiary: DarkColors.brandGold,
    onTertiary: Color(0xFF0B101A),
    outline: DarkColors.line,
    outlineVariant: DarkColors.dividerGrey,
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: DarkColors.foreground,
    onInverseSurface: DarkColors.background,
    inversePrimary: DarkColors.primaryDark,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkScheme.surface,
    fontFamily: 'Poppins Regular',

    colorScheme: darkScheme,

    appBarTheme: AppBarTheme(
      backgroundColor: darkScheme.surface,
      foregroundColor: darkScheme.onSurface,
      elevation: 0,
      titleTextStyle: AppTextStyles.poppinsSemiBold18.copyWith(
        color: darkScheme.onSurface,
      ),
      iconTheme: IconThemeData(color: darkScheme.onSurface),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkScheme.primary,
        foregroundColor: darkScheme.onPrimary,
        textStyle: AppTextStyles.buttonText,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: darkScheme.primary,
        textStyle: AppTextStyles.poppinsSemiBold18,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: DarkColors.inputBackground,
      labelStyle: TextStyle(
        color: DarkColors.textSecondary,
        fontFamily: 'Poppins Regular',
      ),
      hintStyle: TextStyle(
        color: DarkColors.textLight,
        fontFamily: 'Poppins Regular',
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: darkScheme.outline, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: darkScheme.primary, width: 1),
      ),
      prefixIconColor: DarkColors.iconGrey,
      suffixIconColor: DarkColors.iconGrey,
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: darkScheme.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: DarkColors.iconGrey,
      selectedLabelStyle: AppTextStyles.poppinsSemiBold13.copyWith(fontSize: 15),
      unselectedLabelStyle: AppTextStyles.poppinsSemiBold13,
    ),

    cardTheme: CardThemeData(
      color: DarkColors.surfaceElevated,
      shadowColor: DarkColors.cardShadow,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    dividerTheme: DividerThemeData(
      color: darkScheme.outlineVariant,
      thickness: 1,
    ),

    iconTheme: IconThemeData(
      color: DarkColors.iconGrey,
    ),

    textTheme: _buildTextTheme(isLight: false),
  );
}

/// Build text theme based on brightness
TextTheme _buildTextTheme({required bool isLight}) {
  final textColor = isLight ? LightColors.textPrimary : DarkColors.textPrimary;
  final secondaryColor = isLight ? LightColors.textSecondary : DarkColors.textSecondary;

  return TextTheme(
    displayLarge: AppTextStyles.poppinsBold36.copyWith(color: textColor),
    displayMedium: AppTextStyles.poppinsBold28.copyWith(color: textColor),
    displaySmall: AppTextStyles.poppinsBold24.copyWith(color: textColor),
    headlineMedium: AppTextStyles.poppinsSemiBold18.copyWith(color: textColor),
    titleLarge: AppTextStyles.poppinsSemiBold18.copyWith(color: textColor),
    titleMedium: AppTextStyles.poppinsSemiBold15.copyWith(color: textColor),
    titleSmall: AppTextStyles.poppinsSemiBold13.copyWith(color: textColor),
    bodyLarge: AppTextStyles.poppinsRegular16.copyWith(color: textColor),
    bodyMedium: AppTextStyles.poppinsRegular15.copyWith(color: textColor),
    labelLarge: AppTextStyles.poppinsMedium18.copyWith(color: textColor),
    bodySmall: AppTextStyles.poppinsRegular15.copyWith(color: secondaryColor, fontSize: 12),
  );
}

/// Legacy function for backwards compatibility
ThemeData getApplicationTheme() {
  return getLightTheme();
}
