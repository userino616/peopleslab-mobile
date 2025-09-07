import 'package:flutter/widgets.dart';
import 'package:peopleslab/core/l10n/l10n_x.dart';

const int kPasswordMinLength = 6;

class Validators {
  static String? email(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.l10n.validation_email_required;
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return context.l10n.validation_email_invalid;
    }
    return null;
  }

  static String? password(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.l10n.validation_password_required;
    }
    if (value.length < kPasswordMinLength) {
      return context.l10n.validation_password_min;
    }
    return null;
  }
}
