import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:peopleslab/app/bottom_nav.dart';
import 'package:peopleslab/common/widgets/app_button.dart';
import 'package:peopleslab/common/widgets/app_filter_chip.dart';
import 'package:peopleslab/common/widgets/app_text_field.dart';
import 'package:peopleslab/common/widgets/soft_card.dart';
import 'package:peopleslab/features/donation/presentation/donation_args.dart';
import 'package:peopleslab/features/donation/presentation/donation_success_args.dart';
import 'package:peopleslab/core/router/app_router.dart';
import 'package:peopleslab/app/bottom_nav.dart';

class DonationAmountPage extends ConsumerStatefulWidget {
  final DonationArgs args;
  const DonationAmountPage({super.key, required this.args});

  @override
  ConsumerState<DonationAmountPage> createState() => _DonationAmountPageState();
}

class _DonationAmountPageState extends ConsumerState<DonationAmountPage> {
  static const double minAmount = 50;
  static const double maxAmount = 10000;
  static const List<int> quickSteps = [200, 500, 1000, 2000, 5000];

  double amount = 200;
  String method = 'card';
  bool anonymous = false;

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
    return WillPopScope(
      onWillPop: () async {
        _restoreTabIfNeeded();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Підтримати · ${widget.args.projectTitle}'),
        ),
        body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/backgrounds/donation_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/donation_hero.png',
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            // Amount block
          SoftCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Сума внеску', style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: amount,
                        min: minAmount,
                        max: maxAmount,
                        divisions: ((maxAmount - minAmount) / 50).round(),
                        label: amount.toStringAsFixed(0),
                        onChanged: (v) => setState(() {
                          amount = v;
                          _amountCtrl.text = amount.toStringAsFixed(0);
                        }),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 120,
                      child: AppTextField(
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
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final s in quickSteps)
                      AppFilterChip(
                        label: '$s ₴',
                        selected: amount.round() == s,
                        onPressed: () => setState(() {
                          amount = s.toDouble();
                          _amountCtrl.text = s.toString();
                        }),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // No recurring payments: removed frequency selection

          const SizedBox(height: 16),
          // Payment methods
          SoftCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Метод оплати', style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _PayMethodCard(
                      label: 'Картка',
                      iconAsset: 'assets/icons/pay_card.png',
                      selected: method == 'card',
                      onTap: () => setState(() => method = 'card'),
                    ),
                    const SizedBox(width: 12),
                    _PayMethodCard(
                      label: 'Apple Pay',
                      iconAsset: 'assets/icons/pay_apple.png',
                      selected: method == 'apple',
                      onTap: () => setState(() => method = 'apple'),
                    ),
                    const SizedBox(width: 12),
                    _PayMethodCard(
                      label: 'Google Pay',
                      iconAsset: 'assets/icons/pay_google.png',
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
          const SizedBox(height: 88),
        ],
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: AppButton.primary(
              label: 'Підтримати на ${amount.round()} ₴',
              onPressed: () => _proceed(context),
            ),
          ),
        ),
      ),
    );
  }

  void _proceed(BuildContext context) {
    context.go(
      AppRoutes.donationSuccess,
      extra: DonationSuccessArgs(
        amount: amount,
        returnToTabIndex: widget.args.returnToTabIndex,
        projectTitle: widget.args.projectTitle,
      ),
    );
  }

  void _restoreTabIfNeeded() {
    final idx = widget.args.returnToTabIndex;
    if (idx != null) {
      try {
        // only if provider exists in scope
        ref.read(bottomNavIndexProvider.notifier).state = idx;
      } catch (_) {
        // ignore if provider not available
      }
    }
  }
}

class _PayMethodCard extends StatelessWidget {
  final String label;
  final String iconAsset;
  final bool selected;
  final VoidCallback? onTap;
  const _PayMethodCard({
    required this.label,
    required this.iconAsset,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = selected ? scheme.primary.withOpacity(0.04) : scheme.surface;
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
                Image.asset(
                  iconAsset,
                  width: 24,
                  height: 24,
                  color: selected ? scheme.primary : scheme.onSurface,
                ),
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
