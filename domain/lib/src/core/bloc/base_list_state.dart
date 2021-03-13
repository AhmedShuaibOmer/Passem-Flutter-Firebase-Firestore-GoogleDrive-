/*
 * Created Date: 3/6/21 3:52 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:equatable/equatable.dart';

enum BaseListStatus { loading, hasData, empty }

class BaseListState<T> extends Equatable {
  const BaseListState._({
    this.items = const [],
    this.status = BaseListStatus.loading,
  });

  const BaseListState.loading() : this._();

  const BaseListState.loaded({List<T> items, BaseListStatus status})
      : this._(status: status, items: items);

  final List<T> items;
  final BaseListStatus status;

  @override
  List<Object> get props => [items, status];
}
