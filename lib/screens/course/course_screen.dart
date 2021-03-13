/*
 * Created Date: 3/9/21 11:28 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passem/di/di.dart';

import 'view/course_view.dart';

class CourseScreen extends StatelessWidget {
  final CourseEntity course;
  final String courseId;

  const CourseScreen({Key key, this.course, this.courseId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CourseBloc(
        courseRepository: sl(),
        courseId: courseId,
        courseEntity: course,
      ),
      child: CourseView(),
    );
  }
}
