/*
 * Created Date: 2/19/21 7:51 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:form_bloc/form_bloc.dart';
import 'package:meta/meta.dart';

import '../../../domain.dart';

class NewUserBloc extends FormBloc<String, String> {
  final UserRepository _userRepository;
  final UniversityRepository _universityRepository;
  final CollegeRepository _collegeRepository;

  final university = SelectFieldBloc<UniversityEntity, dynamic>(
    validators: [
      FieldBlocValidators.required,
    ],
    items: [],
  );

  final college = SelectFieldBloc<CollegeEntity, dynamic>(
    validators: [
      FieldBlocValidators.required,
    ],
    items: [],
  );

  NewUserBloc({
    @required UniversityRepository universityRepository,
    @required CollegeRepository collegeRepository,
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        assert(universityRepository != null),
        assert(collegeRepository != null),
        this._userRepository = userRepository,
        this._universityRepository = universityRepository,
        this._collegeRepository = collegeRepository,
        super(isLoading: true) {
    addFieldBlocs(fieldBlocs: [
      university,
      college,
    ]);
  }

  @override
  Future<void> onLoading() async {
    await _universityRepository.getAllUniversities().then((value) {
      value.fold((l) {
        emitLoadFailed();
      }, (r) async {
        university.updateItems(r);
        university.updateInitialValue(r[0]);
        await _collegeRepository
            .getAllColleges(university.value.id)
            .then((value) => value.fold((left) {
                  emitLoadFailed();
                }, (right) {
                  college.updateItems(right);
                  college.updateInitialValue(right[0]);
                  emitLoaded();
                }));
      });
    });
  }

  @override
  Future<void> onSubmitting() async {
    final response = await _userRepository.updateUser(
      universityId: university.value.id,
      collegeId: college.value.id,
    );
    response.fold((error) {
      emitFailure();
    }, (r) {
      /* No action need , AuthenticationBloc takes care of success case.*/
    });
  }
}
