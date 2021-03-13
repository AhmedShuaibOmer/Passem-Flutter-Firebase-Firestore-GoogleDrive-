/*
 * Created Date: 2/26/21 2:33 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:domain/domain.dart';

part 'offline_event.dart';

class OfflineBloc
    extends Bloc<OfflineEvent, BaseListState<StudyMaterialEntity>> {
  StudyMaterialRepository studyMaterialRepository;
  OfflineBloc({
    this.studyMaterialRepository,
  }) : super(BaseListState.loading()) {}

  @override
  Stream<BaseListState<StudyMaterialEntity>> mapEventToState(
    OfflineEvent event,
  ) async* {
    if (event is OfflineMaterialsChanged) {
      final response = await studyMaterialRepository.getDownloadedMaterials();
      yield* response.fold((l) async* {
        print('offline yielded failure data');
        yield BaseListState.loaded(status: BaseListStatus.empty);
      }, (r) async* {
        if (r == null || r.isEmpty) {
          print('offline yielded empty data ${r.length}');
          yield BaseListState.loaded(status: BaseListStatus.empty);
        } else {
          print('offline yielded has data ${r.length}');
          yield BaseListState.loaded(items: r, status: BaseListStatus.hasData);
        }
      });
    }
  }

  Future<void> addDownloadedMaterial(StudyMaterialEntity materialEntity) async {
    await studyMaterialRepository
        .addDownloadedMaterial(materialEntity)
        .then((value) {
      value.fold((l) {
        // TODO : Handle error case.
      }, (r) {
        if (r) {
          add(OfflineMaterialsChanged());
        }
      });
    });
  }
}
