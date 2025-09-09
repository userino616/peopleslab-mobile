import 'package:flutter/material.dart';
import 'package:peopleslab/core/theme/app_colors.dart';

class AppTheme {
  AppTheme._();

  static const double _radius = 12;

  static TextTheme _textTheme(ColorScheme colors) {
    const font = 'Roboto';
    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: font,
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: colors.onSurface,
      ),
      displayMedium: TextStyle(
        fontFamily: font,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: colors.onSurface,
      ),
      displaySmall: TextStyle(
        fontFamily: font,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: colors.onSurface,
      ),
      headlineMedium: TextStyle(
        fontFamily: font,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: colors.onSurface,
      ),
      headlineSmall: TextStyle(
        fontFamily: font,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: colors.onSurface,
      ),
      titleLarge: TextStyle(
        fontFamily: font,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: colors.onSurface,
      ),
      titleMedium: TextStyle(
        fontFamily: font,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: colors.onSurface,
      ),
      titleSmall: TextStyle(
        fontFamily: font,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: colors.onSurface,
      ),
      bodyLarge: TextStyle(
        fontFamily: font,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: colors.onSurface,
      ),
      bodyMedium: TextStyle(
        fontFamily: font,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: colors.onSurface,
      ),
      bodySmall: TextStyle(
        fontFamily: font,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: colors.onSurfaceVariant,
      ),
      labelLarge: TextStyle(
        fontFamily: font,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: colors.onPrimary,
      ),
      labelMedium: TextStyle(
        fontFamily: font,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: colors.onSurface,
      ),
      labelSmall: TextStyle(
        fontFamily: font,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: colors.onSurfaceVariant,
      ),
    );
  }

  static ThemeData _theme(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
    ).copyWith(secondary: AppColors.secondary);

    final textTheme = _textTheme(scheme);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        elevation: 1,
        margin: EdgeInsets.zero,
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceVariant.withOpacity(0.5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: scheme.onSurfaceVariant),
        prefixIconColor: scheme.onSurfaceVariant,
        suffixIconColor: scheme.onSurfaceVariant,
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 56,
        backgroundColor: scheme.surface,
        indicatorColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? scheme.primary : scheme.onSurfaceVariant,
            size: selected ? 26 : 24,
          );
        }),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size.fromHeight(48)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radius)),
          ),
          textStyle: WidgetStatePropertyAll(
            textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size.fromHeight(48)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radius)),
          ),
          side: WidgetStatePropertyAll(
            BorderSide(color: scheme.outlineVariant),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radius - 4)),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        side: BorderSide.none,
        selectedColor: scheme.primary.withOpacity(0.12),
        backgroundColor: scheme.surfaceVariant.withOpacity(0.6),
        labelStyle: TextStyle(color: scheme.onSurface),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius * 1.5),
        ),
      ),
    );
  }

  static ThemeData light() => _theme(Brightness.light);

  static ThemeData dark() => _theme(Brightness.dark);
}
