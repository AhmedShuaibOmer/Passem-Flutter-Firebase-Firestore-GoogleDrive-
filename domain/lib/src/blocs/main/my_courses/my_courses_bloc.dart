/*
 * Created Date: 2/26/21 2:32 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../course/course.dart';

part 'my_courses_event.dart';

part 'my_courses_state.dart';

class MyCoursesBloc extends Bloc<MyCoursesEvent, MyCoursesState> {
  final CourseRepository _courseRepository;
  MyCoursesBloc({CourseRepository courseRepository})
      : assert(courseRepository != null),
        this._courseRepository = courseRepository,
        super(MyCoursesInitial());

  @override
  Stream<MyCoursesState> mapEventToState(
    MyCoursesEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
