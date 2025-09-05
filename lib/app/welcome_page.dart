import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peopleslab/core/l10n/l10n_x.dart';
import 'package:peopleslab/core/router/app_router.dart';
import 'package:peopleslab/features/auth/presentation/controllers/auth_controller.dart';

class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authControllerProvider);
    final s = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(s.welcome_appbar_title)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  s.welcome_intro,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: state.loading ? null : () => context.go(AppRoutes.onboarding),
                  child: Text(s.onboarding_cta),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: state.loading ? null : () => context.push(AppRoutes.signIn),
                  child: Text.rich(TextSpan(children: [
                    TextSpan(text: s.cta_already_have_account),
                    TextSpan(text: s.action_sign_in),
                  ])),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
