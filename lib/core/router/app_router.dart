import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peopleslab/core/router/nav.dart';
import 'package:peopleslab/app/home_page.dart';
import 'package:peopleslab/app/onboarding_page.dart';
import 'package:peopleslab/app/welcome_page.dart';
import 'package:peopleslab/core/di/providers.dart';
import 'package:peopleslab/features/auth/presentation/forgot_password_page.dart';
import 'package:peopleslab/features/auth/presentation/sign_in_page.dart';
import 'package:peopleslab/features/auth/presentation/sign_up_page.dart';
import 'package:peopleslab/features/auth/presentation/email_sign_in_page.dart';
import 'package:peopleslab/features/auth/presentation/email_sign_up_page.dart';
import 'package:peopleslab/core/logging/logger.dart';

class AppRoutes {
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

// Public routes (no auth required)
const Set<String> publicRoutes = {
  AppRoutes.welcome,
  AppRoutes.onboarding,
  AppRoutes.signIn,
  AppRoutes.signUp,
  AppRoutes.forgotPassword,
  AppRoutes.emailSignIn,
  AppRoutes.emailSignUp,
};

class RouterNotifier extends ChangeNotifier {
  final Ref ref;

  RouterNotifier(this.ref) {
    // when auth flag changes — refresh router
    ref.listen<bool>(isAuthenticatedProvider, (previous, next) {
      if (previous == null || previous != next) {
        notifyListeners();
      }
    });
  }

  String? redirect(BuildContext context, GoRouterState state) {
    final loc = state.matchedLocation;
    final isAuthed = ref.read(isAuthenticatedProvider);
    final statusStr = isAuthed ? 'authenticated' : 'unauthenticated';
    appLogger.i('Router: redirect loc="$loc" status=$statusStr');

    if (!isAuthed && !publicRoutes.contains(loc)) {
      appLogger.i('Router: unauthenticated -> welcome');
      return AppRoutes.welcome;
    }
    if (isAuthed && publicRoutes.contains(loc)) {
      appLogger.i('Router: authenticated -> home');
      return AppRoutes.home;
    }
    return null;
  }
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final notifier = RouterNotifier(ref);
  return GoRouter(
    initialLocation: AppRoutes.welcome,
    debugLogDiagnostics: kDebugMode,
    navigatorKey: rootNavigatorKey,
    refreshListenable: notifier,
    redirect: notifier.redirect,
    routes: [
      GoRoute(path: AppRoutes.welcome, builder: (context, state) => const WelcomePage()),
      GoRoute(path: AppRoutes.onboarding, builder: (context, state) => const OnboardingPage()),
      GoRoute(path: AppRoutes.signIn, builder: (context, state) => const SignInPage()),
      GoRoute(path: AppRoutes.signUp, builder: (context, state) => const SignUpPage()),
      GoRoute(path: AppRoutes.emailSignIn, builder: (context, state) => const EmailSignIn()),
      GoRoute(path: AppRoutes.emailSignUp, builder: (context, state) => const EmailSignUpPage()),
      GoRoute(path: AppRoutes.forgotPassword, builder: (context, state) => const ForgotPasswordPage()),
      GoRoute(path: AppRoutes.home, builder: (context, state) => const HomePage()),
    ],
  );
});