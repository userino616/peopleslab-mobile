import 'package:flutter/material.dart';
import 'package:peopleslab/core/theme/design_tokens.dart';

enum AppTextFieldVariant { outline, filled, multiline }

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final bool success;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final AppTextFieldVariant variant;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.success = false,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines,
    this.prefixIcon,
    this.suffixIcon,
    this.variant = AppTextFieldVariant.outline,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final outline = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadii.control),
      borderSide: const BorderSide(color: AppPalette.n200),
    );

    final focused = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadii.control),
      borderSide: const BorderSide(color: AppPalette.primary600, width: 1.5),
    );

    final successBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadii.control),
      borderSide: const BorderSide(color: AppPalette.success, width: 1.5),
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadii.control),
      borderSide: const BorderSide(color: AppPalette.danger, width: 1.5),
    );

    final filled = variant == AppTextFieldVariant.filled ||
        variant == AppTextFieldVariant.multiline;
    final lines = switch (variant) {
      AppTextFieldVariant.multiline => (min: 1, max: 4),
      _ => (min: 1, max: 1),
    };

    final decoration = InputDecoration(
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: filled,
      fillColor: filled ? AppPalette.n100 : null,
      border: outline,
      enabledBorder: outline,
      focusedBorder: success ? successBorder : focused,
      errorBorder: errorBorder,
      focusedErrorBorder: errorBorder,
      helperStyle: TextStyle(
        fontSize: AppTextScale.caption,
        height: 16 / AppTextScale.caption,
        color: scheme.onSurfaceVariant,
      ),
      errorStyle: TextStyle(
        fontSize: AppTextScale.caption,
        height: 16 / AppTextScale.caption,
        color: scheme.error,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      minLines: maxLines ?? lines.min,
      maxLines: maxLines ?? lines.max,
      decoration: decoration,
    );
  }
}

