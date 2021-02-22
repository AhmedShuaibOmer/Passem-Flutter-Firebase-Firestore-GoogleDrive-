/*
 * Created Date: 2/22/21 8:51 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:flutter/material.dart';

import 'view/main_view.dart';

class MainScreen extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => MainScreen());
  }

  @override
  Widget build(BuildContext context) {
    return MainView();
  }
}
