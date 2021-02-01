/*
 * Created Date: 1/24/21 1:35 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021 SafePass
 *
 */
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_pass/login/login.dart';

import 'login_form.dart';

class LoginPage extends StatelessWidget {
  final void Function() onRegisterButtonTapped;

  const LoginPage({Key key, this.onRegisterButtonTapped}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          return LoginBloc(
            authenticationRepository:
                RepositoryProvider.of<AuthenticationRepository>(context),
          );
        },
        child: LoginForm(
          onRegisterButtonTapped: onRegisterButtonTapped,
        ),
      ),
    );
  }
}
