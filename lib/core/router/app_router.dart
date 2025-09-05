import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peopleslab/core/router/nav.dart';
import 'package:peopleslab/app/home_page.dart';
import 'package:peopleslab/app/onboarding_page.dart';
import 'package:peopleslab/app/welcome_page.dart';
import 'package:peopleslab/core/providers.dart';
import 'package:peopleslab/features/auth/presentation/controllers/auth_controller.dart';
import 'package:peopleslab/features/auth/presentation/forgot_password_page.dart';
import 'package:peopleslab/features/auth/presentation/sign_in_page.dart';
import 'package:peopleslab/features/auth/presentation/sign_up_page.dart';
import 'package:peopleslab/features/auth/presentation/email_sign_in_page.dart';
import 'package:peopleslab/features/auth/presentation/email_sign_up_page.dart';
import 'package:peopleslab/app/splash_page.dart';
import 'package:peopleslab/core/logging/logger.dart';

class AppRoutes {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String onboarding = '/onboarding';
  static const String signIn = '/signin';
  static const String signUp = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';

  // Optional nested flows kept for existing UI
  static const String emailSignIn = '/signin/email';
  static const String emailSignUp = '/signup/email';
}

class RouterNotifier extends ChangeNotifier {
  final Ref ref;
  bool _checkedToken = false;
  bool _hasToken = false;

  RouterNotifier(this.ref) {
    ref.listen<AuthState>(authControllerProvider, (_, _) => notifyListeners());
  }

  Future<void> _checkTokenOnce() async {
    if (_checkedToken) return;
    final storage = ref.read(tokenStorageProvider);
    final token = await storage.readRefreshToken();
    _hasToken = token != null && token.isNotEmpty;
    _checkedToken = true;
    appLogger.i('Router: initial token check -> hasToken=$_hasToken');
  }

  FutureOr<String?> redirect(BuildContext context, GoRouterState state) async {
    final user = ref.read(authControllerProvider).user;
    final token = await ref.read(tokenStorageProvider).readRefreshToken();
    final isLoggedIn = user != null && token != null && token.isNotEmpty;
    final loc = state.matchedLocation;
    final isSplash = loc == AppRoutes.splash;
    appLogger.i('Router: redirect from="$loc" isSplash=$isSplash isLoggedIn=$isLoggedIn');

    // Initial decision from splash based on token presence
    if (isSplash) {
      await _checkTokenOnce();
      final target = _hasToken ? AppRoutes.home : AppRoutes.welcome;
      appLogger.i('Router: splash redirect -> $target');
      return target;
    }

    // Public paths
    const public = {
      AppRoutes.welcome,
      AppRoutes.onboarding,
      AppRoutes.signIn,
      AppRoutes.signUp,
      AppRoutes.forgotPassword,
      AppRoutes.emailSignIn,
      AppRoutes.emailSignUp,
    };

    if (!isLoggedIn) {
      if (!public.contains(loc)) {
        appLogger.i('Router: guard -> redirect to welcome');
        return AppRoutes.welcome;
      }
      return null;
    }

    // If logged in and trying to access public pages, send home
    if (public.contains(loc)) {
      appLogger.i('Router: public path while logged in -> home');
      return AppRoutes.home;
    }
    return null;
  }
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final notifier = RouterNotifier(ref);
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: kDebugMode,
    navigatorKey: rootNavigatorKey,
    refreshListenable: notifier,
    redirect: notifier.redirect,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: AppRoutes.emailSignIn,
        builder: (context, state) => const EmailSignIn(),
      ),
      GoRoute(
        path: AppRoutes.emailSignUp,
        builder: (context, state) => const EmailSignUpPage(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
});
