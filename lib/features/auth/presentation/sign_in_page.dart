import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform, kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peopleslab/core/router/app_router.dart';
import 'package:peopleslab/core/l10n/l10n_x.dart';
import 'package:peopleslab/core/l10n/l10n_helpers.dart';
import 'package:peopleslab/features/auth/presentation/controllers/auth_controller.dart';

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
                _SocialButtons(),
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

class _SocialButtons extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authControllerProvider);
    final notifier = ref.read(authControllerProvider.notifier);
    final isIOS = !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

    final buttons = <Widget>[
      OutlinedButton(
        onPressed: state.loading ? null : () async {
          final ok = await notifier.signInWithGoogle();
          if (!context.mounted) return;
          if (!ok) {
            final code = ref.read(authControllerProvider).errorMessage;
            final msg = localizeError(context, code);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
          }
        },
        child: Text(context.l10n.signin_social_google),
      ),
    ];
    if (isIOS) {
      buttons.add(const SizedBox(height: 8));
      buttons.add(
        OutlinedButton(
          onPressed: state.loading ? null : () async {
            final ok = await notifier.signInWithApple();
            if (!context.mounted) return;
            if (!ok) {
              final code = ref.read(authControllerProvider).errorMessage;
              final msg = localizeError(context, code);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
            }
          },
          child: Text(context.l10n.signin_social_apple),
        ),
      );
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: buttons);
  }
}
