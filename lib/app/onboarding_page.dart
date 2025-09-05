import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:peopleslab/core/router/app_router.dart';
import 'package:peopleslab/core/l10n/l10n_x.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(s.onboarding_appbar_title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                s.brand_name,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                s.onboarding_intro,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => context.push(AppRoutes.signUp),
                child: Text(s.signup_create_account),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.push(AppRoutes.signIn),
                child: Text(s.cta_already_have_account),
              )
            ],
          ),
        ),
      ),
    );
  }
}
