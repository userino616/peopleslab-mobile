import 'package:flutter/material.dart';

/// Сторінка з відображенням робочого графіка.
class WorkSchedulePage extends StatelessWidget {
  const WorkSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = [
      {
        'day': '31',
        'month': 'Сер',
        'weekday': 'Сб',
        'entries': ['Вихідний'],
      },
      {
        'day': '1',
        'month': 'Вер',
        'weekday': 'Нд',
        'entries': ['Вихідний'],
      },
      {
        'day': '2',
        'month': 'Вер',
        'weekday': 'Пн',
        'entries': [
          'Каса 09:00-18:00',
          'Обідня перерва 13:00-14:00',
          'Каса 14:00-18:00',
          'Технічна перерва 16:00-16:30',
        ],
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Робочий графік'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 56,
                      child: Column(
                        children: [
                          Text(
                            item['day']!,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(item['month']!),
                          Text(item['weekday']!,
                              style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final e in item['entries'] as List<String>) ...[
                            Text(e),
                            const SizedBox(height: 4),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
