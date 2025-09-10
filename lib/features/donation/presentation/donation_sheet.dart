import 'package:flutter/material.dart';
import 'package:peopleslab/common/widgets/app_button.dart';
import 'package:peopleslab/common/widgets/app_filter_chip.dart';
import 'package:peopleslab/common/widgets/app_text_field.dart';
import 'package:peopleslab/common/widgets/soft_card.dart';
import 'package:peopleslab/core/theme/design_tokens.dart';
import 'package:peopleslab/features/donation/presentation/donation_args.dart';

Future<void> showDonationSheet(BuildContext context, DonationArgs args) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DonationSheet(args: args),
  );
}

class DonationSheet extends StatefulWidget {
  final DonationArgs args;
  const DonationSheet({super.key, required this.args});

  @override
  State<DonationSheet> createState() => _DonationSheetState();
}

class _DonationSheetState extends State<DonationSheet> {
  static const double minAmount = 50;
  static const double maxAmount = 10000;
  static const List<int> presets = [100, 200, 300, 500, 1000, 2000];

  double amount = 200;
  String method = 'card';
  bool anonymous = false;
  bool customMode = false;
  final _amountCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    amount = (widget.args.presetAmount ?? 200).clamp(minAmount, maxAmount);
    _amountCtrl.text = amount.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final bottom = media.viewInsets.bottom;
    return AnimatedPadding(
      duration: AppDurations.medium,
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: AppShadows.elevation2,
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppPalette.n200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text('Підтримати · ${widget.args.projectTitle}',
                    style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SoftCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Сума внеску', style: theme.textTheme.titleMedium),
                                  if (customMode)
                                    TextButton(
                                      onPressed: () => setState(() => customMode = false),
                                      child: const Text('Назад до сум'),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              if (!customMode) ...[
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    const cols = 3;
                                    const spacing = 8.0;
                                    final tileW =
                                        (constraints.maxWidth - spacing * (cols - 1)) / cols;
                                    final tiles = <Widget>[];
                                    for (final s in presets) {
                                      tiles.add(SizedBox(
                                        width: tileW,
                                        height: 40,
                                        child: _AmountTile(
                                          label: '$s ₴',
                                          selected: amount.round() == s,
                                          onTap: () => setState(() {
                                            amount = s.toDouble();
                                            _amountCtrl.text = s.toString();
                                          }),
                                        ),
                                      ));
                                    }
                                    tiles.add(SizedBox(
                                      width: tileW,
                                      height: 40,
                                      child: _AmountTile(
                                        label: 'Інша',
                                        icon: Icons.edit_rounded,
                                        selected: false,
                                        onTap: () => setState(() => customMode = true),
                                      ),
                                    ));
                                    return Wrap(
                                      spacing: spacing,
                                      runSpacing: spacing,
                                      children: tiles,
                                    );
                                  },
                                ),
                              ] else ...[
                                AppTextField(
                                  labelText: 'Сума, ₴',
                                  variant: AppTextFieldVariant.filled,
                                  keyboardType: TextInputType.number,
                                  controller: _amountCtrl,
                                  onChanged: (v) {
                                    final parsed = double.tryParse(v.replaceAll(',', '.'));
                                    if (parsed != null) {
                                      setState(() {
                                        amount = parsed.clamp(minAmount, maxAmount);
                                      });
                                    }
                                  },
                                  helperText: 'Мінімум ${minAmount.toStringAsFixed(0)} ₴, максимум ${maxAmount.toStringAsFixed(0)} ₴',
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        SoftCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Метод оплати', style: theme.textTheme.titleMedium),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  _PayMethodCard(
                                    label: 'Картка',
                                    icon: Icons.credit_card_rounded,
                                    selected: method == 'card',
                                    onTap: () => setState(() => method = 'card'),
                                  ),
                                  const SizedBox(width: 12),
                                  _PayMethodCard(
                                    label: 'Apple Pay',
                                    icon: Icons.phone_iphone_rounded,
                                    selected: method == 'apple',
                                    onTap: () => setState(() => method = 'apple'),
                                  ),
                                  const SizedBox(width: 12),
                                  _PayMethodCard(
                                    label: 'Google Pay',
                                    icon: Icons.android_rounded,
                                    selected: method == 'gpay',
                                    onTap: () => setState(() => method = 'gpay'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Checkbox(
                                    value: anonymous,
                                    onChanged: (v) => setState(() => anonymous = v ?? false),
                                  ),
                                  const SizedBox(width: 4),
                                  const Expanded(child: Text('Публікувати як Анонім')),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                AppButton.primary(
                  label: 'Підтримати на ${amount.round()} ₴',
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Дякуємо за підтримку!')),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PayMethodCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;
  const _PayMethodCard({
    required this.label,
    required this.icon,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = selected ? scheme.primary.withOpacity(0.08) : scheme.surface;
    return Expanded(
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: selected ? scheme.primary : scheme.onSurface),
                const SizedBox(width: 8),
                Text(label),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AmountTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;
  const _AmountTile({
    required this.label,
    this.selected = false,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = selected ? scheme.primary.withOpacity(0.10) : scheme.surface;
    final border = selected ? scheme.primary : scheme.outlineVariant;
    final fg = selected ? scheme.primary : scheme.onSurface;
    return Material(
      color: bg,
      shape: StadiumBorder(side: BorderSide(color: border)),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: fg),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  color: fg,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
