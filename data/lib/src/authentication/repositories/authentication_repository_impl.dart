/*
 * Created Date: 2/8/21 3:28 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021 SafePass
 *
 */
import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:domain/domain.dart';
import 'package:meta/meta.dart';

import '../../services/services.dart';

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  final FirestoreService _firestoreService;
  final FirebaseAuthService _firebaseAuthService;
  final NetworkInfo _networkInfo;

  AuthenticationRepositoryImpl({
    @required FirebaseAuthService firebaseAuthService,
    @required FirestoreService firestoreService,
    @required NetworkInfo networkInfo,
  })  : assert(firebaseAuthService != null),
        assert(firestoreService != null),
        assert(networkInfo != null),
        this._firebaseAuthService = firebaseAuthService,
        this._firestoreService = firestoreService,
        this._networkInfo = networkInfo;

  /// Controls the [status] stream to emit the currently authentication status.
  final _controller = StreamController<AuthenticationStatus>();

  //start listening for the authentication changes.
  @override
  Stream<AuthenticationStatus> get status async* {
    // Check from cache if there is  user authenticated.
    final currentUser = _firebaseAuthService.currentUser;

    // null if there's no user authenticated.
    if (currentUser == null) {
      yield AuthenticationStatus.unauthenticated;
    } else {
      yield AuthenticationStatus.authenticated;
    }
    // start listening to the stream of authentication status.
    yield* _controller.stream;
  }

  @override
  Future<Either<Failure, void>> loginWithGoogle() async {
    if (await _networkInfo.isConnected) {
      try {
        final isNewUser = await _firebaseAuthService.logInWithGoogle();
        if (isNewUser) {
          final newUser = _firebaseAuthService.currentUser;
          _firestoreService.addNewUser(newUser);
          _controller.add(AuthenticationStatus.newUserAuthenticated);
        } else {
          _controller.add(AuthenticationStatus.authenticated);
        }
        return Right(() {});
      } catch (e) {
        print('login failed: $e');
        return Left(LogInFailure());
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> requestDrivePermission() async {
    if (await _networkInfo.isConnected) {
      try {
        final remoteData = await _firebaseAuthService.requestDrivePermission();
        return Right(remoteData);
      } catch (e) {
        return Left(RequestPermissionFailure());
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logOutUser() async {
    if (await _networkInfo.isConnected) {
      try {
        await _firebaseAuthService.logoutUser();
        _controller.add(AuthenticationStatus.unauthenticated);
        return Right(() {});
      } catch (e) {
        print('LogOut failed: $e');
        return Left(LogOutFailure());
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }

  @override
  void dispose() {
    _controller.close();
  }
}
