import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peopleslab/core/router/app_router.dart';
import 'package:peopleslab/core/l10n/l10n_x.dart';
import 'package:peopleslab/features/auth/presentation/controllers/auth_controller.dart';
import 'package:peopleslab/features/auth/presentation/widgets/social_signin_buttons.dart';

class SignUpPage extends ConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authControllerProvider);
    final s = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(s.signup_title)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SocialSignInButtons(),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: state.loading
                      ? null
                      : () => context.push(AppRoutes.emailSignUp),
                  child: Text(s.signup_create_account),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: state.loading
                      ? null
                      : () => context.push(AppRoutes.signIn),
                  child: Text(s.cta_already_have_account),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
