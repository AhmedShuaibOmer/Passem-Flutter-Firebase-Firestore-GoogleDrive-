/*
 * Created Date: 2/20/21 10:54 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:dartz/dartz.dart';
import 'package:data/src/services/services.dart';
import 'package:domain/domain.dart';

class UniversityRepositoryImpl extends UniversityRepository {
  final FirestoreService _firestoreService;

  UniversityRepositoryImpl({FirestoreService firestoreService})
      : assert(firestoreService != null),
        this._firestoreService = firestoreService;

  @override
  Future<Either<Failure, List<UniversityEntity>>> getAllUniversities() async {
    try {
      final universities = await _firestoreService.getAllUniversities();
      return Right(universities);
    } catch (e) {
      print('Fetch all universities failed: $e');
      return Left(UniversityFetchingFailure());
    }
  }
}
