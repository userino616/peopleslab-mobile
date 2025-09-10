import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:peopleslab/common/widgets/soft_card.dart';
import 'package:peopleslab/features/study/presentation/widgets/budget_row.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final List<_Tx> _items = _mockTx();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final f = NumberFormat.currency(locale: 'uk_UA', symbol: '₴', decimalDigits: 0);

    final total = _items.fold<double>(0, (s, t) => s + t.amount);
    double _lastNDays(int days) {
      final threshold = DateTime.now().subtract(Duration(days: days));
      return _items
          .where((t) => t.time.isAfter(threshold))
          .fold<double>(0, (s, t) => s + t.amount);
    }
    final perProject = <String, double>{};
    for (final t in _items) {
      perProject.update(t.project, (v) => v + t.amount, ifAbsent: () => t.amount);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Кошелек')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SoftCard(
            child: Row(
              children: [
                const Icon(Icons.account_balance_wallet_rounded),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Сума внесків', style: theme.textTheme.bodySmall),
                      Text(f.format(total), style: theme.textTheme.titleLarge),
                      const SizedBox(height: 6),
                      Text('Останні 30 днів: ${f.format(_lastNDays(30))}',
                          style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('Розподіл по проєктах', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          for (final entry in perProject.entries) ...[
            BudgetRow(
              title: entry.key,
              amount: entry.value,
              fraction: total > 0 ? (entry.value / total) : 0,
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _Tx {
  final String id;
  final String project;
  final double amount;
  final DateTime time;
  final String freq;
  final String method;
  _Tx({
    required this.id,
    required this.project,
    required this.amount,
    required this.time,
    required this.freq,
    required this.method,
  });
}

List<_Tx> _mockTx() {
  final rnd = Random(1);
  final projs = ['Омега‑3 (EPA/DHA)', 'Магній (гліцинат)', 'Вітамін D3'];
  final list = <_Tx>[];
  for (int i = 0; i < 10; i++) {
    final p = projs[i % projs.length];
    final amt = [200, 500, 1000, 1500, 2000][i % 5].toDouble();
    const freq = 'once';
    final method = ['card', 'card', 'card'][i % 3];
    list.add(_Tx(
      id: 'TX${100000 + i}',
      project: p,
      amount: amt,
      time: DateTime.now().subtract(Duration(days: i * 2, hours: rnd.nextInt(12))),
      freq: freq,
      method: method,
    ));
  }
  return list;
}
