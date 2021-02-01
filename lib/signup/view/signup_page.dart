/*
 * Created Date: 1/28/21 6:11 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021 SafePass
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_pass/signup/bloc/sign_up_bloc.dart';
import 'package:user_repository/user_repository.dart';

import 'signup_form.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          return SignUpBloc(
            userRepository: RepositoryProvider.of<UserRepository>(context),
          );
        },
        child: SignUpForm(),
      ),
    );
  }
}
