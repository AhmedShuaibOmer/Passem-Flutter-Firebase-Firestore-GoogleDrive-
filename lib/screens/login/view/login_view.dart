/*
 * Created Date: 2/18/21 6:21 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../generated/l10n.dart';
import '../../../widgets/widget.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (BuildContext context, state) {
        switch (state.status) {
          case LoginStatus.noConnectionFailure:
            {
              NoConnectionAlert(
                context,
                specificMessage: S.of(context).login_no_internet_failure,
              ).show(context);
              break;
            }
          case LoginStatus.loginFailure:
            {
              OperationFailedAlert(
                context,
                message: S.of(context).login_with_google_failure,
              ).show(context);
              break;
            }
          case LoginStatus.loginSuccess:
          case LoginStatus.unknown:
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: .7 * MediaQuery.of(context).size.height,
              child: ProgressButton(
                defaultWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                    Text(
                      S.of(context).google_sign_in_button,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                progressWidget: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).accentColor),
                ),
                color: Theme.of(context).primaryColorLight,
                height: 56,
                borderRadius: 28,
                onPressed: () async {
                  await context.read<LoginCubit>().loginWithGoogle();
                  // After [onPressed], it will trigger animation running backwards, from end to beginning
                  return () {
                    // Optional returns is returning a VoidCallback that will be called
                    // after the animation is stopped at the beginning.
                    // A best practice would be to do time-consuming task in [onPressed],
                    // and do page navigation in the returned VoidCallback.
                    // So that user won't missed out the reverse animation.
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
