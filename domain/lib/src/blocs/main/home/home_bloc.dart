/*
 * Created Date: 2/26/21 2:32 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../study_material/study_material.dart';
import '../../../user/user.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final StudyMaterialRepository _studyMaterialRepository;
  final UserRepository _userRepository;

  HomeBloc({
    StudyMaterialRepository studyMaterialRepository,
    UserRepository userRepository,
  })  : assert(studyMaterialRepository != null),
        assert(userRepository != null),
        this._userRepository = userRepository,
        this._studyMaterialRepository = studyMaterialRepository,
        super(HomeInitial());

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
