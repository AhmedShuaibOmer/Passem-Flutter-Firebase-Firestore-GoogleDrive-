/*
 * Created Date: 2/28/21 1:03 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:dartz/dartz.dart';

import '../../../domain.dart';
import '../entities/college_entity.dart';

abstract class CollegeRepository {
  /// The college for the current authenticated user.
  ///
  /// Throws a [CollegeFetchingFailure] if an exception occurs.
  Future<Either<Failure, CollegeEntity>> get currentUserCollege;

  // TODO : Implement searching functionality, Fetching all documents just to pick one is very expensive bad practice.
  /// Gets a list of all stored colleges inside the university attached
  /// to the provided universityId.
  ///
  /// Throws a [CollegeFetchingFailure] if an exception occurs.
  Future<Either<Failure, List<CollegeEntity>>> getAllColleges(
      String universityId);
}
