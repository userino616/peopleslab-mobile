import 'dart:ui';

import 'package:flutter/material.dart';

/// Design tokens: colors, spacing, radii, shadows, motion, typography scales, and fonts.
/// These are source-of-truth values used by the Theme and shared widgets.
class AppPalette {
  AppPalette._();

  // Primary (bold blue)
  static const Color primary700 = Color(0xFF1D4ED8); // Blue 700
  static const Color primary600 = Color(0xFF2563EB); // Blue 600
  static const Color primary500 = Color(0xFF3B82F6); // Blue 500

  // Secondary (vibrant green)
  static const Color secondary700 = Color(0xFF047857); // Green 700
  static const Color secondary600 = Color(0xFF059669); // Green 600
  static const Color secondary500 = Color(0xFF10B981); // Green 500

  // Accents / backgrounds
  static const Color mint = Color(0xFFDDF7EC); // legacy secondary (kept)
  static const Color sky = Color(0xFFE7F0FF); // pale blue selection bg
  static const Color lavender = Color(0xFFEEE8FF); // info bg
  static const Color sand = Color(0xFFFFF5CC); // receipt bg

  // Status
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFDC2626);
  static const Color link = Color(0xFF0EA5E9);

  // Neutrals (text/borders)
  static const Color n900 = Color(0xFF0F172A);
  static const Color n700 = Color(0xFF334155);
  static const Color n500 = Color(0xFF64748B);
  static const Color n300 = Color(0xFFCBD5E1);
  static const Color n200 = Color(0xFFE2E8F0);
  static const Color n100 = Color(0xFFF1F5F9);
  static const Color white = Color(0xFFFFFFFF);

  // Dark mode surfaces
  static const Color surfaceDark = Color(0xFF0B1220);
  static const Color cardDark = Color(0xFF111827);
  static const Color borderDark = Color(0xFF243244);
  static const Color textDark = Color(0xFFEEF2F7);
}

class AppSpacing {
  AppSpacing._();
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 40;
  static const double xxxl = 48;
}

class AppRadii {
  AppRadii._();
  static const double card = 20;
  static const double control = 12; // inputs/buttons
  static const double pill = 999; // chips
}

class AppShadows {
  AppShadows._();
  static const List<BoxShadow> elevation1 = [
    BoxShadow(
      offset: Offset(0, 2),
      blurRadius: 10,
      color: Color.fromRGBO(15, 23, 42, 0.06),
    ),
  ];
  static const List<BoxShadow> elevation2 = [
    BoxShadow(
      offset: Offset(0, 6),
      blurRadius: 24,
      color: Color.fromRGBO(15, 23, 42, 0.08),
    ),
  ];
}

class AppDurations {
  AppDurations._();
  static const Duration color = Duration(milliseconds: 120);
  static const Duration medium = Duration(milliseconds: 160);
  static const Duration long = Duration(milliseconds: 240);
}

class AppCurves {
  AppCurves._();
  static const Curve standard = Cubic(0.2, 0.8, 0.2, 1.0);
}

/// Extra brand/background colors not captured by Material ColorScheme.
class ExtraColors extends ThemeExtension<ExtraColors> {
  final Color mint;
  final Color lavender;
  final Color sand;

  const ExtraColors({
    required this.mint,
    required this.lavender,
    required this.sand,
  });

  const ExtraColors.light()
      : mint = AppPalette.mint,
        lavender = AppPalette.lavender,
        sand = AppPalette.sand;

  const ExtraColors.dark()
      : mint = const Color(0xFF0D3322), // tuned darker mint context
        lavender = const Color(0xFF2A2540),
        sand = const Color(0xFF3A3220);

  @override
  ThemeExtension<ExtraColors> copyWith({
    Color? mint,
    Color? lavender,
    Color? sand,
  }) => ExtraColors(
        mint: mint ?? this.mint,
        lavender: lavender ?? this.lavender,
        sand: sand ?? this.sand,
      );

  @override
  ThemeExtension<ExtraColors> lerp(ThemeExtension<ExtraColors>? other, double t) {
    if (other is! ExtraColors) return this;
    return ExtraColors(
      mint: Color.lerp(mint, other.mint, t)!,
      lavender: Color.lerp(lavender, other.lavender, t)!,
      sand: Color.lerp(sand, other.sand, t)!,
    );
  }
}

/// Typography scale (sizes only; weights set in the theme).
class AppTextScale {
  AppTextScale._();
  static const double display = 32; // 32/40
  static const double h1 = 28; // 28/36
  static const double h2 = 24; // 24/32
  static const double h3 = 20; // 20/28
  static const double title = 18; // 18/24
  static const double body = 16; // 16/24
  static const double secondary = 14; // 14/20
  static const double caption = 12; // 12/16
}

/// Font families used throughout the app.
class AppFonts {
  AppFonts._();
  static const String primary = 'Inter';
  static const String display = 'Poppins';
}
