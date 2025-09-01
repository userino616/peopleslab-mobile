import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopleslab/app/app.dart';
import 'package:peopleslab/core/logging/logger.dart';

void main() {
  FlutterError.onError = (details) {
    FlutterError.dumpErrorToConsole(details);
  };
  runZonedGuarded(() {
    runApp(const ProviderScope(child: App()));
  }, (error, stack) {
    appLogger.e('Uncaught zone error', error: error, stackTrace: stack);
  });
}
