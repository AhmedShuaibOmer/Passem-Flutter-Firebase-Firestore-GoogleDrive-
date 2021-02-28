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

part 'starred_event.dart';
part 'starred_state.dart';

class StarredBloc extends Bloc<StarredEvent, StarredState> {
  StarredBloc() : super(StarredInitial());

  @override
  Stream<StarredState> mapEventToState(
    StarredEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
