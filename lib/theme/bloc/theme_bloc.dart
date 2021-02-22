import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:data/data.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc({SharedPreferencesService sharedPrefService})
      : _sharedPrefService = sharedPrefService,
        super(ThemeState(ThemeMode.system));

  final _sharedPrefService;

  ThemeState get initialState => ThemeState(ThemeMode.system);

  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    if (event is ThemeLoadStarted) {
      yield* _mapThemeLoadStartedToState();
    } else if (event is ThemeChanged) {
      yield* _mapThemeChangedToState(event.value);
    }
  }

  Stream<ThemeState> _mapThemeLoadStartedToState() async* {
    final themeModeInfo = _sharedPrefService.themeModeInfo;

    if (themeModeInfo == null || themeModeInfo == SYSTEM_THEME_MODE) {
      _sharedPrefService.setThemeModeInfo(SYSTEM_THEME_MODE);
      yield ThemeState(ThemeMode.system);
    } else {
      ThemeMode themeMode =
          themeModeInfo == LIGHT_THEME_MODE ? ThemeMode.light : ThemeMode.dark;
      yield ThemeState(themeMode);
    }
  }

  Stream<ThemeState> _mapThemeChangedToState(int value) async* {
    await _sharedPrefService.setThemeModeInfo(value);

    switch (value) {
      case DARK_THEME_MODE:
        {
          yield ThemeState(ThemeMode.dark);
          break;
        }
      case LIGHT_THEME_MODE:
        {
          yield ThemeState(ThemeMode.light);
          break;
        }
      case SYSTEM_THEME_MODE:
        {
          yield ThemeState(ThemeMode.system);
        }
    }
  }
}
