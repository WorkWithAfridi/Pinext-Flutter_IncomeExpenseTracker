import 'package:flutter/material.dart';

import 'colors.dart';

class PinextTheme {
  static ThemeData lightTheme = ThemeData.light().copyWith(
    visualDensity: VisualDensity.compact,
    primaryColor: customBlueColor,
    scaffoldBackgroundColor: whiteColor,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: customBlueColor,
      onPrimary: whiteColor,
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
