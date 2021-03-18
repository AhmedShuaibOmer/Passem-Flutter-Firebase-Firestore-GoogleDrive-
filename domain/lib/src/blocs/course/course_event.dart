/*
 * Created Date: 3/12/21 9:59 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

part of 'course_bloc.dart';

@immutable
abstract class CourseEvent {}

class CourseRefreshRequested extends CourseEvent {}

class CourseStarted extends CourseEvent {
  final String courseId;
  final CourseEntity courseEntity;

  CourseStarted(this.courseId, this.courseEntity);
}
