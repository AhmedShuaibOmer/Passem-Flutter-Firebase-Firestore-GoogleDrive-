/*
 * Created Date: 3/9/21 3:20 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:domain/domain.dart';
import 'package:form_bloc/form_bloc.dart';

class AddExternalMaterialBloc extends FormBloc<String, String> {
  final StudyMaterialRepository _studyMaterialRepository;

  final link = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final title = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final description = TextFieldBloc();

  final course = SelectFieldBloc<CourseEntity, dynamic>(
    validators: [
      FieldBlocValidators.required,
    ],
    items: [],
  );

  AddExternalMaterialBloc(
    StudyMaterialRepository studyMaterialRepository,
  )   : assert(studyMaterialRepository != null),
        this._studyMaterialRepository = studyMaterialRepository {
    addFieldBlocs(fieldBlocs: [
      link,
      title,
      description,
      course,
    ]);
  }

  @override
  Future<void> onSubmitting() async {
    final response = await _studyMaterialRepository.addExternalMaterial(
      courseId: course.value.id,
      courseName: course.value.name,
      title: title.value,
      description: description.value,
      url: link.value,
    );
    response.fold((l) {
      emitFailure();
    }, (r) {
      emitSuccess(successResponse: r);
    });
  }
}
