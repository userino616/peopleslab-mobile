import 'package:flutter/material.dart';
import 'package:peopleslab/core/theme/design_tokens.dart';

class AppToggle extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool showIcons;
  final String? semanticsLabel;

  const AppToggle({
    super.key,
    required this.value,
    this.onChanged,
    this.showIcons = false,
    this.semanticsLabel,
  });

  @override
  State<AppToggle> createState() => _AppToggleState();
}

class _AppToggleState extends State<AppToggle> {
  bool _focused = false;

  void _toggle() {
    if (widget.onChanged != null) widget.onChanged!(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final on = widget.value;
    final trackColor = on ? AppPalette.primary600 : AppPalette.n300;

    return Semantics(
      label: widget.semanticsLabel,
      toggled: on,
      button: true,
      child: Focus(
        onFocusChange: (f) => setState(() => _focused = f),
        child: GestureDetector(
          onTap: _toggle,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: 52,
            height: 32,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedContainer(
                  duration: AppDurations.medium,
                  curve: AppCurves.standard,
                  width: 52,
                  height: 32,
                  decoration: BoxDecoration(
                    color: trackColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: _focused ? AppShadows.elevation1 : null,
                  ),
                ),
                AnimatedAlign(
                  duration: AppDurations.medium,
                  curve: AppCurves.standard,
                  alignment: on ? Alignment.centerRight : Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: widget.showIcons
                          ? AnimatedSwitcher(
                              duration: AppDurations.color,
                              child: on
                                  ? const Icon(Icons.check_rounded,
                                      key: ValueKey('on'),
                                      size: 16,
                                      color: AppPalette.primary600)
                                  : const Icon(Icons.close_rounded,
                                      key: ValueKey('off'),
                                      size: 16,
                                      color: AppPalette.n500),
                            )
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

