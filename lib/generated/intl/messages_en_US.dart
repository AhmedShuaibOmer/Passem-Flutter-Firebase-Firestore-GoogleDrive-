// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en_US locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en_US';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "google_sign_in_button" : MessageLookupByLibrary.simpleMessage("Sign in with google"),
    "login_no_internet_failure" : MessageLookupByLibrary.simpleMessage(" You need to be connected to the internet to login."),
    "login_with_google_failure" : MessageLookupByLibrary.simpleMessage(" A problem occurred while linking your Google account. \n Please Try again."),
    "new_user_no_internet_failure" : MessageLookupByLibrary.simpleMessage("You need to be connected to the internet to setup your new account."),
    "new_user_setup_failure" : MessageLookupByLibrary.simpleMessage(" A problem occurred while setting up your account. \n Please Try again."),
    "no_internet_failure_title" : MessageLookupByLibrary.simpleMessage("No Internet Connection"),
    "no_internet_message" : MessageLookupByLibrary.simpleMessage(" Please Check your internet settings."),
    "operation_failed" : MessageLookupByLibrary.simpleMessage("Operation Failed")
  };
}
