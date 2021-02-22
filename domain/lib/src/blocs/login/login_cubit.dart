/*
 * Created Date: 2/18/21 11:23 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:bloc/bloc.dart';
import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationRepository _authenticationRepository;

  LoginCubit({
    @required AuthenticationRepository authenticationRepository,
  })  : assert(authenticationRepository != null),
        this._authenticationRepository = authenticationRepository,
        super(LoginState.unknown());

  Future<void> loginWithGoogle() async {
    final result = await _authenticationRepository.loginWithGoogle();
    result.fold((left) {
      if (left is NoConnectionFailure) {
        emit(LoginState.noConnectionFailure());
      } else if (left is LogInFailure) {
        emit(LoginState.failure());
      }
    }, (right) => emit(LoginState.success()));
  }
}
