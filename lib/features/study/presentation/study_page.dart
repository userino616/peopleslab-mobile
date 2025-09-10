import 'dart:async';
import 'package:flutter/material.dart';
import 'package:peopleslab/common/widgets/app_button.dart';
import 'package:peopleslab/common/widgets/app_linear_progress.dart';
import 'package:peopleslab/common/widgets/micro_badge.dart';
import 'package:peopleslab/common/widgets/hero_section.dart';
import 'package:peopleslab/common/widgets/risk_tag.dart';
import 'package:peopleslab/core/theme/design_tokens.dart';
import 'package:peopleslab/features/donation/presentation/donation_args.dart';
import 'package:peopleslab/features/donation/presentation/donation_sheet.dart';
import 'package:peopleslab/features/study/presentation/study_args.dart';
import 'package:peopleslab/features/study/presentation/widgets/budget_row.dart';
import 'package:peopleslab/features/study/presentation/widgets/schedule_row.dart';
import 'package:peopleslab/features/study/presentation/widgets/update_card.dart';

class StudyPage extends StatefulWidget {
  final StudyArgs args;
  const StudyPage({super.key, required this.args});

  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> with TickerProviderStateMixin {
  late final TabController _tab;
  Duration _left = Duration.zero;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 6, vsync: this);
    _updateLeft();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateLeft());
  }

  @override
  void dispose() {
    _tab.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _updateLeft() {
    final end = widget.args.endsAt;
    if (end == null) return;
    final now = DateTime.now();
    setState(() {
      _left = end.isAfter(now) ? end.difference(now) : Duration.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final d = widget.args;
    final progress = (d.collected / d.target).clamp(0.0, 1.0);
    final pct = (progress * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Картка дослідження'),
      ),
      body: Column(
        children: [
          // Hero block
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: HeroSection(
              title: Text(d.title, style: Theme.of(context).textTheme.headlineMedium),
              subtitle: Text(d.goal),
              chips: const [
                RiskTag(level: RiskLevel.low, dense: true),
                MicroBadge(text: 'Етична рада', tone: BadgeTone.success, icon: Icons.verified_outlined),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                AppLinearProgress(value: progress, label: '$pct%'),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('₴${d.collected.toStringAsFixed(0)} з ₴${d.target.toStringAsFixed(0)}'),
                    if (widget.args.endsAt != null)
                      Row(
                        children: [
                          const Icon(Icons.timer_rounded, size: 16, color: Color(0xFF64748B)),
                          const SizedBox(width: 4),
                          Text(_formatLeft(), style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Tabs
          TabBar(
            controller: _tab,
            isScrollable: true,
            tabs: const [
              Tab(text: 'Огляд'),
              Tab(text: 'Протокол'),
              Tab(text: 'Прогрес'),
              Tab(text: 'Витрати'),
              Tab(text: 'Дані'),
              Tab(text: 'Оновлення'),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                _OverviewTab(args: d),
                _ProtocolTab(),
                _ProgressTab(),
                _CostsTab(),
                _DataTab(),
                _UpdatesTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: AppButton.primary(
            label: 'Підтримати',
            onPressed: () => showDonationSheet(
              context,
              DonationArgs(projectTitle: d.title, presetAmount: 200),
            ),
          ),
        ),
      ),
    );
  }

  void _toast(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}

extension on _StudyPageState {
  String _formatLeft() {
    if (_left == Duration.zero) return 'завершено';
    final d = _left.inDays;
    final h = _left.inHours % 24;
    final m = _left.inMinutes % 60;
    if (d > 0) return '$d д $h г';
    if (h > 0) return '$h г $m хв';
    return '$m хв';
  }
}

class _OverviewTab extends StatelessWidget {
  final StudyArgs args;
  const _OverviewTab({required this.args});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: const [
        Text('Мета дослідження'),
        SizedBox(height: 8),
        Text('Короткий опис, критерії включення, основні біомаркери.'),
      ],
    );
  }
}

class _ProtocolTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: [
        ScheduleRow(
          date: today,
          slots: const [
            ProtocolSlot(title: 'Опитник', subtitle: '3 хв', time: '09:00–09:05'),
            ProtocolSlot(title: 'Забір крові', subtitle: '15 хв', time: '10:00–10:15', overdue: true),
          ],
        ),
        const SizedBox(height: 12),
        ScheduleRow(
          date: today.add(const Duration(days: 1)),
          slots: const [
            ProtocolSlot(title: 'Опитник', subtitle: '3 хв', time: '09:00–09:05', completed: true),
          ],
        ),
      ],
    );
  }
}

class _ProgressTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: const [
        Text('Графіки прогресу, воронка набору тощо.'),
      ],
    );
  }
}

class _CostsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: const [
        BudgetRow(title: 'Лабораторні аналізи', amount: 120000, fraction: 0.55),
        SizedBox(height: 12),
        BudgetRow(title: 'Статистичний аналіз', amount: 40000, fraction: 0.3),
        SizedBox(height: 12),
        BudgetRow(title: 'Адміністративні', amount: 15000, fraction: 0.15),
      ],
    );
  }
}

class _DataTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: const [
        Text('Публікації, Peer-reviewed / Preprint, відкриті набори даних.'),
      ],
    );
  }
}

class _UpdatesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: const [
        UpdateCard(
          title: 'Проміжні результати аналізу біомаркерів',
          excerpt: 'Попередні дані показують покращення профілю ліпідів у групі EPA/DHA...',
        ),
        SizedBox(height: 12),
        UpdateCard(
          title: 'Закуплено реактиви',
          excerpt: 'Поставка на 3 тижні роботи лабораторії вже у нас.',
        ),
      ],
    );
  }
}
