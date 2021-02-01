/*
 * Created Date: 1/24/21 1:36 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021 SafePass
 *
 */
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safe_pass/authentication/authentication.dart';
import 'package:safe_pass/login/login.dart';
import 'package:safe_pass/theme/theme.dart';

class LoginForm extends StatelessWidget {
  final void Function() onRegisterButtonTapped;

  const LoginForm({Key key, this.onRegisterButtonTapped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    bool isSubmitting = false;
    return Builder(
      builder: (context) {
        final loginBloc = context.watch<LoginBloc>();

        return Scaffold(
          body: FormBlocListener<LoginBloc, String, String>(
            onSubmitting: (context, state) {
              isSubmitting = true;
            },
            onSuccess: (context, state) {
              isSubmitting = false;
            },
            onFailure: (context, state) {
              isSubmitting = false;

              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('Authentication Failure')),
                );
            },
            child: Container(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: height * .15,
                    child:
                        Container(width: width, child: Center(child: _Title())),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: CustomPaint(
                      size: size,
                      painter: LoginBackgroundPainter(),
                    ),
                  ),
                  Container(
                    height: height,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: height * .35,
                          ),
                          FormTextField(
                            prefixIcon: Icons.mail_outline_rounded,
                            textFieldBloc: loginBloc.email,
                            keyboardType: TextInputType.emailAddress,
                            hintText: 'Type your Email address',
                            hasError: loginBloc.email.state.canShowError,
                          ),
                          FormTextField(
                            prefixIcon: Icons.lock_outline_rounded,
                            textFieldBloc: loginBloc.password,
                            hintText: 'Type your Password',
                            suffixButton: SuffixButton.obscureText,
                            suffixIconConstraints: BoxConstraints(
                              maxHeight: 24,
                              maxWidth: 24,
                            ),
                            hasError: loginBloc.password.state.canShowError,
                          ),
                          SizedBox(
                            height: 38,
                          ),
                          SubmitButton(
                            key: const Key('loginForm_continue_submitButton'),
                            onPressed: loginBloc.submit,
                            label: 'Login',
                            isSubmitting: isSubmitting,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 32),
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                              child: Text(
                                'Forget your password?',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: height * .9,
                    left: 0,
                    child: _createAccountLabel(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _createAccountLabel() {
    return Container(
      padding: EdgeInsets.all(15),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Don\'t have an account ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          TextButton(
            onPressed: onRegisterButtonTapped,
            child: Text(
              'Register',
            ),
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'SAFEPASS',
        style: GoogleFonts.portLligatSans(
          textStyle: Theme.of(context).textTheme.headline4,
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: MyColors.primaryColor,
        ),
      ),
    );
  }
}
