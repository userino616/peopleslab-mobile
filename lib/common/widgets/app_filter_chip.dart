import 'package:flutter/material.dart';
import 'package:peopleslab/core/theme/design_tokens.dart';

class AppFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onPressed;
  final IconData? icon;

  const AppFilterChip({
    super.key,
    required this.label,
    required this.selected,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = selected ? AppPalette.mint : scheme.surface;
    final textColor = selected ? AppPalette.n700 : scheme.onSurface;
    final border = scheme.outlineVariant;

    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: textColor),
          const SizedBox(width: 6),
        ],
        Text(
          label,
          style: TextStyle(
            fontSize: AppTextScale.secondary,
            height: 20 / AppTextScale.secondary,
            color: textColor,
          ),
        ),
      ],
    );

    return AnimatedContainer(
      duration: AppDurations.color,
      curve: AppCurves.standard,
      decoration: ShapeDecoration(
        color: bg,
        shape: StadiumBorder(side: BorderSide(color: border)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const StadiumBorder(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 32),
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }
}
