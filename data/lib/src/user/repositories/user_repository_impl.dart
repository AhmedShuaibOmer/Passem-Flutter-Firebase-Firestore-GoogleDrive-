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

  @override
  void dispose() {
    _firestoreService.dispose();
  }

  @override
  Future<Either<Failure, void>> updateUser({
    String name,
    String photoUrl = '',
    String role,
    String universityId,
    String collegeId,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        if (name != null) await _firebaseAuthService.updateUserName(name);

        if (photoUrl != '') _firebaseAuthService.updateUserProfilePic(photoUrl);

        await _firestoreService.updateUser(
          name: name,
          role: role,
          universityId: universityId,
          collegeId: collegeId,
          photoUrl: photoUrl,
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

  @override
  Stream<List<UserEntity>> get mostContributors =>
      _firestoreService.mostContributors();

  @override
  Future<Either<Failure, void>> subscribeToCourse(String courseId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _firestoreService.subscribeToCourse(
          courseId: courseId,
        );
        return Right(() {});
      } catch (e) {
        print(e);
        return Left(SubscribeToCourseFailure());
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> unsubscribeFromCourse(String courseId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _firestoreService.unsubscribeFromCourse(
          courseId: courseId,
        );
        return Right(() {});
      } catch (e) {
        print(e);
        return Left(UnsubscribeFromCourseFailure());
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addMaterialToStarred(String materialId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _firestoreService.addMaterialToStarred(
          materialId: materialId,
        );
        return Right(() {});
      } catch (e) {
        print(e);
        return Left(StarringMaterialFailure());
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removeMaterialFromStarred(
      String materialId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _firestoreService.removeMaterialFromStarred(
          materialId: materialId,
        );
        return Right(() {});
      } catch (e) {
        print(e);
        return Left(UnStarringMaterialFailure());
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }
}
