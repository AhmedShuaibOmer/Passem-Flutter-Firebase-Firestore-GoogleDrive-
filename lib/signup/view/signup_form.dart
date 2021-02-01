/*
 * Created Date: 1/28/21 6:11 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021 SafePass
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_pass/authentication/authentication.dart';
import 'package:safe_pass/signup/signup.dart';

class SignUpForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        /*if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Authentication Failure')),
            );
        }*/
      },
      child: Scaffold(
          body: Container(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: CustomPaint(
                size: size,
                painter: SignUpBackgroundPainter(),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
