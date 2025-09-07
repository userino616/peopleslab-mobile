import 'dart:async';

import 'package:peopleslab/core/auth/token_storage.dart';
import 'package:peopleslab/features/auth/domain/auth_repository.dart';
import 'package:peopleslab/core/logging/logger.dart';

/// Centralized auth state manager: keeps in-memory token snapshot,
/// handles pre-refresh scheduling and serializes refresh requests.
class AuthManager {
  final TokenStorage storage;

  /// How much earlier than expiry to refresh access token.
  final Duration refreshSkew;

  AuthManager({
    required this.storage,
    this.refreshSkew = const Duration(seconds: 5),
  }) {
    _init();
  }

  // In-memory snapshot for fast, sync access
  String? _accessToken;
  int? _accessExpiryMillis;
  String? _refreshToken;

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  // Reactive subscriptions and timers
  StreamSubscription<Tokens?>? _sub;
  Timer? _preRefreshTimer;

  // Serialize refresh calls
  Completer<bool>? _refreshing;
  Future<AuthTokens?> Function()? _refreshFn;
  Future<void> Function(String refreshToken)? _networkLogoutFn;
  Future<void> Function()? _resetGrpcFn;

  void configure({
    required Future<AuthTokens?> Function() refresh,
    required Future<void> Function(String refreshToken) networkLogout,
    required Future<void> Function() resetGrpc,
  }) {
    _refreshFn = refresh;
    _networkLogoutFn = networkLogout;
    _resetGrpcFn = resetGrpc;
  }

  Future<void> _init() async {
    // Load initial snapshot
    final t = await storage.getTokens();
    _applyTokens(t);
    _schedulePreRefresh();
    // Listen for subsequent updates
    _sub = storage.tokensStream.listen((tokens) {
      _applyTokens(tokens);
      _schedulePreRefresh();
    });
  }

  void _applyTokens(Tokens? t) {
    _accessToken = t?.accessToken;
    _accessExpiryMillis = t?.accessExpiryMillis;
    _refreshToken = t?.refreshToken;
  }

  void _schedulePreRefresh() {
    _preRefreshTimer?.cancel();
    final exp = _accessExpiryMillis;
    if (exp == null) return; // unknown
    final now = DateTime.now().millisecondsSinceEpoch;
    var whenMs = exp - now - refreshSkew.inMilliseconds;
    if (whenMs <= 0) {
      // already due; refresh soon but yield to event loop
      _preRefreshTimer = Timer(const Duration(milliseconds: 100), () {
        maybeRefresh(reason: 'pre');
      });
      return;
    }
    // Cap long timers to avoid extremely long single-shot
    final delay = Duration(milliseconds: whenMs);
    _preRefreshTimer = Timer(delay, () {
      maybeRefresh(reason: 'pre');
    });
  }

  Future<bool> maybeRefresh({String reason = 'manual'}) async {
    // Basic preconditions
    final refreshToken = _refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) {
      appLogger.w(
        'AuthManager|refresh: skip (no refresh token), reason=$reason',
      );
      return false;
    }

    if (_refreshing != null) {
      // Another refresh in progress; join it
      appLogger.t('AuthManager|refresh: join in-flight, reason=$reason');
      return _refreshing!.future;
    }

    final c = Completer<bool>();
    _refreshing = c;
    try {
      appLogger.i('AuthManager|refresh:start reason=$reason');
      final tokens =
          await (_refreshFn?.call() ?? Future<AuthTokens?>.value(null));
      final ok = tokens != null;
      if (ok) {
        await applySessionTokens(tokens);
      }
      appLogger.i('AuthManager|refresh:end ok=$ok reason=$reason');
      c.complete(ok);
      return ok;
    } catch (e, st) {
      appLogger.w('AuthManager|refresh:error $e', error: e, stackTrace: st);
      c.complete(false);
      return false;
    } finally {
      _refreshing = null;
    }
  }

  /// Interceptor notifies on 401. We attempt a serialized refresh; if it fails
  /// we perform sign-out/cleanup via repository.
  Future<void> handleUnauthorized() async {
    appLogger.w('AuthManager|401: received');
    final ok = await maybeRefresh(reason: '401');
    if (ok) return;
    await signOut();
  }

  Future<void> signOut() async {
    // Perform network logout best-effort, then clear local state and reset gRPC
    final token = _refreshToken;
    if (token != null && token.isNotEmpty) {
      try {
        await _networkLogoutFn?.call(token);
      } catch (_) {
        /* ignore */
      }
    }
    await storage.clearTokens();
    await (_resetGrpcFn?.call() ?? Future.value());
  }

  Future<void> applySessionTokens(AuthTokens tokens) async {
    await storage.writeTokens(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
      accessExpiresIn: tokens.expiresIn,
      refreshExpiresIn: tokens.refreshExpiresIn,
    );
  }

  void dispose() {
    _sub?.cancel();
    _preRefreshTimer?.cancel();
  }
}
