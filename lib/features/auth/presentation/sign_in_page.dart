import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peopleslab/core/router/app_router.dart';
import 'package:peopleslab/core/l10n/l10n_x.dart';
import 'package:peopleslab/features/auth/presentation/controllers/auth_controller.dart';
import 'package:peopleslab/features/auth/presentation/widgets/social_signin_buttons.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authControllerProvider);
    final s = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(s.signin_title),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SocialSignInButtons(),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: state.loading
                      ? null
                      : () => context.push(AppRoutes.emailSignIn),
                  child: Text(s.signin_email_button),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: state.loading
                      ? null
                      : () => context.push(AppRoutes.forgotPassword),
                  child: Text(s.signin_forgot),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Social buttons moved to shared widget: SocialSignInButtons
