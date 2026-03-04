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
  static const Color solitude = background;
  static const Color zircon = border;
  static const Color light_grey = text_secondary;
  static const Color arsenic = text_primary;
  static const Color storm_grey = text_secondary;
  static const Color gull_grey = text_secondary;
  static const Color grey_153 = text_secondary;
  static const Color warm_rose = primary;
  static const Color text_deep_maroon = text_primary;
  static const Color icon_premium_color = primary;
  static const Color medium_sea_green = success;
  static const Color very_light_grey = border;
  static const Color luxury_gold = primary;
  static Color silver = const Color(0xFFC0C0C0);

  // Progress bar colors (using system colors)
  static const Color light_sea_green = Color(0xFF17B8A8);
  static const Color green = success;

  static const Color gradient_color_1 = primary;
  static const Color gradient_color_2 = Color(
    0xFFFF8B8B,
  ); // Soft variation for gradient
}
