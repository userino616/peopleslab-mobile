import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peopleslab/core/router/nav.dart';
import 'package:peopleslab/features/home/presentation/home_page.dart';
import 'package:peopleslab/features/onboarding/presentation/onboarding_page.dart';
import 'package:peopleslab/features/onboarding/presentation/welcome_page.dart';
import 'package:peopleslab/core/di/providers.dart';
import 'package:peopleslab/features/auth/presentation/forgot_password_page.dart';
import 'package:peopleslab/features/auth/presentation/sign_in_page.dart';
import 'package:peopleslab/features/auth/presentation/sign_up_page.dart';
import 'package:peopleslab/features/auth/presentation/email_sign_in_page.dart';
import 'package:peopleslab/features/auth/presentation/email_sign_up_page.dart';
import 'package:peopleslab/core/logging/logger.dart';
import 'package:peopleslab/core/router/bootstrap_page.dart';

class AppRoutes {
  static const String bootstrap = '/bootstrap';
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
  AppRoutes.bootstrap,
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
    final hydrated = ref.read(authHydratedProvider);
    final isAuthed = ref.read(isAuthenticatedProvider);
    final statusStr = isAuthed ? 'authenticated' : 'unauthenticated';
    appLogger.i('Router: redirect loc="$loc" status=$statusStr');

    // Hold at bootstrap until auth state is hydrated
    if (!hydrated) {
      if (loc != AppRoutes.bootstrap) {
        appLogger.i('Router: -> bootstrap (waiting hydration)');
        return AppRoutes.bootstrap;
      }
      return null;
    }

    // After hydration, leave bootstrap to the right destination
    if (loc == AppRoutes.bootstrap) {
      return isAuthed ? AppRoutes.home : AppRoutes.welcome;
    }

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
    initialLocation: AppRoutes.bootstrap,
    debugLogDiagnostics: kDebugMode,
    navigatorKey: rootNavigatorKey,
    refreshListenable: notifier,
    redirect: notifier.redirect,
    routes: [
      GoRoute(
        path: AppRoutes.bootstrap,
        builder: (context, state) => const BootstrapPage(),
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
