import 'package:flutter/material.dart';
import 'package:peopleslab/core/theme/design_tokens.dart';

class ProtocolSlot {
  final String title; // e.g., "Опитник"
  final String subtitle; // e.g., "3 хв"
  final String time; // e.g., "09:00–09:05"
  final bool completed;
  final bool overdue;
  const ProtocolSlot({
    required this.title,
    required this.subtitle,
    required this.time,
    this.completed = false,
    this.overdue = false,
  });
}

class ScheduleRow extends StatelessWidget {
  final DateTime date;
  final List<ProtocolSlot> slots;
  const ScheduleRow({super.key, required this.date, required this.slots});

  @override
  Widget build(BuildContext context) {
    final weekday = _weekday(date);
    final day = date.day.toString().padLeft(2, '0');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppPalette.n100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppPalette.n200),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(weekday, style: const TextStyle(fontSize: 10)),
              Text(day, style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            children: [
              for (final s in slots) ...[
                _SlotCard(slot: s),
                const SizedBox(height: 8),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _weekday(DateTime d) {
    const list = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'НД'];
    return list[d.weekday - 1];
  }
}

class _SlotCard extends StatelessWidget {
  final ProtocolSlot slot;
  const _SlotCard({required this.slot});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final border = slot.overdue ? AppPalette.warning : scheme.outlineVariant;
    final fg = slot.completed ? scheme.onSurface.withOpacity(0.6) : scheme.onSurface;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Icon(
            slot.completed ? Icons.check_circle_rounded : Icons.assignment_outlined,
            color: slot.completed ? AppPalette.success : scheme.onSurfaceVariant,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(slot.title, style: TextStyle(color: fg)),
                const SizedBox(height: 2),
                Text(slot.subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(slot.time, style: TextStyle(color: fg)),
        ],
      ),
    );
  }
}

