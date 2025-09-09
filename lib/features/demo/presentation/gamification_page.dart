import 'package:flutter/material.dart';

class GamificationPage extends StatelessWidget {
  const GamificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Добросусідство')),
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
                    'Ваш рівень добросусідства',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Максимальний рівень досяжності',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  const LinearProgressIndicator(value: 0.7),
                  const SizedBox(height: 8),
                  Text(
                    '34 000 / 50 000 балів',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              title: const Text('Файні новини'),
              subtitle:
                  const Text('Підтримайте проєкти та отримуйте бали'),
              trailing:
                  const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}
