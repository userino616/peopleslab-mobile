import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopleslab/common/widgets/primary_button.dart';
import 'package:peopleslab/core/router/app_router.dart';
import 'package:peopleslab/core/utils/validators.dart';
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
    if (_passCtrl.text != _confirmCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Паролі не співпадають')),
      );
      return;
    }
    final ok = await ref
        .read(authControllerProvider.notifier)
        .signUp(_emailCtrl.text.trim(), _passCtrl.text);
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (r) => false);
    } else {
      final err = ref.read(authControllerProvider).errorMessage ?? 'Sign up failed';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Sign Up'),
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
                    decoration: const InputDecoration(labelText: 'Імʼя (опційно)'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: Validators.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passCtrl,
                    decoration: const InputDecoration(labelText: 'Пароль'),
                    obscureText: true,
                    validator: Validators.password,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _confirmCtrl,
                    decoration: const InputDecoration(labelText: 'Підтвердіть пароль'),
                    obscureText: true,
                    validator: Validators.password,
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    label: 'Створити акаунт',
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

