/*
 * Created Date: 3/6/21 3:52 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../core/core.dart';
import '../../../user/user.dart';

class MostContributorsCubit extends Cubit<BaseListState<UserEntity>> {
  StreamSubscription<List<UserEntity>> _mostContributedSubscription;
  final UserRepository _userRepository;

  MostContributorsCubit(this._userRepository) : super(BaseListState.loading()) {
    _mostContributedSubscription =
        _userRepository.mostContributors.listen((items) {
      _homeMostContributorsChanged(items);
      print('Most Contributors stream emitted.');
    });
  }

  void _homeMostContributorsChanged(List<UserEntity> items) {
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
    _mostContributedSubscription.cancel();
    return super.close();
  }
}
