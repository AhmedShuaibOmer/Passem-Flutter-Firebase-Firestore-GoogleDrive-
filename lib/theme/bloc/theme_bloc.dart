import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(ThemeMode.system));

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
    final sharedPrefService = await SharedPreferencesService.instance;
    final themeModeInfo = sharedPrefService.themeModeInfo;

    if (themeModeInfo == null ||
        themeModeInfo == PrefsConstants.SYSTEM_THEME_MODE) {
      sharedPrefService.setThemeModeInfo(PrefsConstants.SYSTEM_THEME_MODE);
      yield ThemeState(ThemeMode.system);
    } else {
      ThemeMode themeMode = themeModeInfo == PrefsConstants.LIGHT_THEME_MODE
          ? ThemeMode.light
          : ThemeMode.dark;
      yield ThemeState(themeMode);
    }
  }

  Stream<ThemeState> _mapThemeChangedToState(int value) async* {
    final sharedPrefService = await SharedPreferencesService.instance;
    await sharedPrefService.setThemeModeInfo(value);

    switch (value) {
      case PrefsConstants.DARK_THEME_MODE:
        {
          yield ThemeState(ThemeMode.dark);
          break;
        }
      case PrefsConstants.LIGHT_THEME_MODE:
        {
          yield ThemeState(ThemeMode.light);
          break;
        }
      case PrefsConstants.SYSTEM_THEME_MODE:
        {
          yield ThemeState(ThemeMode.system);
        }
    }
  }
}
