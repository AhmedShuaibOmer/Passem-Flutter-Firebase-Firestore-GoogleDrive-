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

  /// `Continue`
  String get continue_text {
    return Intl.message(
      'Continue',
      name: 'continue_text',
      desc: '',
      args: [],
    );
  }

  /// `Which University do you study in?`
  String get pick_university_label {
    return Intl.message(
      'Which University do you study in?',
      name: 'pick_university_label',
      desc: '',
      args: [],
    );
  }

  /// `Pick your University`
  String get pick_university_hint {
    return Intl.message(
      'Pick your University',
      name: 'pick_university_hint',
      desc: '',
      args: [],
    );
  }

  /// `Which College do you study in?`
  String get pick_college_label {
    return Intl.message(
      'Which College do you study in?',
      name: 'pick_college_label',
      desc: '',
      args: [],
    );
  }

  /// `Pick your College`
  String get pick_college_hint {
    return Intl.message(
      'Pick your College',
      name: 'pick_college_hint',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcome {
    return Intl.message(
      'Welcome',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Find a course and everything related to it`
  String get search_hint_home_page {
    return Intl.message(
      'Find a course and everything related to it',
      name: 'search_hint_home_page',
      desc: '',
      args: [],
    );
  }

  /// `Passem App`
  String get app_name {
    return Intl.message(
      'Passem App',
      name: 'app_name',
      desc: '',
      args: [],
    );
  }

  /// `By`
  String get by {
    return Intl.message(
      'By',
      name: 'by',
      desc: '',
      args: [],
    );
  }

  /// `Starred Materials`
  String get starred_materials {
    return Intl.message(
      'Starred Materials',
      name: 'starred_materials',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `My Courses`
  String get my_courses {
    return Intl.message(
      'My Courses',
      name: 'my_courses',
      desc: '',
      args: [],
    );
  }

  /// `Starred`
  String get starred {
    return Intl.message(
      'Starred',
      name: 'starred',
      desc: '',
      args: [],
    );
  }

  /// `Offline`
  String get offline {
    return Intl.message(
      'Offline',
      name: 'offline',
      desc: '',
      args: [],
    );
  }

  /// `Courses`
  String get courses {
    return Intl.message(
      'Courses',
      name: 'courses',
      desc: '',
      args: [],
    );
  }

  /// `Recently Added`
  String get recently_added {
    return Intl.message(
      'Recently Added',
      name: 'recently_added',
      desc: '',
      args: [],
    );
  }

  /// `Top Contributors`
  String get top_contributors {
    return Intl.message(
      'Top Contributors',
      name: 'top_contributors',
      desc: '',
      args: [],
    );
  }

  /// `General document`
  String get general_document {
    return Intl.message(
      'General document',
      name: 'general_document',
      desc: '',
      args: [],
    );
  }

  /// `Summary`
  String get summary {
    return Intl.message(
      'Summary',
      name: 'summary',
      desc: '',
      args: [],
    );
  }

  /// `Lecture notes`
  String get lecture_notes {
    return Intl.message(
      'Lecture notes',
      name: 'lecture_notes',
      desc: '',
      args: [],
    );
  }

  /// `Exam papers`
  String get exam_papers {
    return Intl.message(
      'Exam papers',
      name: 'exam_papers',
      desc: '',
      args: [],
    );
  }

  /// `Exercise`
  String get exercise {
    return Intl.message(
      'Exercise',
      name: 'exercise',
      desc: '',
      args: [],
    );
  }

  /// `External resource`
  String get external_resource {
    return Intl.message(
      'External resource',
      name: 'external_resource',
      desc: '',
      args: [],
    );
  }

  /// `General`
  String get general {
    return Intl.message(
      'General',
      name: 'general',
      desc: '',
      args: [],
    );
  }

  /// `Summaries`
  String get summaries {
    return Intl.message(
      'Summaries',
      name: 'summaries',
      desc: '',
      args: [],
    );
  }

  /// `Lectures notes`
  String get lectures_notes {
    return Intl.message(
      'Lectures notes',
      name: 'lectures_notes',
      desc: '',
      args: [],
    );
  }

  /// `Exams papers`
  String get exams_papers {
    return Intl.message(
      'Exams papers',
      name: 'exams_papers',
      desc: '',
      args: [],
    );
  }

  /// `Exercises`
  String get exercises {
    return Intl.message(
      'Exercises',
      name: 'exercises',
      desc: '',
      args: [],
    );
  }

  /// `External resources`
  String get external_resources {
    return Intl.message(
      'External resources',
      name: 'external_resources',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `File`
  String get file {
    return Intl.message(
      'File',
      name: 'file',
      desc: '',
      args: [],
    );
  }

  /// `Any document related to this course`
  String get any_document_related_to_this_course {
    return Intl.message(
      'Any document related to this course',
      name: 'any_document_related_to_this_course',
      desc: '',
      args: [],
    );
  }

  /// `External Link`
  String get external_link {
    return Intl.message(
      'External Link',
      name: 'external_link',
      desc: '',
      args: [],
    );
  }

  /// `A link for a website, article, or a video related to this course`
  String get add_external_link_subtitle {
    return Intl.message(
      'A link for a website, article, or a video related to this course',
      name: 'add_external_link_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Paste The link here`
  String get paste_link_here {
    return Intl.message(
      'Paste The link here',
      name: 'paste_link_here',
      desc: '',
      args: [],
    );
  }

  /// `Type a short title`
  String get type_short_title {
    return Intl.message(
      'Type a short title',
      name: 'type_short_title',
      desc: '',
      args: [],
    );
  }

  /// `Add some description (optional)`
  String get add_description {
    return Intl.message(
      'Add some description (optional)',
      name: 'add_description',
      desc: '',
      args: [],
    );
  }

  /// `File Path`
  String get file_path {
    return Intl.message(
      'File Path',
      name: 'file_path',
      desc: '',
      args: [],
    );
  }

  /// `Category of this file`
  String get category_of_file {
    return Intl.message(
      'Category of this file',
      name: 'category_of_file',
      desc: '',
      args: [],
    );
  }

  /// `Pick file category`
  String get pick_file_category {
    return Intl.message(
      'Pick file category',
      name: 'pick_file_category',
      desc: '',
      args: [],
    );
  }

  /// `Related course`
  String get related_course {
    return Intl.message(
      'Related course',
      name: 'related_course',
      desc: '',
      args: [],
    );
  }

  /// `Pick the course this content related to`
  String get pick_course_related_to_content {
    return Intl.message(
      'Pick the course this content related to',
      name: 'pick_course_related_to_content',
      desc: '',
      args: [],
    );
  }

  /// `No courses were found matching your search`
  String get no_courses_were_found {
    return Intl.message(
      'No courses were found matching your search',
      name: 'no_courses_were_found',
      desc: '',
      args: [],
    );
  }

  /// `Try adding the course yourself`
  String get try_adding_course {
    return Intl.message(
      'Try adding the course yourself',
      name: 'try_adding_course',
      desc: '',
      args: [],
    );
  }

  /// `No results were found matching your search`
  String get no_results_found {
    return Intl.message(
      'No results were found matching your search',
      name: 'no_results_found',
      desc: '',
      args: [],
    );
  }

  /// `Type the course name`
  String get course_name_hint {
    return Intl.message(
      'Type the course name',
      name: 'course_name_hint',
      desc: '',
      args: [],
    );
  }

  /// `Add course`
  String get add_course {
    return Intl.message(
      'Add course',
      name: 'add_course',
      desc: '',
      args: [],
    );
  }

  /// `Remove from my courses`
  String get remove_from_my_courses {
    return Intl.message(
      'Remove from my courses',
      name: 'remove_from_my_courses',
      desc: '',
      args: [],
    );
  }

  /// `Add to my courses`
  String get add_to_my_courses {
    return Intl.message(
      'Add to my courses',
      name: 'add_to_my_courses',
      desc: '',
      args: [],
    );
  }

  /// `Link copied to clipboard`
  String get copied_to_clipboard {
    return Intl.message(
      'Link copied to clipboard',
      name: 'copied_to_clipboard',
      desc: '',
      args: [],
    );
  }

  /// `Your device doesn't support this operation`
  String get unsupported_operation {
    return Intl.message(
      'Your device doesn\'t support this operation',
      name: 'unsupported_operation',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong.`
  String get something_went_wrong {
    return Intl.message(
      'Something went wrong.',
      name: 'something_went_wrong',
      desc: '',
      args: [],
    );
  }

  /// `Try Again`
  String get try_again {
    return Intl.message(
      'Try Again',
      name: 'try_again',
      desc: '',
      args: [],
    );
  }

  /// `Added Successfully`
  String get added_successfully {
    return Intl.message(
      'Added Successfully',
      name: 'added_successfully',
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