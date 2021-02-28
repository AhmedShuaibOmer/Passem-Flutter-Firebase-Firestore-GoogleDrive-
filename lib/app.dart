/*
 * Created Date: 1/24/21 1:22 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021 SafePass
 *
 */
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'generated/l10n.dart';
import 'router/router.dart';
import 'theme/theme.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final themeState = ThemeState(ThemeMode.light);
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent, // transparent status bar
            systemNavigationBarColor: Theme.of(context)
                .scaffoldBackgroundColor, // navigation bar color
            statusBarIconBrightness: themeState.themeMode == ThemeMode.dark
                ? Brightness.light
                : Brightness.dark, // status bar icons' color
            systemNavigationBarIconBrightness:
                themeState.themeMode == ThemeMode.dark
                    ? Brightness.light
                    : Brightness.dark, //navigation bar icons' color
          ),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeState.themeMode,
            theme: DarkBlueTheme.lightTheme,
            darkTheme: DarkBlueTheme.darkTheme,
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            builder: (context, child) {
              return ExtendedNavigator<AppRouter>(
                //navigatorKey: _navigatorKey,
                router: AppRouter(),
                initialRoute: Routes.splashScreen,
              );
            },
          ),
        );
      },
    );
  }
}
