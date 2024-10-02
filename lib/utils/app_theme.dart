import 'package:flutter/material.dart';
import 'package:talk/utils/app_colors.dart';

class ChatAppThemes {
  static ThemeData coolTones() {
    return ThemeData(
      primaryColor: AppColors.kPrimaryColor,
      scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFF2C3E50)),
        bodyMedium: TextStyle(color: Color(0xFFB0BEC5)),
      ),
      buttonTheme: const ButtonThemeData(
        // buttonColor: Color(0xFF1E90FF),
        buttonColor: Color(0xFF4CAF50),
      ),
      colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFFFF6F61)),
    );
  }

  static ThemeData earthyMinimalism() {
    return ThemeData(
      primaryColor: const Color(0xFF4CAF50),
      scaffoldBackgroundColor: const Color(0xFFEAEAEA),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFF424242)),
        bodyMedium: TextStyle(color: Color(0xFFBDBDBD)),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Color(0xFF4CAF50),
      ),
      colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFFFFC107)),
    );
  }
}
