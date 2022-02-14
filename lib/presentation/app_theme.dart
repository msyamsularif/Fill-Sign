import 'package:flutter/material.dart';

class AppTheme {
  static Color primaryColor = const Color(0xFFF8FBFF);
  static Color secoundColor = const Color(0xFF7E56C1);

  static ThemeData themeData = ThemeData(
    appBarTheme: AppBarTheme(
      color: AppTheme.secoundColor,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      iconTheme: const IconThemeData(color: Colors.white, size: 16),
    ),
    colorScheme: const ColorScheme(
      primary: Color(0xFFF8FBFF),
      primaryVariant: Color(0xFFF8FBFF),
      secondary: Color(0xFF7E56C1),
      secondaryVariant: Color(0xFF7E56C1),
      surface: Color(0xFFF8FBFF),
      background: Color(0xFFF8FBFF),
      error: Colors.red,
      onPrimary: Color(0xFFF8FBFF),
      onSecondary: Color(0xFF7E56C1),
      onSurface: Color(0xFFF8FBFF),
      onBackground: Color(0xFFF8FBFF),
      onError: Colors.red,
      brightness: Brightness.light,
    ),
  );
}
