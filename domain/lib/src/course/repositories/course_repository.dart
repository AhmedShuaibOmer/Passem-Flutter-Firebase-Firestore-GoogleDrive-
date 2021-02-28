/*
 * Created Date: 2/26/21 12:36 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:dartz/dartz.dart';

import '../../core/core.dart';
import '../entities/course_entity.dart';

abstract class CourseRepository {
  Future<Either<Failure, List<CourseEntity>>> getCourses(List<String> courses);

  /// Creates a new course .
  /// returns the new course id.
  Future<Either<Failure, String>> addCourse(String name);

  Future<Either<Failure, void>> deleteCourse(String courseId);

  Future<Either<Failure, void>> updateCourse(CourseEntity course);
}
