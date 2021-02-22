/*
 * Created Date: 2/19/21 7:51 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain.dart';

part 'new_user_state.dart';

class NewUserCubit extends Cubit<NewUserState> {
  NewUserCubit({
    @required UniversityRepository universityRepository,
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        assert(universityRepository != null),
        this._userRepository = userRepository,
        this._universityRepository = universityRepository,
        super(NewUserState.unknown()) {
    _universityRepository.getAllUniversities().then((value) {
      value.fold((l) {
        // TODO Handle universities Fetching failure.
      }
     , (r) {
        universities.addAll(r);
      });
    });
  }

  final UserRepository _userRepository;
  final UniversityRepository _universityRepository;

  List<UniversityEntity> universities = [];
  UniversityEntity selectedUniversity;

  Future<void> submitDetails() async {
    if (selectedUniversity == null) {
      emit(NewUserState.failure());
      return;
    }
    await _userRepository
        .updateUser(
          universityId: selectedUniversity.id,
        )
        .then((value) => value.fold((error) {
              if (error is NoConnectionFailure) {
                emit(NewUserState.noConnectionFailure());
              } else if (error is UserUpdateFailure) {
                emit(NewUserState.failure());
              }
            }, (r) => emit(NewUserState.success())));
  }
}
