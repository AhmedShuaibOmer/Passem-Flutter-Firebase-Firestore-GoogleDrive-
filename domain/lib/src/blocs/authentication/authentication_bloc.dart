/*
 * Created Date: 2/6/21 10:52 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021 SafePass
 *
 */

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    @required AuthenticationRepository authenticationRepository,
    @required UserRepository userRepository,
    @required UniversityRepository universityRepository,
    @required CollegeRepository collegeRepository,
  })  : assert(authenticationRepository != null),
        assert(userRepository != null),
        assert(universityRepository != null),
        assert(collegeRepository != null),
        _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        _universityRepository = universityRepository,
        _collegeRepository = collegeRepository,
        super(const AuthenticationState.unknown()) {
    // Start listening to status change stream as soon as the bloc created.
    _statusSubscription = _authenticationRepository.status.listen((status) {
      _currentStatus = status;
      add(
        AuthenticationStatusChanged(status),
      );
    });

    _userSubscription = _userRepository.userChanges.listen((user) {
      add(
        AuthenticationUserChanged(user),
      );
      print('User changes received a value.');
    });
  }

  final AuthenticationRepository _authenticationRepository;
  StreamSubscription<AuthenticationStatus> _statusSubscription;
  final UserRepository _userRepository;
  StreamSubscription<UserEntity> _userSubscription;
  final UniversityRepository _universityRepository;
  final CollegeRepository _collegeRepository;
  AuthenticationStatus _currentStatus;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationStatusChanged) {
      yield await _mapAuthenticationStatusChangedToState(event);
    } else if (event is AuthenticationUserChanged) {
      yield await _mapAuthenticationUserChangedToState(event);
    } else if (event is AuthenticationLogoutRequested) {
      _authenticationRepository.logOutUser();
    }
  }

  Future<AuthenticationState> _mapAuthenticationStatusChangedToState(
    AuthenticationStatusChanged event,
  ) async {
    final status = event.status;

    if (status == AuthenticationStatus.unauthenticated) {
      return const AuthenticationState.unauthenticated();
    } else if (status == AuthenticationStatus.authenticated ||
        status == AuthenticationStatus.newUserAuthenticated) {
      _userRepository.tryFetchUser().then((value) {
        if (value.isLeft()) {
          return AuthenticationState.authenticationFailed();
        }
      });
    }
  }

  Future<AuthenticationState> _mapAuthenticationUserChangedToState(
    AuthenticationUserChanged event,
  ) async {
    print('Mapping User changes event to state...');

    final currentUser = event.user;

    print('Status: $_currentStatus');

    if (_currentStatus == AuthenticationStatus.authenticated) {
      UniversityEntity currentUserUniversity;
      CollegeEntity currentUserCollege;
      await _universityRepository.currentUserUniversity
          .then((value) => value.fold((left) {
                return AuthenticationState.authenticationFailed();
              }, (right) {
                currentUserUniversity = right;
              }));
      await _collegeRepository.currentUserCollege
          .then((value) => value.fold((left) {
                return AuthenticationState.authenticationFailed();
              }, (right) {
                currentUserCollege = right;
              }));
      print('authenticated state yielded.');
      return AuthenticationState.authenticated(
        currentUser: currentUser,
        currentUserUniversity: currentUserUniversity,
        currentUserCollege: currentUserCollege,
      );
    } else if (_currentStatus == AuthenticationStatus.newUserAuthenticated) {
      _currentStatus = AuthenticationStatus.authenticated;
      print('newUserAuthenticated state yielded.');
      return AuthenticationState.newUserAuthenticated(currentUser);
    }
  }

  @override
  Future<void> close() {
    _statusSubscription.cancel();
    _authenticationRepository.dispose();
    _userSubscription.cancel();
    _userRepository.dispose();
    return super.close();
  }
}
