/*
 * Created Date: 2/22/21 8:51 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passem/di/di.dart';
import 'package:passem/screens/main/view/main_content.dart';

import 'bloc/navigation_bloc.dart';

class MainScreen extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => MainScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NavigationBloc>(),
      child: MainContent(),
    );
  }
}
