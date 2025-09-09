import 'package:flutter/material.dart';

class ApplicationsPage extends StatelessWidget {
  const ApplicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = const [
      ('Відпустка', 'Розглядається від 7 робочих днів'),
      ('Лікарняний', 'Розглядається від 1-2 годин'),
      ('Вихідний', 'Розглядається від 1-2 годин'),
      ('Отримання компенсації', 'Розглядається від 7 робочих днів'),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Заяви'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(item.$1),
              subtitle: Text(item.$2),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            ),
          );
        },
      ),
    );
  }
}
