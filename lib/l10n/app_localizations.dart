import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'PeoplesLab'**
  String get appTitle;

  /// No description provided for @home_title.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home_title;

  /// No description provided for @home_logged_in.
  ///
  /// In en, this message translates to:
  /// **'You are logged in.'**
  String get home_logged_in;

  /// No description provided for @action_sign_out.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get action_sign_out;

  /// No description provided for @onboarding_appbar_title.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get onboarding_appbar_title;

  /// No description provided for @brand_name.
  ///
  /// In en, this message translates to:
  /// **'PeoplesLab'**
  String get brand_name;

  /// No description provided for @onboarding_intro.
  ///
  /// In en, this message translates to:
  /// **'Welcome! Let\'s get started.'**
  String get onboarding_intro;

  /// No description provided for @onboarding_cta.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboarding_cta;

  /// No description provided for @cta_already_have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get cta_already_have_account;

  /// No description provided for @action_sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get action_sign_up;

  /// No description provided for @welcome_appbar_title.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome_appbar_title;

  /// No description provided for @welcome_intro.
  ///
  /// In en, this message translates to:
  /// **'A quick introduction to the app'**
  String get welcome_intro;

  /// No description provided for @signin_title.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signin_title;

  /// No description provided for @signin_email_button.
  ///
  /// In en, this message translates to:
  /// **'Sign in with e‑mail'**
  String get signin_email_button;

  /// No description provided for @signin_social_google.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signin_social_google;

  /// No description provided for @signin_social_apple.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get signin_social_apple;

  /// No description provided for @signin_forgot.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get signin_forgot;

  /// No description provided for @signup_title.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup_title;

  /// No description provided for @signup_create_account.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get signup_create_account;

  /// No description provided for @email_signin_title.
  ///
  /// In en, this message translates to:
  /// **'Email Sign In'**
  String get email_signin_title;

  /// No description provided for @email_signup_title.
  ///
  /// In en, this message translates to:
  /// **'Email Sign Up'**
  String get email_signup_title;

  /// No description provided for @label_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get label_email;

  /// No description provided for @label_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get label_password;

  /// No description provided for @label_password_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get label_password_confirm;

  /// No description provided for @label_name_optional.
  ///
  /// In en, this message translates to:
  /// **'Name (optional)'**
  String get label_name_optional;

  /// No description provided for @label_code_from_email.
  ///
  /// In en, this message translates to:
  /// **'Code from email'**
  String get label_code_from_email;

  /// No description provided for @primary_signin.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get primary_signin;

  /// No description provided for @primary_create_account.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get primary_create_account;

  /// No description provided for @primary_update_password.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get primary_update_password;

  /// No description provided for @primary_send_code.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get primary_send_code;

  /// No description provided for @forgot_title.
  ///
  /// In en, this message translates to:
  /// **'Password recovery'**
  String get forgot_title;

  /// No description provided for @forgot_intro.
  ///
  /// In en, this message translates to:
  /// **'Enter your email — we will send a code. Then enter the code and a new password below.'**
  String get forgot_intro;

  /// No description provided for @resend_code.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resend_code;

  /// No description provided for @snack_code_sent.
  ///
  /// In en, this message translates to:
  /// **'Code sent. Check your email.'**
  String get snack_code_sent;

  /// No description provided for @snack_code_resent.
  ///
  /// In en, this message translates to:
  /// **'Code resent.'**
  String get snack_code_resent;

  /// No description provided for @snack_password_updated.
  ///
  /// In en, this message translates to:
  /// **'Password updated. Please sign in.'**
  String get snack_password_updated;

  /// No description provided for @error_generic.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again.'**
  String get error_generic;

  /// No description provided for @error_send_code.
  ///
  /// In en, this message translates to:
  /// **'Failed to send code.'**
  String get error_send_code;

  /// No description provided for @error_signin_failed.
  ///
  /// In en, this message translates to:
  /// **'Sign in failed'**
  String get error_signin_failed;

  /// No description provided for @error_signup_failed.
  ///
  /// In en, this message translates to:
  /// **'Sign up failed'**
  String get error_signup_failed;

  /// No description provided for @validation_email_required.
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get validation_email_required;

  /// No description provided for @validation_email_invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get validation_email_invalid;

  /// No description provided for @validation_password_required.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get validation_password_required;

  /// No description provided for @validation_password_min.
  ///
  /// In en, this message translates to:
  /// **'Minimum 6 characters'**
  String get validation_password_min;

  /// No description provided for @validation_code_required.
  ///
  /// In en, this message translates to:
  /// **'Code is required'**
  String get validation_code_required;

  /// No description provided for @validation_passwords_not_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validation_passwords_not_match;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
