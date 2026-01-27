import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFFE304C);
  static const Color primaryDark = Color(0xFFE74C3C);

  // Gradient Colors
  static const Color gradientYellow = Color(0xFFFCE043);
  static const Color gradientOrange = Color(0xFFFF5E62);
  static const Color splashGradientStart = Color(0xFFFFD300);
  static const Color splashGradientEnd = Color(0xFFFF8C00);

  // Text Colors
  static const Color textPrimary = Color(0xFF333333); 
  static const Color textSecondary = Color(0xFF777777); 
  static const Color textLight = Color(0xFF999999); 
  static const Color textDark = Color(0xFF000000); 

  // Background Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color inputBackground = Color(0xFFFFFFFF);
  static const Color cardShadow = Color(0xFFE0E0E0);

  // Other Colors
  static const Color liveIndicator = Colors.red;
  static const Color iconGrey = Colors.grey;
  static const Color dividerGrey = Color(0xFFE0E0E0);
}

class AppTextStyles {
  // Poppins Bold
  static const TextStyle poppinsBold24 = TextStyle(
    fontFamily: 'Poppins Bold',
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle poppinsBold28 = TextStyle(
    fontFamily: 'Poppins Bold',
    fontSize: 28,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle poppinsBold36 = TextStyle(
    fontFamily: 'Poppins Bold',
    fontSize: 36,
    fontWeight: FontWeight.bold,
  );

  // Poppins SemiBold
  static const TextStyle poppinsSemiBold18 = TextStyle(
    fontFamily: 'Poppins SemiBold',
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle poppinsSemiBold15 = TextStyle(
    fontFamily: 'Poppins SemiBold',
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle poppinsSemiBold13 = TextStyle(
    fontFamily: 'Poppins SemiBold',
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  // Poppins Regular
  static const TextStyle poppinsRegular16 = TextStyle(
    fontFamily: 'Poppins Regular',
    fontSize: 16,
  );

  static const TextStyle poppinsRegular15 = TextStyle(
    fontFamily: 'Poppins Regular',
    fontSize: 15,
  );

  // Poppins Medium
  static const TextStyle poppinsMedium18 = TextStyle(
    fontFamily: 'Poppins Medium',
    fontSize: 18,
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
    fontSize: 22,
    color: AppColors.textDark,
  );
  
  static TextStyle headerSubtitle = poppinsRegular16.copyWith(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  // ========== SECTION TITLES ==========
  static TextStyle sectionTitle = poppinsSemiBold18.copyWith(
    color: AppColors.textDark,
  );

  // ========== CARD CONTENT ==========
  static TextStyle cardTitle = poppinsSemiBold15.copyWith(
    color: AppColors.textDark,
  );
  
  static TextStyle cardSubtitle = poppinsRegular15.copyWith(
    fontSize: 13,
    color: AppColors.textSecondary,
  );
  
  static TextStyle cardValue = poppinsSemiBold18.copyWith(
    fontSize: 16,
    color: AppColors.textDark,
  );

  // ========== MENU ITEMS ==========
  static TextStyle menuItemTitle = poppinsMedium18.copyWith(
    fontSize: 16,
    color: AppColors.textDark,
  );
  
  static TextStyle menuItemSubtitle = poppinsRegular15.copyWith(
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  // ========== LABELS & CAPTIONS ==========
  static TextStyle labelText = poppinsRegular15.copyWith(
    fontSize: 12,
    color: AppColors.textSecondary,
  );
  
  static TextStyle captionText = poppinsRegular15.copyWith(
    fontSize: 11,
    color: AppColors.textLight,
  );

  // ========== AMOUNTS & NUMBERS ==========
  static TextStyle amountLarge = poppinsBold28.copyWith(
    fontSize: 32,
    color: AppColors.textDark,
  );
  
  static TextStyle amountMedium = poppinsBold24.copyWith(
    fontSize: 20,
    color: AppColors.textDark,
  );
  
  static TextStyle amountSmall = poppinsSemiBold15.copyWith(
    fontSize: 16,
    color: AppColors.textDark,
  );
}


ThemeData getApplicationTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: 'Poppins Regular',

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      titleTextStyle: AppTextStyles.poppinsSemiBold18,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        textStyle: AppTextStyles.buttonText,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTextStyles.poppinsSemiBold18,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputBackground,
      labelStyle: const TextStyle(
        color: Colors.grey,
        fontFamily: 'Poppins Regular',
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary, width: 1),
      ),
      prefixIconColor: AppColors.iconGrey,
      suffixIconColor: AppColors.iconGrey,
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: AppTextStyles.poppinsSemiBold13.copyWith(
        fontSize: 15,
      ),
      unselectedLabelStyle: AppTextStyles.poppinsSemiBold13,
    ),

    cardTheme: CardThemeData(
      color: AppColors.background,
      shadowColor: AppColors.cardShadow,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}
