/*
 * Created Date: 3/10/21 9:23 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:domain/domain.dart';
import 'package:form_bloc/form_bloc.dart';

class AddCourseBloc extends FormBloc<String, String> {
  final CourseRepository _courseRepository;

  final courseName = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  AddCourseBloc(
    CourseRepository courseRepository,
  )   : assert(courseRepository != null),
        this._courseRepository = courseRepository {
    addFieldBlocs(fieldBlocs: [
      courseName,
    ]);
  }

  @override
  void onSubmitting() {
    _courseRepository
        .addCourse(
          courseName.value,
        )
        .then(
          (value) => value.fold(
            (l) => emitFailure(),
            (r) => emitSuccess(successResponse: r),
          ),
        );
  }
}
