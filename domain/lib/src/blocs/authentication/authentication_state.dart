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
    this.userUniversity = UniversityEntity.empty,
    this.userCollege = CollegeEntity.empty,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated({
    UserEntity currentUser,
    UniversityEntity currentUserUniversity,
    CollegeEntity currentUserCollege,
  }) : this._(
          status: AuthenticationStatus.authenticated,
          user: currentUser,
          userUniversity: currentUserUniversity,
          userCollege: currentUserCollege,
        );

  const AuthenticationState.newUserAuthenticated(UserEntity user)
      : this._(status: AuthenticationStatus.newUserAuthenticated, user: user);

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  const AuthenticationState.authenticationFailed()
      : this._(status: AuthenticationStatus.authenticationFailed);

  final AuthenticationStatus status;
  final UserEntity user;
  final UniversityEntity userUniversity;
  final CollegeEntity userCollege;

  @override
  List<Object> get props => [status, user, userUniversity, userCollege];
}
