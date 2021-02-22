/*
 * Created Date: 2/19/21 10:43 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

part of 'new_user_cubit.dart';

enum NewUserStatus {
  setupSuccess,
  setupFailure,
  noConnectionFailure,
  loading,
  unknown
}

class NewUserState extends Equatable {
  const NewUserState._({this.status = NewUserStatus.unknown});

  const NewUserState.unknown() : this._();

  const NewUserState.success() : this._(status: NewUserStatus.setupSuccess);

  const NewUserState.failure() : this._(status: NewUserStatus.setupFailure);

  const NewUserState.loading() : this._(status: NewUserStatus.loading);

  const NewUserState.noConnectionFailure()
      : this._(status: NewUserStatus.noConnectionFailure);

  final NewUserStatus status;

  @override
  List<Object> get props => [status];
}
