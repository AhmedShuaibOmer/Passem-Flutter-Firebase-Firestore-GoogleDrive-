/*
 * Created Date: 3/12/21 9:59 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:domain/domain.dart';
import 'package:meta/meta.dart';

part 'course_event.dart';
part 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final CourseRepository _courseRepository;

  CourseBloc(
      {@required CourseRepository courseRepository,
      @required String courseId,
      @required CourseEntity courseEntity})
      : assert(courseRepository != null),
        this._courseRepository = courseRepository,
        super(CourseInitial()) {
    add(CourseStarted(courseId, courseEntity));
  }

  @override
  Stream<CourseState> mapEventToState(
    CourseEvent event,
  ) async* {
    if (event is CourseStarted) {
      if (event.courseEntity != null) {
        yield CourseLoaded(event.courseEntity);
      } else {
        final courseEntity =
            await _courseRepository.getCourses([event.courseId]);
        yield* courseEntity.fold((l) async* {
          yield CourseFetchFailure();
        }, (r) async* {
          if (r.isEmpty) {
            yield CourseNotFound();
          } else {
            yield CourseLoaded(r[0]);
          }
        });
      }
    }
  }
}
