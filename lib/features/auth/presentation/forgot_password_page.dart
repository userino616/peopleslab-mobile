import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopleslab/common/widgets/primary_button.dart';
import 'package:peopleslab/core/utils/validators.dart';
import 'package:peopleslab/core/l10n/l10n_x.dart';
import 'package:peopleslab/features/auth/presentation/controllers/auth_controller.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _codeSent = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _codeCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final s = context.l10n;
    if (!_codeSent) {
      // Stage 1: request code
      final ok = await ref
          .read(authControllerProvider.notifier)
          .forgotPassword(_emailCtrl.text.trim());
      if (!mounted) return;
      if (ok) {
        setState(() => _codeSent = true);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(s.snack_code_sent)));
      } else {
        final err =
            ref.read(authControllerProvider).errorMessage ?? s.error_generic;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(err)));
      }
    } else {
      // Stage 2: set new password
      final email = _emailCtrl.text.trim();
      final code = _codeCtrl.text.trim();
      final pass = _passCtrl.text;
      if (code.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(s.validation_code_required)));
        return;
      }
      if (_confirmCtrl.text != pass) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(s.validation_passwords_not_match)),
        );
        return;
      }
      final ok = await ref
          .read(authControllerProvider.notifier)
          .resetPassword(email: email, code: code, newPassword: pass);
      if (!mounted) return;
      if (ok) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(s.snack_password_updated)));
        Navigator.of(context).pop();
      } else {
        final err =
            ref.read(authControllerProvider).errorMessage ?? s.error_generic;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(err)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final s = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(s.forgot_title)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(s.forgot_intro, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: InputDecoration(labelText: s.label_email),
                    validator: (v) => Validators.email(context, v),
                    keyboardType: TextInputType.emailAddress,
                    readOnly: _codeSent,
                  ),
                  if (_codeSent) ...[
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _codeCtrl,
                      decoration: InputDecoration(
                        labelText: s.label_code_from_email,
                      ),
                      validator: (v) => !_codeSent
                          ? null
                          : (v == null || v.trim().isEmpty)
                          ? s.validation_code_required
                          : null,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: state.loading
                            ? null
                            : () async {
                                final ok = await ref
                                    .read(authControllerProvider.notifier)
                                    .forgotPassword(_emailCtrl.text.trim());
                                if (!context.mounted) return;
                                if (ok) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(s.snack_code_resent),
                                    ),
                                  );
                                } else {
                                  final err =
                                      ref
                                          .read(authControllerProvider)
                                          .errorMessage ??
                                      s.error_send_code;
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(SnackBar(content: Text(err)));
                                }
                              },
                        child: Text(s.resend_code),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passCtrl,
                      decoration: InputDecoration(labelText: s.label_password),
                      obscureText: true,
                      validator: (v) =>
                          !_codeSent ? null : Validators.password(context, v),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _confirmCtrl,
                      decoration: InputDecoration(
                        labelText: s.label_password_confirm,
                      ),
                      obscureText: true,
                      validator: (v) =>
                          !_codeSent ? null : Validators.password(context, v),
                    ),
                  ],
                  const SizedBox(height: 16),
                  PrimaryButton(
                    label: _codeSent
                        ? s.primary_update_password
                        : s.primary_send_code,
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
