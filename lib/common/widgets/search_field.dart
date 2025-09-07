import 'package:flutter/material.dart';

class AppSearchField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final String hintText;

  const AppSearchField({
    super.key,
    this.onChanged,
    this.onFilterTap,
    this.hintText = 'Search supplements',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: onChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Ink(
          decoration: ShapeDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: IconButton(
            onPressed: onFilterTap,
            icon: const Icon(Icons.tune_rounded),
          ),
        ),
      ],
    );
  }
}
