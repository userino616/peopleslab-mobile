import 'package:flutter/material.dart';
import 'package:peopleslab/app/home_page.dart';
import 'package:peopleslab/app/onboarding_page.dart';
import 'package:peopleslab/app/welcome_page.dart';
import 'package:peopleslab/features/auth/presentation/sign_in_page.dart';
import 'package:peopleslab/features/auth/presentation/forgot_password_page.dart';
import 'package:peopleslab/features/auth/presentation/email_sign_in_page.dart';
import 'package:peopleslab/features/auth/presentation/email_sign_up_page.dart';
import 'package:peopleslab/features/auth/presentation/sign_up_page.dart';
// Removed recovery options chooser; go straight to email recovery page.

class AppRoutes {
  static const String signIn = '/sign-in';
  static const String emailSignIn = '/sign-in/email';
  static const String signUp = '/sign-up';
  static const String emailSignUp = '/sign-up/email';
  static const String home = '/home';
  static const String welcome = '/welcome';
  static const String forgotPassword = '/forgot-password';
  // Removed separate reset routes: handled within ForgotPasswordPage
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const OnboardingPage());
      case AppRoutes.signIn:
        return MaterialPageRoute(builder: (_) => const SignInPage());
      case AppRoutes.welcome:
        return MaterialPageRoute(builder: (_) => const WelcomePage());
      case AppRoutes.signUp:
        return MaterialPageRoute(
          builder: (_) => const SignUpPage(),
        );
      case AppRoutes.emailSignUp:
        return MaterialPageRoute(
          builder: (_) => const EmailSignUpPage(),
        );
      case AppRoutes.emailSignIn:
        return MaterialPageRoute(
          builder: (_) => const EmailSignIn(),
        );
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());
      default:
        return MaterialPageRoute(builder: (_) => const SignInPage());
    }
  }
}
