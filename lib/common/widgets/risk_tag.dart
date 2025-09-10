import 'package:flutter/material.dart';
import 'package:peopleslab/core/theme/design_tokens.dart';

enum RiskLevel { low, mid, high }

class RiskTag extends StatelessWidget {
  final RiskLevel level;
  final bool dense;

  const RiskTag({super.key, required this.level, this.dense = false});

  @override
  Widget build(BuildContext context) {
    final (bg, fg, text) = switch (level) {
      RiskLevel.low => (
          AppPalette.mint,
          AppPalette.primary700,
          'Low risk',
        ),
      RiskLevel.mid => (
          const Color(0xFFFFF2CC),
          const Color(0xFF9A6B00),
          'Mid risk',
        ),
      RiskLevel.high => (
          const Color(0xFFFFE3D2),
          const Color(0xFF9A3C00),
          'High risk',
        ),
    };

    final height = dense ? 22.0 : 26.0;
    final radius = AppRadii.pill;

    return Container(
      decoration: ShapeDecoration(
        color: bg,
        shape: StadiumBorder(side: BorderSide(color: bg.withOpacity(0.6))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shield_outlined, size: dense ? 14 : 16, color: fg),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: fg,
              fontSize: AppTextScale.caption,
              height: 16 / AppTextScale.caption,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

