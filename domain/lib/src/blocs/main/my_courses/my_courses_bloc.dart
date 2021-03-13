/*
 * Created Date: 3/11/21 3:57 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:domain/domain.dart';

part 'my_courses_event.dart';

class MyCoursesBloc extends Bloc<MyCoursesEvent, BaseListState<CourseEntity>> {
  CourseRepository courseRepository;
  MyCoursesBloc({
    this.courseRepository,
  }) : super(BaseListState.loading()) {}

  @override
  Stream<BaseListState<CourseEntity>> mapEventToState(
    MyCoursesEvent event,
  ) async* {
    if (event is CoursesIdsChanged) {
      print('courses ids now in the bloc ${event.coursesIds.length}');

      final response = await courseRepository.getCourses(event.coursesIds);
      yield* response.fold((l) async* {
        print('courses yielded failure data');
        yield BaseListState.loaded(status: BaseListStatus.empty);
      }, (r) async* {
        if (r == null || r.isEmpty) {
          print('courses yielded empty data ${r.length}');
          yield BaseListState.loaded(status: BaseListStatus.empty);
        } else {
          print('courses yielded has data ${r.length}');
          yield BaseListState.loaded(items: r, status: BaseListStatus.hasData);
        }
      });
    }
  }
}
