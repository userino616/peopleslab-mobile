import 'package:flutter/material.dart';
import 'package:peopleslab/core/theme/design_tokens.dart';

class HeroSection extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final List<Widget> chips;
  final EdgeInsetsGeometry padding;

  const HeroSection({
    super.key,
    required this.title,
    this.subtitle,
    this.chips = const [],
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark
          ? [
              AppPalette.cardDark,
              const Color(0xFF0E1524),
            ]
          : [
              AppPalette.sky,
              Colors.white,
            ],
    );

    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(AppRadii.card),
        boxShadow: AppShadows.elevation1,
        border: isDark ? Border.all(color: AppPalette.borderDark) : null,
      ),
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            DefaultTextStyle.merge(
              style: theme.textTheme.bodyLarge!,
              child: subtitle!,
            ),
          ],
          if (chips.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(spacing: 8, runSpacing: 8, children: chips),
          ],
          const SizedBox(height: 8),
          Row(
            children: const [
              Icon(Icons.info_outline_rounded, size: 16, color: Colors.black54),
              SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Додаток не надає медичних порад',
                  style: TextStyle(fontSize: 12, height: 1.2, color: Color(0xFF334155)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
