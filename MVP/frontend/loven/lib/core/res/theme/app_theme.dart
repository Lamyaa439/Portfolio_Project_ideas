import 'package:flutter/material.dart';
import 'app_colors.dart'; // Ensure you created this file with the hex codes

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Almarai', // Default for Arabic support
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryBlue,
        primary: AppColors.primaryBlue,
        secondary: AppColors.deepPurple,
        surface: AppColors.backgroundGrey,
      ),
      scaffoldBackgroundColor: Colors.white,
      textTheme: const TextTheme(
        displayLarge:
            TextStyle(fontFamily: 'PT Serif', fontWeight: FontWeight.bold),
        titleMedium:
            TextStyle(fontFamily: 'Almarai', fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(fontFamily: 'Almarai', fontSize: 16),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Almarai',
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: AppColors.primaryBlue,
      ),
    );
  }
}
