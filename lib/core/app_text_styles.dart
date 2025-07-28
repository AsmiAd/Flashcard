import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Remove static color hardcoding; rely on Theme

  static const TextStyle headingLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins',
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
  );

  static const faded = TextStyle(
    fontSize: 14,
    color: AppColors.grey,
    fontWeight: FontWeight.w400,
    fontFamily: 'Poppins',
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    fontFamily: 'Poppins',
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: 'Poppins',
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: 'Poppins',
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: 'Poppins',
  );

  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
    color: AppColors.white,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
    color: AppColors.white,
  );

  static const TextStyle cardFront = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins',
  );

  static const TextStyle cardBack = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    fontFamily: 'Poppins',
  );

  static final TextTheme textTheme = const TextTheme(
    displayLarge: headingLarge,
    displayMedium: headingMedium,
    displaySmall: headingSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: buttonLarge,
    labelSmall: buttonSmall,
    titleMedium: cardFront,
    titleSmall: cardBack,
  );
}
