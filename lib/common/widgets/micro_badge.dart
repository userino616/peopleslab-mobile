import 'package:flutter/material.dart';
import 'package:peopleslab/core/theme/design_tokens.dart';

enum BadgeTone { neutral, success, info }

class MicroBadge extends StatelessWidget {
  final String text;
  final BadgeTone tone;
  final IconData? icon;

  const MicroBadge({
    super.key,
    required this.text,
    this.tone = BadgeTone.neutral,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (tone) {
      BadgeTone.success => (AppPalette.mint, AppPalette.primary700),
      BadgeTone.info => (AppPalette.lavender, AppPalette.n700),
      BadgeTone.neutral => (AppPalette.n100, AppPalette.n700),
    };

    return Container(
      height: 18,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: ShapeDecoration(
        color: bg,
        shape: const StadiumBorder(),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              color: fg,
              fontSize: AppTextScale.caption,
              height: 16 / AppTextScale.caption,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

