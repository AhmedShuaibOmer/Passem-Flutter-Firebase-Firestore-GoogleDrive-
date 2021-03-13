/*
 * Created Date: 3/11/21 3:57 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

part of 'my_courses_bloc.dart';

abstract class MyCoursesEvent {}

class CoursesIdsChanged extends MyCoursesEvent {
  final List<String> coursesIds;

  CoursesIdsChanged(this.coursesIds);
}
