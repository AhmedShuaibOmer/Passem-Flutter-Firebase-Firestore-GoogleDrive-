/*
 * Created Date: 2/26/21 2:32 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

part of 'home_bloc.dart';

abstract class HomeEvent {
  const HomeEvent();
}

class SearchTextChanged extends HomeEvent {
  final String query;

  SearchTextChanged(this.query);
}
