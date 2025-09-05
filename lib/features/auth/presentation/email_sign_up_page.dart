import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopleslab/common/widgets/primary_button.dart';
import 'package:go_router/go_router.dart';
import 'package:peopleslab/core/router/app_router.dart';
import 'package:peopleslab/core/utils/validators.dart';
import 'package:peopleslab/core/l10n/l10n_x.dart';
import 'package:peopleslab/core/l10n/l10n_helpers.dart';
import 'package:peopleslab/features/auth/presentation/controllers/auth_controller.dart';

class EmailSignUpPage extends ConsumerStatefulWidget {
  const EmailSignUpPage({super.key});

  @override
  ConsumerState<EmailSignUpPage> createState() => _EmailSignUpPageState();
}

class _EmailSignUpPageState extends ConsumerState<EmailSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final s = context.l10n;
    if (_passCtrl.text != _confirmCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.validation_passwords_not_match)),
      );
      return;
    }
    final ok = await ref
        .read(authControllerProvider.notifier)
        .signUp(_emailCtrl.text.trim(), _passCtrl.text);
    if (!mounted) return;
    if (ok) {
      context.go(AppRoutes.home);
    } else {
      final code = ref.read(authControllerProvider).errorMessage;
      final msg = code == null ? s.error_signup_failed : localizeError(context, code);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final s = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(s.email_signup_title),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: InputDecoration(labelText: s.label_name_optional),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: InputDecoration(labelText: s.label_email),
                    validator: (v) => Validators.email(context, v),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passCtrl,
                    decoration: InputDecoration(labelText: s.label_password),
                    obscureText: true,
                    validator: (v) => Validators.password(context, v),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _confirmCtrl,
                    decoration: InputDecoration(labelText: s.label_password_confirm),
                    obscureText: true,
                    validator: (v) => Validators.password(context, v),
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    label: s.primary_create_account,
                    loading: state.loading,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
