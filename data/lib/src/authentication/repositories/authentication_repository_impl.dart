/*
 * Created Date: 2/8/21 3:28 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021 SafePass
 *
 */
import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:meta/meta.dart';

import '../../services/services.dart';

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  final FirestoreService _firestoreService;
  final FirebaseAuthService _firebaseAuthService;

  AuthenticationRepositoryImpl({
    @required FirebaseAuthService firebaseAuthService,
    @required FirestoreService firestoreService,
  })  : assert(firebaseAuthService != null),
        assert(firestoreService != null),
        this._firebaseAuthService = firebaseAuthService,
        this._firestoreService = firestoreService;

  //start listening for the authentication changes.
  @override
  Stream<UserEntity> get user async* {
    // Check from cache if there is  user authenticated.
    final currentUser = _firebaseAuthService.currentUser;

    // null if there's no user authenticated.
    if (currentUser == null) {
      yield UserEntity.empty;
    } else {
      _firestoreService.getUser();
    }
    // start listening to the stream of user changes.
    yield* _firestoreService.userChanges;
  }

  @override
  Future<Either<Failure, void>> loginWithGoogle() async {
    try {
      final isNewUser = await _firebaseAuthService.logInWithGoogle();
      if (isNewUser) {
        final newUser = User(
            id: _firebaseAuthService.currentUser.id,
            name: _firebaseAuthService.currentUser.name,
            email: _firebaseAuthService.currentUser.email,
            photoUrl: _firebaseAuthService.currentUser.photoUrl,
            universityId: 'wpn9pji2pF2YNLUMBFE0',
            collegeId: 'gsOREW8tgC0zjDbbjn3x');
        await _firestoreService.addNewUser(newUser);
      } else {
        await _firestoreService.getUser();
      }
      return Right(() {});
    } catch (e) {
      print('login failed: $e');
      return Left(LogInFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logOutUser() async {
    try {
      await _firebaseAuthService.logoutUser();
      _firestoreService.userLoggedOut();
      return Right(() {});
    } catch (e) {
      print('LogOut failed: $e');
      return Left(LogOutFailure());
    }
  }
}
