/*
 * Created Date: 2/26/21 2:33 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

part of 'offline_bloc.dart';

abstract class OfflineState extends Equatable {
  const OfflineState();
}

class OfflineInitial extends OfflineState {
  @override
  List<Object> get props => [];
}
