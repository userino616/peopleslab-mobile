import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:peopleslab/common/widgets/micro_badge.dart';
import 'package:peopleslab/core/theme/design_tokens.dart';

class ReceiptCard extends StatelessWidget {
  final String projectTitle;
  final double amount;
  final DateTime dateTime;
  final String transactionId;
  final String frequency; // once/monthly
  final String method; // card/apple/gpay
  final VoidCallback? onTap;

  const ReceiptCard({
    super.key,
    required this.projectTitle,
    required this.amount,
    required this.dateTime,
    required this.transactionId,
    required this.frequency,
    required this.method,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final f = NumberFormat.currency(locale: 'uk_UA', symbol: '₴', decimalDigits: 2);
    final d = DateFormat('dd.MM.yyyy, HH:mm');
    final scheme = Theme.of(context).colorScheme;
    final icon = switch (method) {
      'apple' => Icons.phone_iphone_rounded,
      'gpay' => Icons.android_rounded,
      _ => Icons.credit_card_rounded,
    };

    return Material(
      color: AppPalette.sand,
      elevation: 0,
      borderRadius: BorderRadius.circular(AppRadii.card),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.card),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            projectTitle,
                            style: Theme.of(context).textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          f.format(amount),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text('${d.format(dateTime)} · ID $transactionId'),
                        const SizedBox(width: 8),
                        MicroBadge(
                          text: frequency == 'monthly' ? 'Щомісяця' : 'Разово',
                          tone: frequency == 'monthly'
                              ? BadgeTone.info
                              : BadgeTone.neutral,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

