import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peopleslab/core/router/app_router.dart';
import 'package:peopleslab/core/l10n/l10n_x.dart';
import 'package:peopleslab/core/l10n/l10n_helpers.dart';
import 'package:peopleslab/features/auth/presentation/controllers/auth_controller.dart';
import 'package:peopleslab/features/auth/presentation/widgets/auth_email_password_form.dart';
import 'package:peopleslab/common/widgets/app_button.dart';

class EmailSignIn extends ConsumerStatefulWidget {
  const EmailSignIn({super.key});

  @override
  ConsumerState<EmailSignIn> createState() => _EmailSignInPageState();
}

class _EmailSignInPageState extends ConsumerState<EmailSignIn> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final s = context.l10n;
    return AuthEmailPasswordForm(
      title: s.email_signin_title,
      primaryLabel: s.primary_signin,
      loading: state.loading,
      middleSlot: AppButton.text(
        onPressed: state.loading
            ? null
            : () => context.push(AppRoutes.forgotPassword),
        label: s.signin_forgot,
      ),
      onSubmit: (email, password) async {
        final ok = await ref
            .read(authControllerProvider.notifier)
            .signIn(email, password);
        if (!context.mounted) return;
        if (!ok) {
          final code = ref.read(authControllerProvider).errorMessage;
          showAuthSnack(context, code);
        }
      },
    );
  }
}
