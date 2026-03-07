import 'package:flutter/material.dart';

class AppColors {
  // --- INTERNAL PALETTES (2026 Minimal) ---
  static const Color bluePrimary = Color(0xFF2563EB); // Primary Blue
  static const Color bgLight = Color(0xFFF8FAFC);    // Light Slate Background
  static const Color surfaceLight = Colors.white;

  // Renamed constants to avoid name conflict with context-based methods
  static const Color _textPrimaryBase = Color(0xFF0F172A);   // Midnight Slate
  static const Color _textSecondaryBase = Color(0xFF64748B); // Slate-500

  // --- BRANDING & STATUS (2026 Minimal) ---
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color info = Color(0xFF0EA5E9); // Added missing info color

  // Legacy/Branding colors for specific components
  static const Color swayamvarRed = Color(0xFFE11D48);

  // Gradient for legacy components
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [bluePrimary, Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // --- DYNAMIC ACCESSORS ---
  static bool _isDark(BuildContext context) => Theme.of(context).brightness == Brightness.dark;

  static Color background(BuildContext context) => _isDark(context) ? const Color(0xFF0F172A) : bgLight;
  static Color surface(BuildContext context) => _isDark(context) ? const Color(0xFF1E293B) : surfaceLight;
  static Color primary(BuildContext context) => bluePrimary;
  static Color accent(BuildContext context) => bluePrimary;

  // Restored methods with context to fix 'call' errors in existing screens
  static Color textPrimary(BuildContext context) => _isDark(context) ? Colors.white : _textPrimaryBase;
  static Color textSecondary(BuildContext context) => _isDark(context) ? Colors.white70 : _textSecondaryBase;

  // Keep these for newer code if preferred
  static Color textPrimaryColor(BuildContext context) => textPrimary(context);
  static Color textSecondaryColor(BuildContext context) => textSecondary(context);
}
// Sanket

class AppConfig {
  static const String appName = 'Swayamvar Telecalling';
  static const String baseUrl = 'https://swayamvarmatrimony.in/api';

  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
}
// Sanket
