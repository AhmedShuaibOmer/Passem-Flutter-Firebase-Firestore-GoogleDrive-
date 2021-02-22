/*
 * Created Date: 2/17/21 2:40 PM
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

class UserRepositoryImpl extends UserRepository {
  final FirestoreService _firestoreService;
  final FirebaseAuthService _firebaseAuthService;
  final NetworkInfo _networkInfo;

  UserRepositoryImpl({
    @required FirebaseAuthService firebaseAuthService,
    @required FirestoreService firestoreService,
    @required NetworkInfo networkInfo,
  })  : assert(firebaseAuthService != null),
        assert(firestoreService != null),
        assert(networkInfo != null),
        this._firebaseAuthService = firebaseAuthService,
        this._firestoreService = firestoreService,
        this._networkInfo = networkInfo;

  final _controller = StreamController<UserEntity>();

  @override
  Stream<UserEntity> get userChanges async* {
    yield* _controller.stream;
  }

  @override
  Future<Either<Failure, void>> tryFetchUser() async {
    try {
      final currentUserId = _firebaseAuthService.currentUserId;
      _firestoreService.getUser(userId: currentUserId).then((value) {
        _controller.add(value);
        print('User Entity emitted : $value');
      });
      return Right(() {});
    } catch (e) {
      return Left(UserFetchingFailure());
    }
  }

  @override
  void dispose() {
    _controller.close();
  }

  @override
  Future<Either<Failure, void>> updateUser({
    String name,
    String photoUrl = '',
    String role,
    String universityId,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final currentUserId = _firebaseAuthService.currentUserId;

        if (name != null) await _firebaseAuthService.updateUserName(name);

        if (photoUrl != '') _firebaseAuthService.updateUserProfilePic(photoUrl);

        await _firestoreService.updateUser(
          userId: currentUserId,
          name: name,
          role: role,
          universityId: universityId,
          photoUrl: photoUrl,
        );
        _controller.add(
          await _firestoreService.getUser(
            userId: currentUserId,
          ),
        );
        return Right(() {});
      } catch (e) {
        print(e);
        return Left(UserUpdateFailure());
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }
}
