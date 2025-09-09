import 'package:flutter/material.dart';

/// Centralized brand colors for the app.
class AppColors {
  AppColors._();

  // Brand palette: fresh emerald with warm accent.
  static const Color primary = Color(0xFF00A86B); // Emerald 600
  static const Color primaryDark = Color(0xFF00895A); // Darker emerald
  static const Color secondary = Color(0xFFFFB74D); // Amber 300

  // Supporting colors (kept minimal; rely on ColorScheme for variants).
  static const Color success = Color(0xFF16A34A); // Green 600
  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color error = Color(0xFFDC2626); // Red 600
}
