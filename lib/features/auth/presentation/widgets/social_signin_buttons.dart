import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopleslab/core/l10n/l10n_x.dart';
import 'package:peopleslab/core/l10n/l10n_helpers.dart';
import 'package:peopleslab/features/auth/presentation/controllers/auth_controller.dart';

class SocialSignInButtons extends ConsumerWidget {
  const SocialSignInButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authControllerProvider);
    final notifier = ref.read(authControllerProvider.notifier);
    final isIOS = defaultTargetPlatform == TargetPlatform.iOS;

    final children = <Widget>[
      OutlinedButton(
        onPressed: state.loading
            ? null
            : () async {
                final ok = await notifier.signInWithGoogle();
                if (!context.mounted) return;
                if (!ok) {
                  final code = ref.read(authControllerProvider).errorMessage;
                  final msg = localizeError(context, code);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(msg)));
                }
              },
        child: Text(context.l10n.signin_social_google),
      ),
    ];

    if (isIOS) {
      children.add(const SizedBox(height: 8));
      children.add(
        OutlinedButton(
          onPressed: state.loading
              ? null
              : () async {
                  final ok = await notifier.signInWithApple();
                  if (!context.mounted) return;
                  if (!ok) {
                    final code = ref.read(authControllerProvider).errorMessage;
                    final msg = localizeError(context, code);
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(msg)));
                  }
                },
          child: Text(context.l10n.signin_social_apple),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}
