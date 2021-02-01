/*
 * Created Date: 1/24/21 1:32 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021 SafePass
 *
 */

import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:formz/formz.dart';
import 'package:safe_pass/authentication/authentication.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends FormBloc<String, String> {
  final email = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      FieldBlocValidators.email,
    ],
  );

  final password = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  LoginBloc({
    @required AuthenticationRepository authenticationRepository,
  })  : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository {
    addFieldBlocs(
      fieldBlocs: [
        email,
        password,
      ],
    );
  }

  final AuthenticationRepository _authenticationRepository;

  @override
  void onSubmitting() async {
    print(email.value);
    print(password.value);

    try {
      String token = await _authenticationRepository.logIn(
        username: email.value,
        password: password.value,
      );
      if (token != null) {
        emitSuccess();
      }
    } on Exception catch (_) {
      emitFailure();
    }
  }
}
