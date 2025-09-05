import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform, kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peopleslab/core/router/app_router.dart';
import 'package:peopleslab/core/l10n/l10n_x.dart';
import 'package:peopleslab/core/l10n/l10n_helpers.dart';
import 'package:peopleslab/features/auth/presentation/controllers/auth_controller.dart';

class SignUpPage extends ConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authControllerProvider);
    final notifier = ref.read(authControllerProvider.notifier);
    final isIOS = !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
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
                OutlinedButton(
                  onPressed: state.loading ? null : () async {
                    final ok = await notifier.signInWithGoogle();
                    if (!context.mounted) return;
                    if (ok) {
                      context.go(AppRoutes.home);
                    } else {
                      final code = ref.read(authControllerProvider).errorMessage;
                      final msg = localizeError(context, code);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                    }
                  },
                  child: Text(s.signin_social_google),
                ),
                if (isIOS) ...[
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: state.loading ? null : () async {
                      final ok = await notifier.signInWithApple();
                      if (!context.mounted) return;
                      if (ok) {
                        context.go(AppRoutes.home);
                      } else {
                        final code = ref.read(authControllerProvider).errorMessage;
                        final msg = localizeError(context, code);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                      }
                    },
                    child: Text(s.signin_social_apple),
                  ),
                ],
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: state.loading ? null : () => context.push(AppRoutes.emailSignUp),
                  child: Text(s.signup_create_account),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: state.loading ? null : () => context.go(AppRoutes.signIn),
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
