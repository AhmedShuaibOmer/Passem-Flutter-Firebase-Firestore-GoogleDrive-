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

part 'starred_event.dart';

class StarredBloc
    extends Bloc<StarredEvent, BaseListState<StudyMaterialEntity>> {
  StudyMaterialRepository studyMaterialRepository;
  StarredBloc({
    this.studyMaterialRepository,
  }) : super(BaseListState.loading()) {}

  @override
  Stream<BaseListState<StudyMaterialEntity>> mapEventToState(
    StarredEvent event,
  ) async* {
    if (event is StudyMaterialIdsChanged) {
      final response =
          await studyMaterialRepository.getMaterials(event.studyMaterialIds);
      yield* response.fold((l) async* {
        yield BaseListState.loaded(status: BaseListStatus.empty);
      }, (r) async* {
        if (r == null || r.isEmpty) {
          yield BaseListState.loaded(status: BaseListStatus.empty);
        } else {
          yield BaseListState.loaded(items: r, status: BaseListStatus.hasData);
        }
      });
    }
  }
}
