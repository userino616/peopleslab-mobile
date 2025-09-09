import 'package:flutter/material.dart';
import 'package:peopleslab/features/applications/presentation/applications_page.dart';
import 'package:peopleslab/features/schedule/presentation/work_schedule_page.dart';
import 'package:peopleslab/features/receipts/presentation/receipts_page.dart';
import 'package:peopleslab/features/neighborhood/presentation/neighborhood_page.dart';

/// Головна сторінка з доступом до основних можливостей додатку.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Головна'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _FeatureCard(
            title: 'Заяви',
            subtitle: 'Подання заяв та електронний підпис',
            icon: Icons.assignment_rounded,
            page: ApplicationsPage(),
          ),
          SizedBox(height: 12),
          _FeatureCard(
            title: 'Робочий графік',
            subtitle: 'Зручний формат із нагадуваннями',
            icon: Icons.schedule_rounded,
            page: WorkSchedulePage(),
          ),
          SizedBox(height: 12),
          _FeatureCard(
            title: 'Електронні чеки',
            subtitle: 'Екоформат та зручна аналітика',
            icon: Icons.receipt_long_rounded,
            page: ReceiptsPage(),
          ),
          SizedBox(height: 12),
          _FeatureCard(
            title: 'Добросусідство',
            subtitle: 'Підтримуйте проєкти та отримуйте нагороди',
            icon: Icons.emoji_events_rounded,
            page: NeighborhoodPage(),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.page,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget page;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: theme.textTheme.titleMedium),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => page),
        ),
      ),
    );
  }
}
