/*
 * Created Date: 1/26/21 11:38 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021 SafePass
 *
 */

part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;

  ThemeState(this.themeMode) : assert(themeMode != null);

  @override
  List<Object> get props => [themeMode];
}