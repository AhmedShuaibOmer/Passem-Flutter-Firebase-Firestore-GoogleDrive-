/*
 * Created Date: 2/17/21 5:05 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021 SafePass
 *
 */

import 'package:dartz/dartz.dart';

import '../../../domain.dart';

abstract class UserRepository {
  /// Stream of the most contributed users based on the numer of materials
  /// they added to the platform.
  Stream<List<UserEntity>> get mostContributors;

  Future<Either<Failure, void>> updateUser({
    String name,
    String role,
    String universityId,
    String collegeId,
    String photoUrl,
  });

  Future<Either<Failure, void>> subscribeToCourse(String courseId);

  Future<Either<Failure, void>> unsubscribeFromCourse(String courseId);

  Future<Either<Failure, void>> addMaterialToStarred(String materialId);

  Future<Either<Failure, void>> removeMaterialFromStarred(String materialId);

  /// Used to clean or the resources from the memory.
  void dispose();
}
