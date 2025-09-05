import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peopleslab/core/router/app_router.dart';
import 'package:peopleslab/core/utils/validators.dart';
import 'package:peopleslab/core/l10n/l10n_x.dart';
import 'package:peopleslab/core/l10n/l10n_helpers.dart';
import 'package:peopleslab/features/auth/presentation/controllers/auth_controller.dart';
import 'package:peopleslab/features/auth/presentation/widgets/auth_email_password_form.dart';

class EmailSignUpPage extends ConsumerStatefulWidget {
  const EmailSignUpPage({super.key});

  @override
  ConsumerState<EmailSignUpPage> createState() => _EmailSignUpPageState();
}

class _EmailSignUpPageState extends ConsumerState<EmailSignUpPage> {
  final _nameCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final s = context.l10n;

    final topSlot = TextFormField(
      controller: _nameCtrl,
      decoration: InputDecoration(labelText: s.label_name_optional),
    );

    final belowPassword = TextFormField(
      controller: _confirmCtrl,
      decoration: InputDecoration(labelText: s.label_password_confirm),
      obscureText: true,
      validator: (v) => Validators.password(context, v),
    );

    return AuthEmailPasswordForm(
      title: s.email_signup_title,
      primaryLabel: s.primary_create_account,
      loading: state.loading,
      topSlot: topSlot,
      middleSlot: belowPassword,
      onSubmit: (email, password) async {
        if (_confirmCtrl.text != password) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(s.validation_passwords_not_match)),
          );
          return;
        }
        final ok = await ref.read(authControllerProvider.notifier).signUp(email, password);
        if (!context.mounted) return;
        if (ok) {
          context.go(AppRoutes.home);
        } else {
          final code = ref.read(authControllerProvider).errorMessage;
          showAuthSnack(context, code);
        }
      },
    );
  }
}
