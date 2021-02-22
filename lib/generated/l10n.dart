// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Sign in with google`
  String get google_sign_in_button {
    return Intl.message(
      'Sign in with google',
      name: 'google_sign_in_button',
      desc: '',
      args: [],
    );
  }

  /// `No Internet Connection`
  String get no_internet_failure_title {
    return Intl.message(
      'No Internet Connection',
      name: 'no_internet_failure_title',
      desc: '',
      args: [],
    );
  }

  /// ` You need to be connected to the internet to login.`
  String get login_no_internet_failure {
    return Intl.message(
      ' You need to be connected to the internet to login.',
      name: 'login_no_internet_failure',
      desc: '',
      args: [],
    );
  }

  /// ` Please Check your internet settings.`
  String get no_internet_message {
    return Intl.message(
      ' Please Check your internet settings.',
      name: 'no_internet_message',
      desc: '',
      args: [],
    );
  }

  /// `Operation Failed`
  String get operation_failed {
    return Intl.message(
      'Operation Failed',
      name: 'operation_failed',
      desc: '',
      args: [],
    );
  }

  /// ` A problem occurred while linking your Google account. \n Please Try again.`
  String get login_with_google_failure {
    return Intl.message(
      ' A problem occurred while linking your Google account. \n Please Try again.',
      name: 'login_with_google_failure',
      desc: '',
      args: [],
    );
  }

  /// ` A problem occurred while setting up your account. \n Please Try again.`
  String get new_user_setup_failure {
    return Intl.message(
      ' A problem occurred while setting up your account. \n Please Try again.',
      name: 'new_user_setup_failure',
      desc: '',
      args: [],
    );
  }

  /// `You need to be connected to the internet to setup your new account.`
  String get new_user_no_internet_failure {
    return Intl.message(
      'You need to be connected to the internet to setup your new account.',
      name: 'new_user_no_internet_failure',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}