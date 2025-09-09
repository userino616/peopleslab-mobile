import 'package:flutter/material.dart';

class WorkSchedulePage extends StatelessWidget {
  const WorkSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = const [
      'Каса',
      'Обідня перерва',
      'Каса',
      'Технічна перерва',
      'Каса',
      'Зміна завершена',
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Робочий графік'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Серпень 2024',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'Відпрацьовано: 164 год 45 хв',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Text('31'), Text('Сб')],
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final e in entries)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(e),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
