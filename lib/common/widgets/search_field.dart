import 'package:flutter/material.dart';

class AppSearchField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool readOnly;
  final String hintText;

  const AppSearchField({
    super.key,
    this.onChanged,
    this.onFilterTap,
    this.onTap,
    this.controller,
    this.focusNode,
    this.readOnly = false,
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
            controller: controller,
            focusNode: focusNode,
            onChanged: onChanged,
            onTap: onTap,
            readOnly: readOnly,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ),
        if (onFilterTap != null) ...[
          const SizedBox(width: 12),
          Ink(
            decoration: ShapeDecoration(
              color: colorScheme.surfaceVariant.withOpacity(0.6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: IconButton(
              onPressed: onFilterTap,
              icon: const Icon(Icons.tune_rounded),
            ),
          ),
        ],
      ],
    );
  }
}
