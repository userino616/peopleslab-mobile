import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:peopleslab/core/l10n/l10n_x.dart';

/// Card displaying a single crowdfunding campaign.
class CampaignCard extends StatelessWidget {
  final String title;
  final String description;
  final double raised;
  final double goal;

  const CampaignCard({
    super.key,
    required this.title,
    required this.description,
    required this.raised,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = (raised / goal).clamp(0, 1);
    final currency = NumberFormat.simpleCurrency();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style:
                  theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(value: percent, minHeight: 8),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${currency.format(raised)} / ${currency.format(goal)}'),
                FilledButton(
                  onPressed: () {},
                  child: Text(context.l10n.supportProject),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

