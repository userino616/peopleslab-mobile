import 'package:flutter/material.dart';
import 'package:peopleslab/core/theme/design_tokens.dart';

class AppCircularProgress extends StatelessWidget {
  final double value; // 0..1
  final double diameter; // outer diameter
  final double thickness; // stroke width
  final Widget? center;
  final Color? color;
  final Color? backgroundColor;

  const AppCircularProgress({
    super.key,
    required this.value,
    this.diameter = 72,
    this.thickness = 8,
    this.center,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = backgroundColor ?? AppPalette.n200;
    final fill = color ?? scheme.primary;
    final pct = value.clamp(0.0, 1.0);

    return SizedBox(
      width: diameter,
      height: diameter,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: 1,
            strokeWidth: thickness,
            valueColor: AlwaysStoppedAnimation(bg),
            backgroundColor: Colors.transparent,
          ),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: pct),
            duration: AppDurations.medium,
            curve: AppCurves.standard,
            builder: (context, v, _) => CircularProgressIndicator(
              value: v,
              strokeWidth: thickness,
              valueColor: AlwaysStoppedAnimation(fill),
              backgroundColor: Colors.transparent,
            ),
          ),
          if (center != null) center!,
        ],
      ),
    );
  }
}

