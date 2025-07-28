import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  /// Dark theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.darkBackground,
    primaryColor: AppColors.primary,
    fontFamily: 'Poppins',

    textTheme: AppTextStyles.textTheme.apply(
      bodyColor: AppColors.darkText,
      displayColor: AppColors.darkText,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.darkText),
    ),

    cardTheme: const CardThemeData(
      color: AppColors.darkSurface,
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      surface: AppColors.darkSurface,
    ).copyWith(error: AppColors.error),

    iconTheme: const IconThemeData(color: AppColors.darkText),
    dividerTheme: const DividerThemeData(color: Colors.white24, thickness: 1),
    listTileTheme: const ListTileThemeData(
      iconColor: AppColors.darkText,
      textColor: AppColors.darkText,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        textStyle: AppTextStyles.buttonLarge,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: true,
      fillColor: AppColors.darkSurface,
      errorStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
      hintStyle: AppTextStyles.faded.copyWith(color: AppColors.darkText.withOpacity(0.6)),
      labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.darkText),
    ),
  );

  /// Light theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    fontFamily: 'Poppins',

    textTheme: AppTextStyles.textTheme.apply(
      bodyColor: AppColors.text,
      displayColor: AppColors.text,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.text),
    ),

    cardTheme: const CardThemeData(
      color: AppColors.white,
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ), 

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.background,
    ).copyWith(error: AppColors.error),

    iconTheme: const IconThemeData(color: AppColors.text),
    dividerTheme: const DividerThemeData(color: Colors.black12, thickness: 1),
    listTileTheme: const ListTileThemeData(
      iconColor: AppColors.text,
      textColor: AppColors.text,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        textStyle: AppTextStyles.buttonLarge,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: AppColors.white,
      errorStyle: const TextStyle(
        fontFamily: 'Poppins',
        color: AppColors.error,
        fontSize: 13,
      ),
      hintStyle: const TextStyle(
        color: AppColors.grey,
        fontFamily: 'Poppins',
      ),
      labelStyle: const TextStyle(
        color: AppColors.text,
        fontFamily: 'Poppins',
      ),
    ),
  );
}
