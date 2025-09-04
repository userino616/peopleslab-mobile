import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopleslab/common/widgets/primary_button.dart';
import 'package:peopleslab/core/utils/validators.dart';
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
    if (!_codeSent) {
      // Stage 1: request code
      final ok = await ref
          .read(authControllerProvider.notifier)
          .forgotPassword(_emailCtrl.text.trim());
      if (!mounted) return;
      if (ok) {
        setState(() => _codeSent = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Код відправлено. Перевірте пошту.')),
        );
      } else {
        final err = ref.read(authControllerProvider).errorMessage ?? 'Помилка. Спробуйте ще раз.';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      }
    } else {
      // Stage 2: set new password
      final email = _emailCtrl.text.trim();
      final code = _codeCtrl.text.trim();
      final pass = _passCtrl.text;
      if (code.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Введіть код з пошти')));
        return;
      }
      if (_confirmCtrl.text != pass) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Паролі не співпадають')));
        return;
      }
      final ok = await ref
          .read(authControllerProvider.notifier)
          .resetPassword(email: email, code: code, newPassword: pass);
      if (!mounted) return;
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Пароль оновлено. Тепер увійдіть.')),
        );
        Navigator.of(context).pop();
      } else {
        final err = ref.read(authControllerProvider).errorMessage ?? 'Не вдалося оновити пароль';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Відновлення доступу')),
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
                  const Text(
                    'Введіть email — надішлемо код для відновлення паролю. Після цього введіть код і новий пароль нижче.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: Validators.email,
                    keyboardType: TextInputType.emailAddress,
                    readOnly: _codeSent,
                  ),
                  if (_codeSent) ...[
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _codeCtrl,
                      decoration: const InputDecoration(labelText: 'Код з пошти'),
                      validator: (v) => !_codeSent
                          ? null
                          : (v == null || v.trim().isEmpty)
                              ? 'Код обовʼязковий'
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
                                    const SnackBar(content: Text('Код повторно надіслано')),
                                  );
                                } else {
                                  final err = ref.read(authControllerProvider).errorMessage ?? 'Помилка надсилання коду';
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
                                }
                              },
                        child: const Text('Надіслати код ще раз'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passCtrl,
                      decoration: const InputDecoration(labelText: 'Новий пароль'),
                      obscureText: true,
                      validator: (v) => !_codeSent ? null : Validators.password(v),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _confirmCtrl,
                      decoration: const InputDecoration(labelText: 'Підтвердіть пароль'),
                      obscureText: true,
                      validator: (v) => !_codeSent ? null : Validators.password(v),
                    ),
                  ],
                  const SizedBox(height: 16),
                  PrimaryButton(
                    label: _codeSent ? 'Оновити пароль' : 'Надіслати код',
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
