import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Controls current application ThemeMode (system/light/dark).
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
