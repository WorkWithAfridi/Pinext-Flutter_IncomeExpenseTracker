import 'package:flutter/material.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';

class PinextTheme {
  static ThemeData lightTheme = ThemeData.light().copyWith(
    visualDensity: VisualDensity.compact,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: whiteColor,
    chipTheme: const ChipThemeData(
      side: BorderSide.none,
      backgroundColor: whiteColor,
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: whiteColor,
      secondary: cyanColor,
      onSecondary: customBlackColor,
      error: Colors.red,
      onError: customBlackColor,
      surface: whiteColor,
      onSurface: customBlackColor,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      color: whiteColor,
      elevation: 0,
    ),
  );
}
