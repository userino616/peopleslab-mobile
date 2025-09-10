import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peopleslab/core/router/nav.dart';
import 'package:peopleslab/app/main_shell.dart';
import 'package:peopleslab/features/styleguide/presentation/atoms_demo_page.dart';
import 'package:peopleslab/features/donation/presentation/donation_amount_page.dart';
import 'package:peopleslab/features/donation/presentation/donation_args.dart';
// import 'package:peopleslab/features/donation/presentation/digital_receipt_page.dart';
import 'package:peopleslab/features/wallet/presentation/wallet_page.dart';
import 'package:peopleslab/features/study/presentation/study_args.dart';
import 'package:peopleslab/features/study/presentation/study_page.dart';
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
import 'package:peopleslab/core/auth/auth_phase.dart';

class AppRoutes {
  static const String bootstrap = '/bootstrap';
  static const String welcome = '/welcome';
  static const String onboarding = '/onboarding';
  static const String signIn = '/signin';
  static const String signUp = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String styleguideAtoms = '/__styleguide_atoms';
  static const String donate = '/donate';
  // static const String receipt = '/receipt'; // no receipts flow for now
  static const String wallet = '/wallet';
  static const String study = '/study';

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
  AppRoutes.styleguideAtoms,
  AppRoutes.donate,
  AppRoutes.wallet,
  AppRoutes.study,
};

// Entry routes that should redirect to home when already authenticated
const Set<String> authEntryRoutes = {
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
    // Refresh router when tokens stream changes (loading/data/error)
    ref.listen(tokensStreamProvider, (previous, next) {
      notifyListeners();
    });
  }

  String? redirect(BuildContext context, GoRouterState state) {
    final loc = state.matchedLocation;
    final tokensAsync = ref.read(tokensStreamProvider);
    final phase = tokensAsync.when(
      loading: () => AuthPhase.loading,
      error: (err, stack) => AuthPhase.unauthenticated,
      data: (t) => (t?.refreshToken ?? '').isNotEmpty
          ? AuthPhase.authenticated
          : AuthPhase.unauthenticated,
    );
    final statusStr = phase == AuthPhase.authenticated
        ? 'authenticated'
        : 'unauthenticated';
    appLogger.i('Router: redirect loc="$loc" status=$statusStr');

    // Hold at bootstrap until auth state is hydrated
    if (phase == AuthPhase.loading) {
      if (loc != AppRoutes.bootstrap) {
        appLogger.i('Router: -> bootstrap (waiting hydration)');
        return AppRoutes.bootstrap;
      }
      return null;
    }

    // After hydration, leave bootstrap to the right destination
    if (loc == AppRoutes.bootstrap) {
      return phase == AuthPhase.authenticated
          ? AppRoutes.home
          : AppRoutes.welcome;
    }

    if (phase != AuthPhase.authenticated && !publicRoutes.contains(loc)) {
      appLogger.i('Router: unauthenticated -> welcome');
      return AppRoutes.welcome;
    }
    if (phase == AuthPhase.authenticated && authEntryRoutes.contains(loc)) {
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
        pageBuilder: (context, state) => _authPage(const WelcomePage()),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) => _authPage(const OnboardingPage()),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        pageBuilder: (context, state) => _authPage(const SignInPage()),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        pageBuilder: (context, state) => _authPage(const SignUpPage()),
      ),
      GoRoute(
        path: AppRoutes.emailSignIn,
        pageBuilder: (context, state) => _authPage(const EmailSignIn()),
      ),
      GoRoute(
        path: AppRoutes.emailSignUp,
        pageBuilder: (context, state) => _authPage(const EmailSignUpPage()),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        pageBuilder: (context, state) => _authPage(const ForgotPasswordPage()),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const MainShell(),
      ),
      GoRoute(
        path: AppRoutes.styleguideAtoms,
        builder: (context, state) => const AtomsDemoPage(),
      ),
      GoRoute(
        path: AppRoutes.study,
        builder: (context, state) {
          final args = state.extra as StudyArgs?;
          if (args == null) {
            return const Scaffold(body: Center(child: Text('Study args missing')));
          }
          return StudyPage(args: args);
        },
      ),
      GoRoute(
        path: AppRoutes.donate,
        builder: (context, state) {
          final args = (state.extra is DonationArgs)
              ? state.extra as DonationArgs
              : const DonationArgs(projectTitle: 'Дослідження');
          return DonationAmountPage(args: args);
        },
      ),
      // Receipts flow disabled
      GoRoute(
        path: AppRoutes.wallet,
        builder: (context, state) => const WalletPage(),
      ),
    ],
  );
});

CustomTransitionPage<T> _authPage<T>(Widget child) => CustomTransitionPage<T>(
      transitionDuration: const Duration(milliseconds: 240),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.98, end: 1.0).animate(curved),
            child: child,
          ),
        );
      },
      child: child,
    );
