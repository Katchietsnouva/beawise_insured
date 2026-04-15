import 'package:flutter/material.dart';
import 'package:insured/app_1/core/constants/app_colors.dart';
import 'package:insured/app_1/core/constants/app_dimens.dart';
// import 'app_colors.dart';
import 'text_styles.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.transparent,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accentGreen,
      secondary: AppColors.accentGreen,
      surface: AppColors.glassWhite,
      background: AppColors.gradientStart,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyles.headline1,
      displayMedium: TextStyles.headline2,
      bodyLarge: TextStyles.body1,
      bodyMedium: TextStyles.body2,
      labelLarge: TextStyles.button,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: AppColors.glassWhite,
      hintStyle: TextStyles.body2.copyWith(color: AppColors.textSecondary),
      labelStyle: TextStyles.body2.copyWith(color: AppColors.textSecondary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accentGreen,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(AppDimens.buttonHeight),
        shape: const StadiumBorder(),
        textStyle: TextStyles.button,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white, width: 1.5),
        minimumSize: const Size.fromHeight(AppDimens.buttonHeight),
        shape: const StadiumBorder(),
        textStyle: TextStyles.button,
      ),
    ),
  );
}
