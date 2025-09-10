import 'package:flutter/material.dart';
import 'package:peopleslab/core/theme/design_tokens.dart';

class AppLinearProgress extends StatelessWidget {
  final double value; // 0..1
  final String? label; // optional text like "63%"
  final Color? color;
  final Color? backgroundColor;

  const AppLinearProgress({
    super.key,
    required this.value,
    this.label,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = backgroundColor ?? AppPalette.n200;
    final fill = color ?? scheme.primary;
    final pct = value.clamp(0.0, 1.0);

    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 8,
              child: Stack(
                children: [
                  Container(color: bg),
                  AnimatedFractionallySizedBox(
                    duration: AppDurations.medium,
                    curve: AppCurves.standard,
                    widthFactor: pct,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            scheme.primary,
                            AppPalette.primary500,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (label != null) ...[
          const SizedBox(width: 8),
          Text(
            label!,
            style: TextStyle(
              fontSize: AppTextScale.secondary,
              height: 20 / AppTextScale.secondary,
              color: scheme.onSurface,
            ),
          ),
        ],
      ],
    );
  }
}
