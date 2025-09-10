import 'package:flutter/material.dart';
import 'package:peopleslab/common/widgets/app_linear_progress.dart';

class BudgetRow extends StatelessWidget {
  final String title;
  final double amount;
  final double fraction; // 0..1
  const BudgetRow({super.key, required this.title, required this.amount, required this.fraction});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(title)),
            Text('₴${amount.toStringAsFixed(2)}'),
          ],
        ),
        const SizedBox(height: 6),
        AppLinearProgress(value: fraction),
      ],
    );
  }
}

