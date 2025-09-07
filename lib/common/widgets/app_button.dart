import 'package:flutter/material.dart';

enum _AppButtonVariant { primary, tonal, outlined, text }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool fullWidth;
  final IconData? leadingIcon;
  final _AppButtonVariant _variant;

  const AppButton._internal({
    required this.label,
    required this.onPressed,
    required this.loading,
    required this.fullWidth,
    required _AppButtonVariant variant,
    this.leadingIcon,
    super.key,
  }) : _variant = variant;

  const AppButton.primary({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool loading = false,
    bool fullWidth = true,
    IconData? leadingIcon,
  }) : this._internal(
         key: key,
         label: label,
         onPressed: onPressed,
         loading: loading,
         fullWidth: fullWidth,
         variant: _AppButtonVariant.primary,
         leadingIcon: leadingIcon,
       );

  const AppButton.tonal({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool loading = false,
    bool fullWidth = true,
    IconData? leadingIcon,
  }) : this._internal(
         key: key,
         label: label,
         onPressed: onPressed,
         loading: loading,
         fullWidth: fullWidth,
         variant: _AppButtonVariant.tonal,
         leadingIcon: leadingIcon,
       );

  const AppButton.outlined({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool loading = false,
    bool fullWidth = true,
    IconData? leadingIcon,
  }) : this._internal(
         key: key,
         label: label,
         onPressed: onPressed,
         loading: loading,
         fullWidth: fullWidth,
         variant: _AppButtonVariant.outlined,
         leadingIcon: leadingIcon,
       );

  const AppButton.text({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool loading = false,
    bool fullWidth = false,
    IconData? leadingIcon,
  }) : this._internal(
         key: key,
         label: label,
         onPressed: onPressed,
         loading: loading,
         fullWidth: fullWidth,
         variant: _AppButtonVariant.text,
         leadingIcon: leadingIcon,
       );

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final child = _buildChild(colorScheme);
    final button = switch (_variant) {
      _AppButtonVariant.primary => FilledButton(
        onPressed: _effectiveOnPressed,
        child: child,
      ),
      _AppButtonVariant.tonal => FilledButton.tonal(
        onPressed: _effectiveOnPressed,
        child: child,
      ),
      _AppButtonVariant.outlined => OutlinedButton(
        onPressed: _effectiveOnPressed,
        child: child,
      ),
      _AppButtonVariant.text => TextButton(
        onPressed: _effectiveOnPressed,
        child: child,
      ),
    };
    if (fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }

  VoidCallback? get _effectiveOnPressed => loading ? null : onPressed;

  Widget _buildChild(ColorScheme scheme) {
    if (loading) {
      final spinnerColor = switch (_variant) {
        _AppButtonVariant.primary => scheme.onPrimary,
        _AppButtonVariant.tonal => scheme.onSecondaryContainer,
        _AppButtonVariant.outlined => scheme.primary,
        _AppButtonVariant.text => scheme.primary,
      };
      return SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(spinnerColor),
        ),
      );
    }

    final labelWidget = Text(label);
    if (leadingIcon == null) return labelWidget;
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(leadingIcon, size: 20),
        const SizedBox(width: 8),
        labelWidget,
      ],
    );
  }
}
