/*
 * Created Date: 2/28/21 1:18 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:dartz/dartz.dart';
import 'package:domain/domain.dart';

import '../../services/services.dart';
import '../models/college_model.dart';

class CollegeRepositoryImpl extends CollegeRepository {
  final FirestoreService _firestoreService;

  CollegeRepositoryImpl({FirestoreService firestoreService})
      : assert(firestoreService != null),
        this._firestoreService = firestoreService;

  @override
  Future<Either<Failure, CollegeEntity>> get currentUserCollege async {
    try {
      College college;
      await _firestoreService
          .getCollege()
          .then((value) => college = value);
      return Right(college);
    } catch (e) {
      return Left(CollegeFetchingFailure());
    }
  }

  @override
  Future<Either<Failure, List<CollegeEntity>>> getAllColleges(
      String universityId) async {
    try {
      final colleges = await _firestoreService.getAllColleges(universityId);
      return Right(colleges);
    } catch (e) {
      print('Fetch all universities failed: $e');
      return Left(UniversityFetchingFailure());
    }
  }
}