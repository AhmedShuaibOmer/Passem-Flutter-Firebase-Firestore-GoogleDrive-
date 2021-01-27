/*
 * Created Date: 1/26/21 11:38 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021 SafePass
 *
 */

part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class ThemeChanged extends ThemeEvent {
  final int value;

  ThemeChanged(this.value) : assert(value != null && 3 <= value && value >= 0);

  @override
  List<Object> get props => [value];
}

class ThemeLoadStarted extends ThemeEvent {}
