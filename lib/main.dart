/*
 * 
 * Created Date: Friday, January 22nd 2021, 11:12:20 am
 * Author: Ahmed S.Omer
 * 
 * Copyright (c) 2021 SafePass
 */
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_pass/app.dart';
import 'package:safe_pass/theme/bloc/theme_bloc.dart';
import 'package:user_repository/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AuthenticationRepository authenticationRepository =
      await AuthenticationRepository.getInstance();

  UserRepository userRepository = await UserRepository.getInstance();

  runApp(
    BlocProvider(
      create: (_) => ThemeBloc()..add(ThemeLoadStarted()),
      child: App(
        authenticationRepository: authenticationRepository,
        userRepository: userRepository,
      ),
    ),
  );
}
