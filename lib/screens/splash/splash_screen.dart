/*
 * Created Date: 1/24/21 1:26 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021 SafePass
 *
 */
import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../router/router.dart';

class SplashScreen extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SplashScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        print(state.status);
        switch (state.status) {
          case AuthenticationStatus.authenticated:
            ExtendedNavigator.of(context).pushAndRemoveUntil(
              Routes.mainScreen,
              (route) => false,
            );
            break;
          case AuthenticationStatus.newUserAuthenticated:
            ExtendedNavigator.of(context).pushAndRemoveUntil(
              Routes.newUserScreen,
              (route) => false,
            );
            break;
          case AuthenticationStatus.unauthenticated:
            ExtendedNavigator.of(context).pushAndRemoveUntil(
              Routes.loginScreen,
              (route) => false,
            );
            break;
          default:
            break;
        }
      },
      child: const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
