import 'package:flutter/material.dart';

class ReceiptDetailPage extends StatelessWidget {
  final String date;
  final String store;
  final double total;

  const ReceiptDetailPage({
    super.key,
    required this.date,
    required this.store,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final items = const [
      ('Батон', 30.50),
      ('Молоко', 40.00),
      ('Сир', 98.40),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Деталі чеку')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(store, style: Theme.of(context).textTheme.titleLarge),
          Text(date),
          const SizedBox(height: 16),
          for (final i in items)
            ListTile(
              title: Text(i.$1),
              trailing: Text('${i.$2.toStringAsFixed(2)} ₴'),
            ),
          const Divider(),
          ListTile(
            title: const Text('Сума чеку'),
            trailing: Text('${total.toStringAsFixed(2)} ₴'),
          ),
        ],
      ),
    );
  }
}
