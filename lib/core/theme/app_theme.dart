import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopleslab/core/theme/design_tokens.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final colorScheme = _lightScheme();

    final text = _textTheme(colorScheme, Brightness.light);
    final manrope = GoogleFonts.manropeTextTheme(text);
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppPalette.n100,
      textTheme: manrope,
      extensions: const [ExtraColors.light()],
      navigationBarTheme: NavigationBarThemeData(
        height: 56,
        backgroundColor: colorScheme.surface,
        indicatorColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
            size: selected ? 26 : 24,
          );
        }),
        // No labels are shown; text styles are not needed
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: ZoomPageTransitionsBuilder(),
          TargetPlatform.windows: ZoomPageTransitionsBuilder(),
        },
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: _inputTheme(colorScheme),
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        side: BorderSide(color: colorScheme.outlineVariant),
        selectedColor: AppPalette.sky,
        backgroundColor: colorScheme.surface,
        labelStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: AppTextScale.secondary,
          height: 20 / AppTextScale.secondary,
        ),
        secondaryLabelStyle: TextStyle(color: colorScheme.onPrimary),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.pill),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: const IconThemeData(size: 26),
        unselectedIconTheme: const IconThemeData(size: 24),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size.fromHeight(48)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.control),
            ),
          ),
          animationDuration: AppDurations.medium,
          splashFactory: InkSparkle.splashFactory,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size.fromHeight(48)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.control),
            ),
          ),
          side: WidgetStatePropertyAll(
            BorderSide(color: colorScheme.outlineVariant),
          ),
          animationDuration: AppDurations.medium,
          splashFactory: InkSparkle.splashFactory,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size.fromHeight(48)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.control),
            ),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.control),
            ),
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.control),
        ),
        selectedColor: colorScheme.primary,
        iconColor: colorScheme.onSurfaceVariant,
      ),
    );
  }

  static ThemeData dark() {
    final colorScheme = _darkScheme();
    final text = _textTheme(colorScheme, Brightness.dark);
    final manrope = GoogleFonts.manropeTextTheme(text);
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: manrope,
      extensions: const [ExtraColors.dark()],
      navigationBarTheme: NavigationBarThemeData(
        height: 56,
        backgroundColor: colorScheme.surface,
        indicatorColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
            size: selected ? 26 : 24,
          );
        }),
        // No labels are shown; text styles are not needed
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
          TargetPlatform.macOS: ZoomPageTransitionsBuilder(),
          TargetPlatform.linux: ZoomPageTransitionsBuilder(),
          TargetPlatform.windows: ZoomPageTransitionsBuilder(),
        },
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: _inputTheme(colorScheme),
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        side: BorderSide(color: colorScheme.outlineVariant),
        selectedColor: colorScheme.primary.withValues(alpha: 0.22),
        backgroundColor: colorScheme.surface,
        labelStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: AppTextScale.secondary,
          height: 20 / AppTextScale.secondary,
        ),
        secondaryLabelStyle: TextStyle(color: colorScheme.onPrimary),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.pill),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: const IconThemeData(size: 26),
        unselectedIconTheme: const IconThemeData(size: 24),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size.fromHeight(48)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.control),
            ),
          ),
          animationDuration: AppDurations.medium,
          splashFactory: InkSparkle.splashFactory,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size.fromHeight(48)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.control),
            ),
          ),
          side: WidgetStatePropertyAll(
            BorderSide(color: colorScheme.outlineVariant),
          ),
          animationDuration: AppDurations.medium,
          splashFactory: InkSparkle.splashFactory,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size.fromHeight(48)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.control),
            ),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.control),
            ),
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.control),
        ),
        selectedColor: colorScheme.primary,
        iconColor: colorScheme.onSurfaceVariant,
      ),
    );
  }

  static TextTheme _textTheme(ColorScheme scheme, Brightness brightness) {
    TextStyle base(Color color, double size, double height,
            [FontWeight weight = FontWeight.w400, double? ls]) =>
        TextStyle(
          color: color,
          fontSize: size,
          height: height / size,
          fontWeight: weight,
          fontFeatures: const [FontFeature.tabularFigures()],
          letterSpacing: ls,
        );

    final onSurface = brightness == Brightness.light
        ? AppPalette.n900
        : AppPalette.textDark;
    final onSurfaceSecondary = brightness == Brightness.light
        ? AppPalette.n700
        : AppPalette.textDark.withValues(alpha: 0.85);

    return TextTheme(
      displaySmall: base(onSurface, AppTextScale.display, 40, FontWeight.w700, -0.2),
      headlineLarge: base(onSurface, AppTextScale.h1, 36, FontWeight.w700, -0.1),
      headlineMedium: base(onSurface, AppTextScale.h2, 32, FontWeight.w700, -0.1),
      headlineSmall: base(onSurface, AppTextScale.h3, 28, FontWeight.w600, -0.05),
      titleLarge: base(onSurface, AppTextScale.title, 24, FontWeight.w700, -0.02),
      bodyLarge: base(onSurface, AppTextScale.body, 24, FontWeight.w400, 0.0),
      bodyMedium: base(
        onSurfaceSecondary,
        AppTextScale.secondary,
        20,
        FontWeight.w500,
        0.0,
      ),
      bodySmall: base(
        onSurfaceSecondary,
        AppTextScale.caption,
        16,
        FontWeight.w500,
        0.0,
      ),
      labelLarge: base(onSurface, 14, 20, FontWeight.w700, 0.1),
    );
  }

  static InputDecorationTheme _inputTheme(ColorScheme scheme) {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppPalette.n100,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      hintStyle: TextStyle(color: scheme.onSurfaceVariant),
      prefixIconColor: scheme.onSurfaceVariant,
      suffixIconColor: scheme.onSurfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.control),
        borderSide: const BorderSide(color: AppPalette.n200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.control),
        borderSide: const BorderSide(color: AppPalette.n200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.control),
        borderSide: const BorderSide(color: AppPalette.primary600, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.control),
        borderSide: const BorderSide(color: AppPalette.danger, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.control),
        borderSide: const BorderSide(color: AppPalette.danger, width: 1.5),
      ),
    );
  }

  static ColorScheme _lightScheme() {
    return ColorScheme(
      brightness: Brightness.light,
      primary: AppPalette.primary600,
      surfaceTint: AppPalette.primary600,
      onPrimary: AppPalette.white,
      primaryContainer: AppPalette.primary500.withValues(alpha: 0.2),
      onPrimaryContainer: AppPalette.primary700,
      secondary: AppPalette.primary500,
      onSecondary: AppPalette.white,
      secondaryContainer: AppPalette.mint,
      onSecondaryContainer: AppPalette.n700,
      tertiary: AppPalette.link,
      onTertiary: AppPalette.white,
      tertiaryContainer: AppPalette.lavender,
      onTertiaryContainer: AppPalette.n700,
      error: AppPalette.danger,
      onError: AppPalette.white,
      errorContainer: const Color(0xFFFFDAD6),
      onErrorContainer: const Color(0xFF410002),
      outline: AppPalette.n300,
      outlineVariant: AppPalette.n200,
      background: AppPalette.white,
      onBackground: AppPalette.n900,
      surface: AppPalette.white,
      onSurface: AppPalette.n900,
      surfaceVariant: AppPalette.n100,
      onSurfaceVariant: AppPalette.n700,
      inverseSurface: const Color(0xFF121212),
      onInverseSurface: AppPalette.white,
      inversePrimary: AppPalette.primary500,
      shadow: const Color(0xFF000000),
      scrim: const Color(0xFF000000),
    );
  }

  static ColorScheme _darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: AppPalette.primary500,
      surfaceTint: AppPalette.primary500,
      onPrimary: AppPalette.white,
      primaryContainer: Color(0xFF0E2C20),
      onPrimaryContainer: AppPalette.primary500,
      secondary: AppPalette.primary500,
      onSecondary: AppPalette.white,
      secondaryContainer: Color(0xFF0E2C20),
      onSecondaryContainer: AppPalette.white,
      tertiary: AppPalette.link,
      onTertiary: AppPalette.white,
      tertiaryContainer: Color(0xFF14283B),
      onTertiaryContainer: AppPalette.white,
      error: AppPalette.danger,
      onError: AppPalette.white,
      errorContainer: Color(0xFF8C1717),
      onErrorContainer: AppPalette.white,
      outline: AppPalette.borderDark,
      outlineVariant: AppPalette.borderDark,
      background: AppPalette.surfaceDark,
      onBackground: AppPalette.textDark,
      surface: AppPalette.cardDark,
      onSurface: AppPalette.textDark,
      surfaceVariant: Color(0xFF0E1524),
      onSurfaceVariant: Color(0xFFB9C2D0),
      inverseSurface: AppPalette.textDark,
      onInverseSurface: AppPalette.cardDark,
      inversePrimary: AppPalette.primary500,
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
    );
  }
}
