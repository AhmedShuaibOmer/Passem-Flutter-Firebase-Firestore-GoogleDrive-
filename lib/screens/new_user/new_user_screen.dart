/*
 * Created Date: 2/13/21 12:51 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021 SafePass
 *
 */

import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passem/di/di.dart';

import 'view/new_user_view.dart';

class NewUserScreen extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => NewUserScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NewUserCubit>(),
      child: NewUserView(),
    );
  }
}
