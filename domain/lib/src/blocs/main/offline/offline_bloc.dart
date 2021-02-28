/*
 * Created Date: 2/26/21 2:33 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'offline_event.dart';
part 'offline_state.dart';

class OfflineBloc extends Bloc<OfflineEvent, OfflineState> {
  OfflineBloc() : super(OfflineInitial());

  @override
  Stream<OfflineState> mapEventToState(
    OfflineEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
