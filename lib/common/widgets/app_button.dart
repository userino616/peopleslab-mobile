import 'package:flutter/material.dart';
import 'package:peopleslab/common/widgets/tap_scale.dart';

enum _AppButtonVariant { primary, outlined, ghost, tonal, destructive }

enum AppButtonSize { large, medium, small }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool fullWidth;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final _AppButtonVariant _variant;
  final AppButtonSize size;

  const AppButton._internal({
    required this.label,
    required this.onPressed,
    required this.loading,
    required this.fullWidth,
    required _AppButtonVariant variant,
    this.leadingIcon,
    this.trailingIcon,
    this.size = AppButtonSize.large,
    super.key,
  }) : _variant = variant;

  // Primary (filled)
  const AppButton.primary({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool loading = false,
    bool fullWidth = true,
    AppButtonSize size = AppButtonSize.large,
    IconData? leadingIcon,
    IconData? trailingIcon,
  }) : this._internal(
          key: key,
          label: label,
          onPressed: onPressed,
          loading: loading,
          fullWidth: fullWidth,
          variant: _AppButtonVariant.primary,
          leadingIcon: leadingIcon,
          trailingIcon: trailingIcon,
          size: size,
        );

  // Secondary (outlined)
  const AppButton.outlined({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool loading = false,
    bool fullWidth = true,
    AppButtonSize size = AppButtonSize.large,
    IconData? leadingIcon,
    IconData? trailingIcon,
  }) : this._internal(
          key: key,
          label: label,
          onPressed: onPressed,
          loading: loading,
          fullWidth: fullWidth,
          variant: _AppButtonVariant.outlined,
          leadingIcon: leadingIcon,
          trailingIcon: trailingIcon,
          size: size,
        );

  // Tertiary (ghost)
  const AppButton.text({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool loading = false,
    bool fullWidth = false,
    AppButtonSize size = AppButtonSize.medium,
    IconData? leadingIcon,
    IconData? trailingIcon,
  }) : this._internal(
          key: key,
          label: label,
          onPressed: onPressed,
          loading: loading,
          fullWidth: fullWidth,
          variant: _AppButtonVariant.ghost,
          leadingIcon: leadingIcon,
          trailingIcon: trailingIcon,
          size: size,
        );

  // Tonal (kept for compatibility, used in Profile page for sign out etc.)
  const AppButton.tonal({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool loading = false,
    bool fullWidth = true,
    AppButtonSize size = AppButtonSize.large,
    IconData? leadingIcon,
    IconData? trailingIcon,
  }) : this._internal(
          key: key,
          label: label,
          onPressed: onPressed,
          loading: loading,
          fullWidth: fullWidth,
          variant: _AppButtonVariant.tonal,
          leadingIcon: leadingIcon,
          trailingIcon: trailingIcon,
          size: size,
        );

  // Destructive (red filled)
  const AppButton.destructive({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool loading = false,
    bool fullWidth = true,
    AppButtonSize size = AppButtonSize.large,
    IconData? leadingIcon,
    IconData? trailingIcon,
  }) : this._internal(
          key: key,
          label: label,
          onPressed: onPressed,
          loading: loading,
          fullWidth: fullWidth,
          variant: _AppButtonVariant.destructive,
          leadingIcon: leadingIcon,
          trailingIcon: trailingIcon,
          size: size,
        );

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final child = _buildChild(scheme);
    final style = _styleFor(context, scheme);

    final button = switch (_variant) {
      _AppButtonVariant.primary => FilledButton(
          onPressed: _effectiveOnPressed,
          style: style,
          child: child,
        ),
      _AppButtonVariant.tonal => FilledButton.tonal(
          onPressed: _effectiveOnPressed,
          style: style,
          child: child,
        ),
      _AppButtonVariant.outlined => OutlinedButton(
          onPressed: _effectiveOnPressed,
          style: style,
          child: child,
        ),
      _AppButtonVariant.ghost => TextButton(
          onPressed: _effectiveOnPressed,
          style: style,
          child: child,
        ),
      _AppButtonVariant.destructive => FilledButton(
          onPressed: _effectiveOnPressed,
          style: style,
          child: child,
        ),
    };

    final scaled = TapScale(child: button);
    if (fullWidth) {
      return SizedBox(width: double.infinity, child: scaled);
    }
    return scaled;
  }

  VoidCallback? get _effectiveOnPressed => loading ? null : onPressed;

  ButtonStyle _styleFor(BuildContext context, ColorScheme scheme) {
    // Sizes: L=48 (16px x padding), M=40 (14px), S=36 (12px)
    final (height, hPad) = switch (size) {
      AppButtonSize.large => (48.0, 16.0),
      AppButtonSize.medium => (40.0, 14.0),
      AppButtonSize.small => (36.0, 12.0),
    };

    Color background;
    Color foreground;
    Color? borderColor;

    switch (_variant) {
      case _AppButtonVariant.primary:
        background = scheme.primary;
        foreground = scheme.onPrimary;
        break;
      case _AppButtonVariant.tonal:
        background = scheme.secondaryContainer;
        foreground = scheme.onSecondaryContainer;
        break;
      case _AppButtonVariant.outlined:
        background = Colors.transparent;
        foreground = scheme.onSurface;
        borderColor = scheme.outlineVariant;
        break;
      case _AppButtonVariant.ghost:
        background = Colors.transparent;
        foreground = scheme.primary;
        break;
      case _AppButtonVariant.destructive:
        background = scheme.error;
        foreground = scheme.onError;
        break;
    }

    final overlay = (Color base) => base.withOpacity(0.08);

    return ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size.fromHeight(height)),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: hPad),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return scheme.onSurfaceVariant; // neutral 500 → 300-ish
        }
        return foreground;
      }),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          if (_variant == _AppButtonVariant.primary ||
              _variant == _AppButtonVariant.destructive ||
              _variant == _AppButtonVariant.tonal) {
            return scheme.surfaceVariant;
          }
          return Colors.transparent;
        }
        return background;
      }),
      side: WidgetStateProperty.resolveWith((states) {
        if (_variant != _AppButtonVariant.outlined) return null;
        final color = states.contains(WidgetState.disabled)
            ? scheme.outlineVariant
            : borderColor ?? scheme.outlineVariant;
        return BorderSide(color: color);
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return overlay(Colors.black);
        }
        return null;
      }),
    );
  }

  Widget _buildChild(ColorScheme scheme) {
    if (loading) {
      final spinnerColor = switch (_variant) {
        _AppButtonVariant.primary => scheme.onPrimary,
        _AppButtonVariant.tonal => scheme.onSecondaryContainer,
        _AppButtonVariant.outlined => scheme.primary,
        _AppButtonVariant.ghost => scheme.primary,
        _AppButtonVariant.destructive => scheme.onError,
      };
      return SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(spinnerColor),
        ),
      );
    }

    final labelWidget = Text(label);
    final leading = leadingIcon != null ? Icon(leadingIcon, size: 20) : null;
    final trailing = trailingIcon != null ? Icon(trailingIcon, size: 20) : null;

    if (leading == null && trailing == null) return labelWidget;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leading != null) ...[leading, const SizedBox(width: 8)],
        labelWidget,
        if (trailing != null) ...[const SizedBox(width: 8), trailing],
      ],
    );
  }
}
