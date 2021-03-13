/*
 * Created Date: 3/12/21 9:59 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

part of 'course_bloc.dart';

@immutable
abstract class CourseState {
  final CourseEntity courseEntity;

  CourseState({this.courseEntity});
}

class CourseInitial extends CourseState {}

class CourseLoaded extends CourseState {
  final CourseEntity courseEntity;

  CourseLoaded(this.courseEntity) : super(courseEntity: courseEntity);
}

class CourseNotFound extends CourseState {}

class CourseFetchFailure extends CourseState {}
