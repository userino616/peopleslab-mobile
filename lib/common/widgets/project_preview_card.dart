import 'package:flutter/material.dart';
import 'package:peopleslab/common/widgets/app_linear_progress.dart';
import 'package:peopleslab/common/widgets/app_filter_chip.dart';
import 'package:peopleslab/common/widgets/micro_badge.dart';
import 'package:peopleslab/common/widgets/risk_tag.dart';
import 'package:peopleslab/core/theme/design_tokens.dart';
import 'package:peopleslab/common/widgets/tap_scale.dart';
import 'package:peopleslab/common/widgets/meta_pill.dart';
import 'dart:async';

class ProjectCardData {
  final String title; // H3
  final String subtitle; // Body
  final double collected; // in currency units
  final double target; // in currency units
  final String status; // e.g. "🧪 Набір"
  final String design; // e.g. "RCT"
  final String term; // e.g. "3 міс"
  final RiskLevel risk;
  final bool ethicalBoard;
  final DateTime? endsAt;

  const ProjectCardData({
    required this.title,
    required this.subtitle,
    required this.collected,
    required this.target,
    required this.status,
    required this.design,
    required this.term,
    required this.risk,
    this.ethicalBoard = false,
    this.endsAt,
  });

  double get progress => target <= 0 ? 0 : (collected / target).clamp(0, 1);
}

enum ProjectCardActionKind { follow, support }

class ProjectPreviewCard extends StatefulWidget {
  final ProjectCardData data;
  final VoidCallback? onTap;
  final VoidCallback? onAction; // ignored (support pill removed)
  final ProjectCardActionKind actionKind; // ignored

  const ProjectPreviewCard({
    super.key,
    required this.data,
    this.onTap,
    this.onAction,
    this.actionKind = ProjectCardActionKind.support,
  });

  @override
  State<ProjectPreviewCard> createState() => _ProjectPreviewCardState();
}

class _ProjectPreviewCardState extends State<ProjectPreviewCard> {
  bool _pressed = false;
  Timer? _timer;
  Duration _left = Duration.zero;

  @override
  void initState() {
    super.initState();
    _computeLeft();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _computeLeft());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _computeLeft() {
    final end = widget.data.endsAt;
    if (end == null) return;
    final now = DateTime.now();
    setState(() => _left = end.isAfter(now) ? end.difference(now) : Duration.zero);
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    final scheme = Theme.of(context).colorScheme;
    final pct = (d.progress * 100).round();

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        duration: AppDurations.color,
        scale: _pressed ? 0.98 : 1,
        curve: AppCurves.standard,
        child: Container(
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(AppRadii.card),
            boxShadow: AppShadows.elevation1,
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top: title, subtitle, badges
                    Text(
                      d.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      d.subtitle,
                      style: Theme.of(context).textTheme.bodyLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        RiskTag(level: d.risk, dense: true),
                        if (d.ethicalBoard)
                          const MicroBadge(
                            text: 'Етична рада',
                            tone: BadgeTone.success,
                            icon: Icons.verified_outlined,
                          ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    // Middle: meta pills
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        MetaPill(icon: Icons.science_rounded, label: d.status),
                        MetaPill(icon: Icons.biotech_rounded, label: d.design),
                        MetaPill(icon: Icons.calendar_today_rounded, label: d.term),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Bottom: progress and time left
                    AppLinearProgress(value: d.progress),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₴${_fmt(d.collected)} з ₴${_fmt(d.target)}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        if (widget.data.endsAt != null)
                          Row(
                            children: [
                              const Icon(Icons.timer_rounded, size: 16, color: Color(0xFF64748B)),
                              const SizedBox(width: 4),
                              Text(_formatLeft(), style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                  ],
                ),
              ),
              // Support action pill removed per request
            ],
          ),
        ),
      ),
    );
  }

  String _formatLeft() {
    final d = _left.inDays;
    final h = _left.inHours % 24;
    final m = _left.inMinutes % 60;
    if (_left == Duration.zero) return 'завершено';
    if (d > 0) return '$d д $h г';
    if (h > 0) return '$h г $m хв';
    return '$m хв';
  }

  String _fmt(double v) {
    // Simple thousands with spaces: 123456 -> 123 456
    final s = v.toStringAsFixed(0);
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idx = s.length - i - 1;
      final ch = s[idx];
      buf.write(ch);
      if (i % 3 == 2 && idx != 0) buf.write(' ');
    }
    return buf.toString().split('').reversed.join();
  }
}

class _MiniAction extends StatelessWidget {
  final ProjectCardActionKind kind;
  final VoidCallback? onPressed;

  const _MiniAction({required this.kind, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (bg, border, fg, icon) = switch (kind) {
      ProjectCardActionKind.follow => (
          scheme.surface,
          scheme.outlineVariant,
          scheme.primary,
          Icons.favorite_border_rounded,
        ),
      ProjectCardActionKind.support => (
          scheme.primary,
          Colors.transparent,
          scheme.onPrimary,
          Icons.add_rounded,
        ),
    };
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: bg,
        shape: const StadiumBorder(),
        shadows: kind == ProjectCardActionKind.support ? AppShadows.elevation2 : AppShadows.elevation1,
      ),
      child: Material(
        color: Colors.transparent,
        shape: const StadiumBorder(),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: fg, size: 18),
                if (kind == ProjectCardActionKind.support) ...[
                  const SizedBox(width: 6),
                  Text('Підтримати', style: TextStyle(color: fg, fontWeight: FontWeight.w600)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
