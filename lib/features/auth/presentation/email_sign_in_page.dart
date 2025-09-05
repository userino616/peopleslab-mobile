import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopleslab/common/widgets/primary_button.dart';
import 'package:go_router/go_router.dart';
import 'package:peopleslab/core/router/app_router.dart';
import 'package:peopleslab/core/l10n/l10n_x.dart';
import 'package:peopleslab/core/l10n/l10n_helpers.dart';
import 'package:peopleslab/core/utils/validators.dart';
import 'package:peopleslab/features/auth/presentation/controllers/auth_controller.dart';

class EmailSignIn extends ConsumerStatefulWidget {
  const EmailSignIn({super.key});

  @override
  ConsumerState<EmailSignIn> createState() => _EmailSignInPageState();
}

class _EmailSignInPageState extends ConsumerState<EmailSignIn> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref
        .read(authControllerProvider.notifier)
        .signIn(_emailCtrl.text.trim(), _passCtrl.text);
    if (!mounted) return;
    if (ok) {
      context.go(AppRoutes.home);
    } else {
      final code = ref.read(authControllerProvider).errorMessage;
      final msg = code == null ? context.l10n.error_signin_failed : localizeError(context, code);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final s = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(s.email_signin_title),
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
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: state.loading
                          ? null
                          : () => context.push(AppRoutes.forgotPassword),
                      child: Text(s.signin_forgot),
                  ),
                  ),
                  const SizedBox(height: 8),
                  PrimaryButton(
                    label: s.primary_signin,
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
