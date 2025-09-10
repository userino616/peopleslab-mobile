import 'package:flutter/widgets.dart';

/// Lightweight scale-on-press wrapper that doesn't steal gestures
/// from inner buttons. Uses Pointer events instead of GestureDetector.
class TapScale extends StatefulWidget {
  final Widget child;
  final double pressedScale;
  final Duration duration;

  const TapScale({
    super.key,
    required this.child,
    this.pressedScale = 0.98,
    this.duration = const Duration(milliseconds: 120),
  });

  @override
  State<TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<TapScale> with SingleTickerProviderStateMixin {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => setState(() => _down = true),
      onPointerUp: (_) => setState(() => _down = false),
      onPointerCancel: (_) => setState(() => _down = false),
      child: AnimatedScale(
        scale: _down ? widget.pressedScale : 1.0,
        duration: widget.duration,
        child: widget.child,
      ),
    );
  }
}

