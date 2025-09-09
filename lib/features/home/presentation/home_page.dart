import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopleslab/features/demo/presentation/applications_page.dart';
import 'package:peopleslab/features/demo/presentation/gamification_page.dart';
import 'package:peopleslab/features/demo/presentation/receipts_page.dart';
import 'package:peopleslab/features/demo/presentation/schedule_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('PeoplesLab')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _FeatureCard(
            title: 'Заяви',
            subtitle: 'Подайте заяву та підпишіть її електронно',
            icon: Icons.description_outlined,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ApplicationsPage()),
              );
            },
          ),
          _FeatureCard(
            title: 'Робочий графік',
            subtitle: 'Зручний формат на кожен день',
            icon: Icons.schedule_rounded,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const WorkSchedulePage()),
              );
            },
          ),
          _FeatureCard(
            title: 'Еко-чеки',
            subtitle: 'Усі чеки в екологічному форматі',
            icon: Icons.receipt_long_rounded,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ReceiptsPage()),
              );
            },
          ),
          _FeatureCard(
            title: 'Добросусідство',
            subtitle: 'Отримуйте нагороди за добрі справи',
            icon: Icons.emoji_events_outlined,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const GamificationPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: onTap,
      ),
    );
  }
}
