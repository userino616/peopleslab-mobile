import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform, kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopleslab/core/router/app_router.dart';
import 'package:peopleslab/features/auth/presentation/controllers/auth_controller.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
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
                      : () => Navigator.of(context).pushNamed(AppRoutes.emailSignIn),
                  child: const Text('Увійти по e‑mail'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: state.loading
                      ? null
                      : () => Navigator.of(context).pushNamed(AppRoutes.forgotPassword),
                  child: const Text("Don't remember how you logged in?"),
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
          if (ok) {
            Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (r) => false);
          } else {
            final err = ref.read(authControllerProvider).errorMessage;
            if (err != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
            }
          }
        },
        child: const Text('Sign in with Google'),
      ),
    ];
    if (isIOS) {
      buttons.add(const SizedBox(height: 8));
      buttons.add(
        OutlinedButton(
          onPressed: state.loading ? null : () async {
            final ok = await notifier.signInWithApple();
            if (!context.mounted) return;
            if (ok) {
              Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (r) => false);
            } else {
              final err = ref.read(authControllerProvider).errorMessage;
              if (err != null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
              }
            }
          },
          child: const Text('Sign in with Apple'),
        ),
      );
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: buttons);
  }
}
