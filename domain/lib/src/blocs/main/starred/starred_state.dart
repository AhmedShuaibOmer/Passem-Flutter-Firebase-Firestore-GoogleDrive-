/*
 * Created Date: 2/26/21 2:33 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

part of 'starred_bloc.dart';

abstract class StarredState extends Equatable {
  const StarredState();
}

class StarredInitial extends StarredState {
  @override
  List<Object> get props => [];
}
