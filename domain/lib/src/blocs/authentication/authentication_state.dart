/*
 *
 *  Created Date: 1/24/21 12:41 AM
 *  Author: Ahmed S.Omer
 *
 * Copyright (c) 2021 SafePass
 *
 */

part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.user = UserEntity.empty,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(UserEntity user)
      : this._(status: AuthenticationStatus.authenticated, user: user);

  const AuthenticationState.newUserAuthenticated(UserEntity user)
      : this._(status: AuthenticationStatus.newUserAuthenticated, user: user);

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  final AuthenticationStatus status;
  final UserEntity user;

  @override
  List<Object> get props => [status, user];
}
