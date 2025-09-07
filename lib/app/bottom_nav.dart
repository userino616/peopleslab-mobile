import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds the current bottom navigation tab index.
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);
