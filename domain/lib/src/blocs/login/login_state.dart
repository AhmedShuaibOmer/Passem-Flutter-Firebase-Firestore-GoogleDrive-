/*
 * Created Date: 2/18/21 11:23 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

part of 'login_cubit.dart';

enum LoginStatus { loginSuccess, loginFailure, noConnectionFailure, unknown }

class LoginState extends Equatable {
  const LoginState._({this.status = LoginStatus.unknown});

  const LoginState.unknown() : this._();

  const LoginState.success()
      : this._(status: LoginStatus.loginSuccess);

  const LoginState.failure()
      : this._(status: LoginStatus.loginFailure);

  const LoginState.noConnectionFailure()
      : this._(status: LoginStatus.noConnectionFailure);

  final LoginStatus status;

  @override
  List<Object> get props => [status];
}
