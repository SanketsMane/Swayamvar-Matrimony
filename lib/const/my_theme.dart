import 'package:flutter/material.dart';

class MyTheme {
  // Sanket: New Design System 2026
  static const Color primary = Color(0xFFE54861);
  static const Color primary_dark = Color(0xFFC63C52);
  static const Color background = Color(0xFFF9FAFB);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  
  static const Color text_primary = Color(0xFF1A1A1A);
  static const Color text_secondary = Color(0xFF6B7280);
  
  static const Color border = Color(0xFFECECEC);
  static const Color success = Color(0xFF22C55E);
  static const Color failure = Color(0xFFD94D4B);

  // Legacy compatibility (re-mapping to new system)
  static const Color app_accent_color = primary;
  static Color solitude = background;
  static Color zircon = border;
  static Color light_grey = text_secondary;
  static Color arsenic = text_primary;
  static Color storm_grey = text_secondary;
  static Color gull_grey = text_secondary;
  static Color grey_153 = text_secondary;
  static Color warm_rose = primary;
  static Color text_deep_maroon = text_primary;
  static Color icon_premium_color = primary;
  static Color medium_sea_green = success;
  static Color very_light_grey = border;
  static Color luxury_gold = primary;
  static Color silver = const Color(0xFFC0C0C0);
  
  // Progress bar colors (using system colors)
  static Color light_sea_green = const Color(0xFF17B8A8);
  static Color green = success;
  
  static Color gradient_color_1 = primary;
  static Color gradient_color_2 = const Color(0xFFFF8B8B); // Soft variation for gradient
}
