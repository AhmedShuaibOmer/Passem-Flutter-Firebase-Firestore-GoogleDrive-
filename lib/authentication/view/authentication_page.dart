/*
 * Created Date: 1/28/21 5:58 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021 SafePass
 *
 */

import 'package:flutter/material.dart';
import 'package:safe_pass/login/login.dart';
import 'package:safe_pass/signup/signup.dart';

class AuthenticationPage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => AuthenticationPage());
  }

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  PageController _controller = PageController(
    initialPage: 1,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      children: <Widget>[
        SignUpPage(),
        LoginPage(
          onRegisterButtonTapped: () => switchPage(0),
        ),
      ],
    );
  }

  void switchPage(int index) {
    _controller.animateToPage(
      index,
      duration: Duration(milliseconds: 400),
      curve: Curves.linear,
    );
  }
}
