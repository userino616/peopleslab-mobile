import 'package:flutter/material.dart';
import 'receipt_detail_page.dart';

class ReceiptsPage extends StatelessWidget {
  const ReceiptsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final receipts = const [
      ('12 грудня 2024', 'Супермаркет', 1244.99),
      ('10 грудня 2024', 'Супермаркет', 100.00),
      ('09 грудня 2024', 'Супермаркет', 26.98),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Еко-чеки')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'PAPER RECEIPTS ARE A THING OF THE PAST',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            'Грудень 2024',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          for (final r in receipts)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(r.$2),
                subtitle: Text(r.$1),
                trailing: Text('${r.$3.toStringAsFixed(2)} ₴'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ReceiptDetailPage(
                        date: r.$1,
                        store: r.$2,
                        total: r.$3,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
