/*
 * Created Date: 1/24/21 1:31 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021 SafePass
 *
 */
import 'package:formz/formz.dart';

enum PasswordValidationError { empty }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([String value = '']) : super.dirty(value);

  @override
  PasswordValidationError validator(String value) {
    return value?.isNotEmpty == true ? null : PasswordValidationError.empty;
  }
}
