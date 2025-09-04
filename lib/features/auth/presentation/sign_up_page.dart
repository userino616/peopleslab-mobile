import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform, kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopleslab/core/router/app_router.dart';
import 'package:peopleslab/features/auth/presentation/controllers/auth_controller.dart';

class SignUpPage extends ConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authControllerProvider);
    final notifier = ref.read(authControllerProvider.notifier);
    final isIOS = !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
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
                if (isIOS) ...[
                  const SizedBox(height: 8),
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
                ],
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: state.loading ? null : () => Navigator.of(context).pushNamed(AppRoutes.emailSignUp),
                  child: const Text('Create an account'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: state.loading ? null : () => Navigator.of(context).pushNamed(AppRoutes.signIn),
                  child: const Text('Already have an account? Sign in'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
