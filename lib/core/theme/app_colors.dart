import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1A237E); // Deep Navy
  static const Color primaryDark = Color(0xFF0D1248);
  static const Color primaryLight = Color(0xFF534BAE);
  
  static const Color accent = Color(0xFF00BFA5); // Teal safety
  static const Color accentDark = Color(0xFF008E76);
  static const Color accentLight = Color(0xFF5DF2D6);
  
  static const Color danger = Color(0xFFD32F2F); // Scam alert red
  static const Color warning = Color(0xFFFFA000); // Suspicious yellow
  static const Color safe = Color(0xFF2E7D32); // Legitimate green
  
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color surfaceLight = Colors.white;
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);
  
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color textPrimaryDark = Color(0xFFEEEEEE);
  static const Color textSecondaryDark = Color(0xFFAAAAAA);
  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF283593)],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  static const LinearGradient dangerGradient = LinearGradient(
    colors: [Color(0xFFD32F2F), Color(0xFFC2185B)],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  static const LinearGradient safeGradient = LinearGradient(
    colors: [Color(0xFF2E7D32), Color(0xFF00BFA5)],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );
}
