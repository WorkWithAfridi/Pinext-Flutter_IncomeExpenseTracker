import 'package:flutter/material.dart';
import 'package:pinext/app/app_data/colors.dart';

class PinextTheme {
  static ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: customBlueColor,
    scaffoldBackgroundColor: whiteColor,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: customBlueColor,
      onPrimary: customBlackColor,
      secondary: cyanColor,
      onSecondary: customBlackColor,
      error: Colors.red,
      onError: customBlackColor,
      background: whiteColor,
      onBackground: customBlackColor,
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
