import 'package:flutter/material.dart';
import 'package:peopleslab/core/theme/design_tokens.dart';

class MetaPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  const MetaPill({super.key, required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fg = color ?? scheme.onSurface;
    final bg = AppPalette.sky;
    return Container(
      decoration: ShapeDecoration(
        color: bg,
        shape: const StadiumBorder(),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 6),
          Text(
            label,
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

