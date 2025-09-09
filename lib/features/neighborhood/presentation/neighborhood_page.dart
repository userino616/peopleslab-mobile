import 'package:flutter/material.dart';

/// Гейміфікація та підтримка проєктів у вашому районі.
class NeighborhoodPage extends StatelessWidget {
  const NeighborhoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добросусідство'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Рівень добросусідства',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: 0.6,
                    minHeight: 8,
                  ),
                  const SizedBox(height: 8),
                  Text('60% до наступної нагороди'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.volunteer_activism_rounded),
              title: const Text('Підтримати проект'),
              subtitle:
                  const Text('Долучіться до благоустрою парку у вашому районі'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.emoji_events_rounded),
              title: const Text('Ваші нагороди'),
              subtitle: const Text('3 доступні нагороди'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
