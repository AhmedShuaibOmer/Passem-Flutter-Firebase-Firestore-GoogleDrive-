/*
 * Created Date: 2/18/21 6:21 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../di/di.dart';
import '../../../generated/l10n.dart';
import '../../../router/router.dart';
import '../../../widgets/widget.dart';

class LoginView extends StatelessWidget {
  final ProgressButtonController _progressButtonController =
      ProgressButtonController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (BuildContext context, state) {
        _setButtonState(state.status);
        if (state.status == AuthenticationStatus.authenticationFailed) {
          OperationFailedAlert(
            context,
            message: S.of(context).login_with_google_failure,
          ).show(context);
        } else if (state.status == AuthenticationStatus.authenticated) {
          ExtendedNavigator.of(context).pushAndRemoveUntil(
            Routes.mainScreen,
            (route) => false,
          );
        } else if (state.status == AuthenticationStatus.newUserAuthenticated) {
          ExtendedNavigator.of(context).pushAndRemoveUntil(
            Routes.newUserScreen,
            (route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0.2 * MediaQuery.of(context).size.height,
                right: 32,
                left: 32,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        S.of(context).intro,
                        style: Theme.of(context).textTheme.headline4.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Flexible(
                      child: Text(
                        S.of(context).intro_2,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: Colors.white70),
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                top: .8 * MediaQuery.of(context).size.height,
                width: 300,
                child: ProgressButton(
                  child: _buttonContent(context),
                  onPressed: () {
                    _onPressed(context);
                  },
                  controller: _progressButtonController,
                  progressColor: Theme.of(context).primaryColor,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _buttonContent(BuildContext context) {
    return Container(
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          Container(
            height: 32.0,
            width: 32.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/google-icon.png'),
                fit: BoxFit.cover,
              ),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Text(
              S.of(context).google_sign_in_button,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  void _setButtonState(AuthenticationStatus status) {
    switch (status) {
      case AuthenticationStatus.loading:
        {
          _progressButtonController
              .setButtonState(ProgressButtonState.inProgress);
          break;
        }
      case AuthenticationStatus.authenticationFailed:
        {
          _progressButtonController.setButtonState(ProgressButtonState.error);
          break;
        }
      default:
        {
          _progressButtonController.setButtonState(ProgressButtonState.normal);
          break;
        }
    }
  }

  Future<void> _onPressed(BuildContext context) async {
    final NetworkInfo networkInfo = sl<NetworkInfo>();
    if (await networkInfo.isConnected) {
      context.read<AuthenticationBloc>().add(
            AuthenticationLoginRequested(),
          );
    } else {
      NoConnectionAlert(
        context,
        specificMessage: S.of(context).login_no_internet_failure,
      ).show(context);
    }
  }
}
