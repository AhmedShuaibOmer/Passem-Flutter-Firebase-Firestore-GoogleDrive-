/*
 * Created Date: 3/11/21 3:57 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

part of 'starred_bloc.dart';

abstract class StarredEvent {}

class StudyMaterialIdsChanged extends StarredEvent {
  final List<String> studyMaterialIds;

  StudyMaterialIdsChanged(this.studyMaterialIds);
}
