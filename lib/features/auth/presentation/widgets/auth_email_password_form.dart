import 'package:flutter/material.dart';
import 'package:peopleslab/common/widgets/primary_button.dart';
import 'package:peopleslab/core/utils/validators.dart';
import 'package:peopleslab/core/l10n/l10n_x.dart';

class AuthEmailPasswordForm extends StatefulWidget {
  final String title;
  final String primaryLabel;
  final bool loading;
  final Future<void> Function(String email, String password) onSubmit;
  final Widget? topSlot; // e.g., name field
  final Widget? middleSlot; // e.g., forgot password or confirm field

  const AuthEmailPasswordForm({
    super.key,
    required this.title,
    required this.primaryLabel,
    required this.onSubmit,
    this.loading = false,
    this.topSlot,
    this.middleSlot,
  });

  @override
  State<AuthEmailPasswordForm> createState() => _AuthEmailPasswordFormState();
}

class _AuthEmailPasswordFormState extends State<AuthEmailPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    await widget.onSubmit(_emailCtrl.text.trim(), _passCtrl.text);
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
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
                  if (widget.topSlot != null) ...[
                    widget.topSlot!,
                    const SizedBox(height: 12),
                  ],
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
                  if (widget.middleSlot != null) ...[
                    Align(
                      alignment: Alignment.centerRight,
                      child: widget.middleSlot!,
                    ),
                    const SizedBox(height: 8),
                  ],
                  PrimaryButton(
                    label: widget.primaryLabel,
                    loading: widget.loading,
                    onPressed: widget.loading ? null : _handleSubmit,
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
