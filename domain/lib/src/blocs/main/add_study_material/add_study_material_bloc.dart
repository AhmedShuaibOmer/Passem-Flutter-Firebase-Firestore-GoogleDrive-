/*
 * Created Date: 3/9/21 3:20 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:domain/domain.dart';
import 'package:form_bloc/form_bloc.dart';

class AddStudyMaterialBloc extends FormBloc<String, String> {
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

  final type = SelectFieldBloc<StudyMaterialType, dynamic>(
    validators: [
      FieldBlocValidators.required,
    ],
    items: List<StudyMaterialType>.from(StudyMaterialType.values)
      ..remove(StudyMaterialType.externalResource),
  );

  final course = SelectFieldBloc<CourseEntity, dynamic>(
    validators: [
      FieldBlocValidators.required,
    ],
    items: [],
  );

  AddStudyMaterialBloc(
    StudyMaterialRepository studyMaterialRepository,
  )   : assert(studyMaterialRepository != null),
        this._studyMaterialRepository = studyMaterialRepository {
    addFieldBlocs(fieldBlocs: [
      link,
      title,
      description,
      type,
      course,
    ]);
  }

  @override
  Future<void> onSubmitting() async {
    final response = await _studyMaterialRepository.addMaterial(
      courseId: course.value.id,
      courseName: course.value.name,
      materialUrl: link.value,
      type: type.value,
      description: description.value,
      name: title.value,
    );
    response.fold((l) {
      emitFailure();
    }, (r) {
      emitSuccess(successResponse: r);
    });
  }
}
