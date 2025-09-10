import 'dart:math' as math;
import 'package:flutter/material.dart';

class ShimmerBox extends StatefulWidget {
  final double height;
  final double? width;
  final BorderRadius borderRadius;

  const ShimmerBox({
    super.key,
    required this.height,
    this.width,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceVariant;
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final t = _ctrl.value;
        return ClipRRect(
          borderRadius: widget.borderRadius,
          child: CustomPaint(
            size: Size(widget.width ?? double.infinity, widget.height),
            painter: _ShimmerPainter(base, t),
          ),
        );
      },
    );
  }
}

class _ShimmerPainter extends CustomPainter {
  final Color base;
  final double t;
  _ShimmerPainter(this.base, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final light = base.withOpacity(0.55);
    final dark = base.withOpacity(0.9);
    final dx = rect.width * (t * 1.5 - 0.25);
    final gradient = LinearGradient(
      begin: Alignment(-1 + t * 2, 0),
      end: Alignment(1 + t * 2, 0),
      colors: [dark, light, dark],
      stops: const [0.25, 0.5, 0.75],
      transform: GradientRotation(-math.pi / 24),
    );
    final paint = Paint()..shader = gradient.createShader(rect.translate(dx, 0));
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant _ShimmerPainter oldDelegate) =>
      oldDelegate.t != t || oldDelegate.base != base;
}

