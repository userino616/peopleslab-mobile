import 'package:flutter/material.dart';

/// Сторінка із заявами працівників.
class ApplicationsPage extends StatelessWidget {
  const ApplicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = const [
      ('Відпустка', 'Розглядається від 7 робочих днів'),
      ('Лікарняний', 'Розглядається від 1-2 годин'),
      ('Вихідний', 'Розглядається від 1-2 годин'),
      ('Отримання компенсації', 'Розглядається від 1-2 годин'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Заяви'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final (title, subtitle) = items[index];
          return Card(
            child: ListTile(
              title: Text(title),
              subtitle: Text(subtitle),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
