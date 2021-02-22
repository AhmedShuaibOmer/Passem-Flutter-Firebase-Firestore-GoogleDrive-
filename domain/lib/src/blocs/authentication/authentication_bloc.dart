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
  })  : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
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
  AuthenticationStatus _currentStatus;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationStatusChanged) {
      yield* _mapAuthenticationStatusChangedToState(event);
    } else if (event is AuthenticationUserChanged) {
      yield* _mapAuthenticationUserChangedToState(event);
    } else if (event is AuthenticationLogoutRequested) {
      _authenticationRepository.logOutUser();
    }
  }

  Stream<AuthenticationState> _mapAuthenticationStatusChangedToState(
    AuthenticationStatusChanged event,
  ) async* {
    final status = event.status;

    if (status == AuthenticationStatus.unauthenticated) {
      yield const AuthenticationState.unauthenticated();
    } else if (status == AuthenticationStatus.authenticated ||
        status == AuthenticationStatus.newUserAuthenticated) {
      _userRepository.tryFetchUser().then((value) {
        if (value.isLeft()) {
          // TODO: Handle failed fetching user Failure.
        }
      });
    }
  }

  Stream<AuthenticationState> _mapAuthenticationUserChangedToState(
    AuthenticationUserChanged event,
  ) async* {
    print('Mapping User changes event to state...');

    final currentUser = event.user;

    print('Status: $_currentStatus');

    if (_currentStatus == AuthenticationStatus.authenticated) {
      yield AuthenticationState.authenticated(currentUser);
      print('authenticated state yielded.');
    } else if (_currentStatus == AuthenticationStatus.newUserAuthenticated) {
      yield AuthenticationState.newUserAuthenticated(currentUser);
      _currentStatus = AuthenticationStatus.authenticated;

      print('newUserAuthenticated state yielded.');
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
