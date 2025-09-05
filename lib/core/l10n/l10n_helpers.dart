import 'package:flutter/material.dart';
import 'package:peopleslab/core/l10n/l10n_x.dart';

String localizeError(BuildContext context, String? code) {
  if (code == null) return context.l10n.error_generic;
  switch (code) {
    case 'auth.apple_unsupported':
      return context.l10n.error_generic; // Could add specific copy later
    case 'auth.google_id_missing':
      return context.l10n.error_generic;
    case 'auth.apple_id_missing':
      return context.l10n.error_generic;
    default:
      return context.l10n.error_generic;
  }
}

void showAuthSnack(BuildContext context, String? code) {
  final msg = localizeError(context, code);
  // Safe use even when no Scaffold present; callers should provide a Scaffold context
  ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(content: Text(msg)));
}
