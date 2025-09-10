import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:peopleslab/common/widgets/app_button.dart';
import 'package:peopleslab/common/widgets/soft_card.dart';
import 'package:peopleslab/core/theme/design_tokens.dart';
import 'package:uuid/uuid.dart';
import 'package:peopleslab/core/theme/design_tokens.dart';

class ReceiptLine {
  final String title;
  final int qty;
  final double price;
  final bool discount;
  const ReceiptLine({
    required this.title,
    this.qty = 1,
    required this.price,
    this.discount = false,
  });
}

class ReceiptData {
  final String projectTitle;
  final double amount;
  final String frequency; // once/monthly
  final String method; // card/apple/gpay
  final bool anonymous;
  final DateTime createdAt;
  final String transactionId;
  final List<ReceiptLine> lines;

  const ReceiptData({
    required this.projectTitle,
    required this.amount,
    required this.frequency,
    required this.method,
    required this.anonymous,
    required this.createdAt,
    required this.transactionId,
    required this.lines,
  });

  factory ReceiptData.mock({
    required String projectTitle,
    required double amount,
    required String frequency,
    required String method,
    required bool anonymous,
  }) {
    final uuid = const Uuid().v4();
    final lines = <ReceiptLine>[
      const ReceiptLine(title: 'Статистичний аналіз', qty: 1, price: 265.08),
      const ReceiptLine(title: 'Лабораторні аналізи', qty: 1, price: 520.00),
      const ReceiptLine(title: 'Співфінансування грантом', qty: 1, price: -265.08, discount: true),
    ];
    return ReceiptData(
      projectTitle: projectTitle,
      amount: amount,
      frequency: frequency,
      method: method,
      anonymous: anonymous,
      createdAt: DateTime.now(),
      transactionId: uuid.substring(0, 8).toUpperCase(),
      lines: lines,
    );
  }

  double get subtotal =>
      lines.where((l) => !l.discount).fold(0, (sum, l) => sum + l.price * l.qty);
  double get discounts =>
      lines.where((l) => l.discount).fold(0, (sum, l) => sum + l.price * l.qty);
  double get total => subtotal + discounts;
}

class DigitalReceiptPage extends StatefulWidget {
  final ReceiptData data;
  const DigitalReceiptPage({super.key, required this.data});

  @override
  State<DigitalReceiptPage> createState() => _DigitalReceiptPageState();
}

class _DigitalReceiptPageState extends State<DigitalReceiptPage> {
  bool dontPrint = true; // default ON

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final f = NumberFormat.currency(locale: 'uk_UA', symbol: '₴', decimalDigits: 2);
    final d = DateFormat('dd.MM.yyyy, HH:mm');
    final data = widget.data;

    return Scaffold(
      appBar: AppBar(title: const Text('Цифровий чек')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Top summary card
          Container(
            decoration: BoxDecoration(
              color: AppPalette.sand,
              borderRadius: BorderRadius.circular(AppRadii.card),
              boxShadow: AppShadows.elevation1,
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  f.format(data.amount),
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 4),
                Text('${d.format(data.createdAt)} · ID ${data.transactionId}'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Custom toggle per design tokens
                    SizedBox(
                      width: 52,
                      height: 32,
                      child: GestureDetector(
                        onTap: () => setState(() => dontPrint = !dontPrint),
                        child: _ReceiptToggle(on: dontPrint),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('Не друкувати чек'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Project title
          Text(
            data.projectTitle,
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),

          // Lines
          SoftCard(
            child: Column(
              children: [
                for (final l in data.lines) ...[
                  _LineRow(
                    title: l.title,
                    qty: l.qty,
                    price: l.price,
                    discount: l.discount,
                  ),
                  const SizedBox(height: 8),
                ],
                const Divider(),
                const SizedBox(height: 8),
                _SummaryRow(
                  label: 'Сума чеку',
                  value: f.format(data.subtotal),
                ),
                _SummaryRow(
                  label: 'Сума знижки',
                  value: f.format(data.discounts),
                  valueStyle: TextStyle(color: AppPalette.success),
                ),
                const SizedBox(height: 6),
                _SummaryRow(
                  label: 'До оплати',
                  value: f.format(data.total),
                  emphasize: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AppButton.outlined(
                  label: 'Експорт PDF',
                  onPressed: () => _notify(context, 'PDF збережено'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton.primary(
                  label: 'Поділитися',
                  onPressed: () => _notify(context, 'Посилання скопійовано'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _notify(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}

class _LineRow extends StatelessWidget {
  final String title;
  final int qty;
  final double price;
  final bool discount;

  const _LineRow({
    required this.title,
    required this.qty,
    required this.price,
    this.discount = false,
  });

  @override
  Widget build(BuildContext context) {
    final f = NumberFormat.currency(locale: 'uk_UA', symbol: '₴', decimalDigits: 2);
    final color = discount ? AppPalette.success : Theme.of(context).colorScheme.onSurface;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            qty > 1 ? '$title ×$qty' : title,
            style: TextStyle(color: color),
          ),
        ),
        Text(
          f.format(price),
          style: TextStyle(color: color, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool emphasize;
  final TextStyle? valueStyle;
  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasize = false,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    final style = emphasize
        ? Theme.of(context).textTheme.titleLarge
        : Theme.of(context).textTheme.bodyLarge;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: valueStyle ?? style?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _ReceiptToggle extends StatelessWidget {
  final bool on;
  const _ReceiptToggle({required this.on});

  @override
  Widget build(BuildContext context) {
    final track = on ? AppPalette.primary600 : AppPalette.n300;
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedContainer(
          duration: AppDurations.medium,
          curve: AppCurves.standard,
          width: 52,
          height: 32,
          decoration: BoxDecoration(
            color: track,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        AnimatedAlign(
          duration: AppDurations.medium,
          curve: AppCurves.standard,
          alignment: on ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                on ? Icons.check_rounded : Icons.close_rounded,
                size: 16,
                color: on ? AppPalette.primary600 : AppPalette.n500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Uses central AppRoutes from core/router/app_router.dart
