/*
 * Created Date: 2/27/21 11:31 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:dartz/dartz.dart';
import 'package:domain/domain.dart';
import 'package:meta/meta.dart';

import '../../services/services.dart';
import '../models/course_model.dart';

class CourseRepositoryImpl extends CourseRepository {
  final FirestoreService _firestoreService;
  final NetworkInfo _networkInfo;

  CourseRepositoryImpl({
    @required FirestoreService firestoreService,
    @required NetworkInfo networkInfo,
  })  : assert(firestoreService != null),
        assert(networkInfo != null),
        this._firestoreService = firestoreService,
        this._networkInfo = networkInfo;

  @override
  Future<Either<Failure, String>> addCourse(String name) async {
    if (await _networkInfo.isConnected) {
      try {
        String courseId;
        await _firestoreService
            .addCourse(
              courseName: name,
            )
            .then((value) => courseId = value);
        return Right(courseId);
      } catch (e) {
        print(e);
        return Left(CourseCreateFailure());
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteCourse(String courseId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _firestoreService.deleteCourse(
          courseId: courseId,
        );
        return Right(() {});
      } catch (e) {
        print(e);
        return Left(CourseDeleteFailure());
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<CourseEntity>>> getCourses(
      List<String> coursesIds) async {
    try {
      List<Course> courses;
      await _firestoreService
          .getCourses(coursesIds)
          .then((value) => courses = value);
      return Right(courses);
    } catch (e) {
      if (await _networkInfo.isConnected) return Left(NoConnectionFailure());
      return Left(CoursesFetchingFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateCourse(CourseEntity course) async {
    if (await _networkInfo.isConnected) {
      try {
        await _firestoreService.updateCourse(
          courseId: course.id,
          name: course.name,
        );
        return Right(() {});
      } catch (e) {
        print(e);
        return Left(CourseUpdateFailure());
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }
}
