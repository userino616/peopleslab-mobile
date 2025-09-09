import 'package:flutter/material.dart';

/// Сторінка з електронними чеками та аналітикою.
class ReceiptsPage extends StatelessWidget {
  const ReceiptsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = const [
      ('Супермаркет', 1244.99),
      ('Булочний престиж', 98.00),
      ('Книжковий рай', 256.88),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Електронні чеки'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final (title, amount) = items[index];
          return Card(
            child: ListTile(
              title: Text(title),
              subtitle: const Text('Грудень 2024'),
              trailing: Text(
                amount.toStringAsFixed(2),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
