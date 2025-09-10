import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:peopleslab/common/widgets/app_button.dart';
import 'package:peopleslab/core/router/app_router.dart';
import 'package:peopleslab/features/donation/presentation/donation_success_args.dart';

class DonationSuccessPage extends StatelessWidget {
  final DonationSuccessArgs args;
  const DonationSuccessPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_rounded, size: 96, color: scheme.primary),
              const SizedBox(height: 24),
              Text(
                'Дякуємо!',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Ваш внесок у розмірі ${args.amount.round()} ₴ успішно оформлено.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              AppButton.primary(
                label: 'До головної',
                onPressed: () => context.go(AppRoutes.home),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
