// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_textstyle.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColorLight,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: Colors.white,
    primaryColor: AppColors.primaryColorLight,
    appBarTheme: AppBarTheme(
      color: AppColors.primaryColorLight,
      iconTheme: const IconThemeData(color: AppColors.iconColor),
      titleTextStyle: AppTextStyles.titleText.copyWith(
        color: AppColors.iconColor,
      ),
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyles.titleText.copyWith(
        color: AppColors.primaryTextColorLight,
      ),
      titleLarge: AppTextStyles.subtitleText.copyWith(
        color: AppColors.secondaryTextColorLight,
      ),
      bodyMedium: AppTextStyles.bodyText.copyWith(
        color: AppColors.bodyTextColorLight,
      ),
      labelLarge: AppTextStyles.buttonText,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.buttonColorLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

  static final darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColorDark,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    primaryColor: AppColors.primaryColorDark,
    appBarTheme: AppBarTheme(
      color: AppColors.primaryColorDark,
      iconTheme: IconThemeData(color: AppColors.iconColor),
      titleTextStyle: AppTextStyles.titleText.copyWith(
        color: AppColors.iconColor,
      ),
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyles.titleText.copyWith(
        color: AppColors.primaryTextColorDark,
      ),
      titleLarge: AppTextStyles.subtitleText.copyWith(
        color: AppColors.secondaryTextColorDark,
      ),
      bodyMedium: AppTextStyles.bodyText.copyWith(
        color: AppColors.bodyTextColorDark,
      ),
      labelLarge: AppTextStyles.buttonText,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.buttonColorDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
