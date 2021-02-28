/*
 * Created Date: 2/19/21 9:40 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:dartz/dartz.dart';

import '../../../domain.dart';
import '../entities/university_entity.dart';

abstract class UniversityRepository {
  /// The university for the current authenticated user.
  Future<Either<Failure, UniversityEntity>> get currentUserUniversity;

  // TODO : Implement searching functionality, Fetching all documents just to pick one is very expensive bad practice.
  /// Gets a list of all stored universities.
  ///
  /// Throws a [UniversityFetchingFailure] if an exception occurs.
  Future<Either<Failure, List<UniversityEntity>>> getAllUniversities();
}
