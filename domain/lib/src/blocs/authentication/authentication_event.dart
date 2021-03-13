/*
 * Created Date: 1/24/21 1:41 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021 SafePass
 *
 */

part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class AuthenticationUserChanged extends AuthenticationEvent {
  const AuthenticationUserChanged(this.user);

  final UserEntity user;

  @override
  List<Object> get props => [user];
}

class AuthenticationLoginRequested extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}
class AuthenticationLogoutRequested extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}
