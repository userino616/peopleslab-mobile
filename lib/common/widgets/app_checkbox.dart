import 'package:flutter/material.dart';
import 'package:peopleslab/core/theme/design_tokens.dart';

class AppCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool disabled;
  final String? label;
  final EdgeInsetsGeometry? padding;

  const AppCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.disabled = false,
    this.label,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final canTap = onChanged != null && !disabled;
    final box = _Box(value: value, disabled: disabled);
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        box,
        if (label != null) ...[
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label!,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: disabled
                        ? Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant
                            .withOpacity(0.7)
                        : null,
                  ),
            ),
          ),
        ],
      ],
    );

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: canTap ? () => onChanged!(!value) : null,
        child: content,
      ),
    );
  }
}

class _Box extends StatelessWidget {
  final bool value;
  final bool disabled;
  const _Box({required this.value, required this.disabled});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = value
        ? scheme.primary
        : Colors.transparent;
    final border = value
        ? scheme.primary
        : AppPalette.n300;

    return AnimatedContainer(
      duration: AppDurations.medium,
      curve: AppCurves.standard,
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: disabled ? scheme.surfaceVariant : bg,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: disabled ? scheme.outlineVariant : border,
          width: 1.5,
        ),
      ),
      child: value
          ? const Icon(
              Icons.check_rounded,
              size: 14,
              color: Colors.white,
            )
          : null,
    );
  }
}

