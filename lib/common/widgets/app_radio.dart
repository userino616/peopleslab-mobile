import 'package:flutter/material.dart';
import 'package:peopleslab/core/theme/design_tokens.dart';

class AppRadio<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;
  final String? label;
  final bool disabled;
  final EdgeInsetsGeometry? padding;

  const AppRadio({
    super.key,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.label,
    this.disabled = false,
    this.padding,
  });

  bool get selected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    final canTap = onChanged != null && !disabled;
    final dot = _Dot(selected: selected, disabled: disabled);
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        dot,
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
        borderRadius: BorderRadius.circular(12),
        onTap: canTap ? () => onChanged!(value) : null,
        child: content,
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final bool selected;
  final bool disabled;
  const _Dot({required this.selected, required this.disabled});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fill = selected ? scheme.primary : Colors.transparent;
    final border = selected ? scheme.primary : AppPalette.n300;

    return AnimatedContainer(
      duration: AppDurations.medium,
      curve: AppCurves.standard,
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: disabled ? scheme.surfaceVariant : fill,
        shape: BoxShape.circle,
        border: Border.all(
          color: disabled ? scheme.outlineVariant : border,
          width: 1.5,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }
}

