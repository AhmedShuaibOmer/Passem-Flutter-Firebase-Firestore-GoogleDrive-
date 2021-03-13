/*
 * Created Date: 3/6/21 4:34 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../core/core.dart';
import '../../../study_material/study_material.dart';

class RecentlyAddedCubit extends Cubit<BaseListState<StudyMaterialEntity>> {
  final StudyMaterialRepository _studyMaterialRepository;
  StreamSubscription<List<StudyMaterialEntity>> _recentlyAddedSubscription;

  RecentlyAddedCubit(this._studyMaterialRepository)
      : super(BaseListState.loading()) {
    _recentlyAddedSubscription =
        _studyMaterialRepository.recentlyAdded.listen((items) {
      _homeRecentlyAddedChanged(items);
      print('Recently Added stream emitted.');
    });
  }

  void _homeRecentlyAddedChanged(List<StudyMaterialEntity> items) {
    print('most contributors length: ${items.length}');
    if (items == null || items.isEmpty) {
      emit(BaseListState.loaded(status: BaseListStatus.empty));
    } else {
      emit(BaseListState.loaded(
        items: items,
        status: BaseListStatus.hasData,
      ));
    }
  }

  @override
  Future<void> close() {
    _recentlyAddedSubscription.cancel();
    return super.close();
  }
}
