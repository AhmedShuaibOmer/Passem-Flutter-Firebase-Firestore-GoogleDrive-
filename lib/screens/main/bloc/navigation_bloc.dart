/*
 * Created Date: 2/24/21 12:28 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../../../router/router.dart';

class NavigationBloc extends Bloc<int, int> {
  NavigationBloc() : super(NavigationTabs.first);

  @override
  Stream<int> mapEventToState(int event) async* {
    yield event;
  }

  final tabs = const <NavigationTab>[
    NavigationTab(
      name: 'Home',
      iconData: Feather.home,
      initialRoute: MainScreenRoutes.homePage,
    ),
    NavigationTab(
      name: 'My Courses',
      iconData: Feather.archive,
      initialRoute: MainScreenRoutes.myCoursesPage,
    ),
    NavigationTab(
      name: 'Starred',
      iconData: Feather.star,
      initialRoute: MainScreenRoutes.starredPage,
    ),
    NavigationTab(
      name: 'Offline',
      iconData: Feather.download,
      initialRoute: MainScreenRoutes.offlinePage,
    ),
  ];

  Future<bool> onWillPop() async {
    final currentNavigatorState = ExtendedNavigator.named(tabs[state].name);

    if (currentNavigatorState.canPop()) {
      currentNavigatorState.pop();
    } else {
      if (state == NavigationTabs.first) {
        return true;
      } else {
        add(NavigationTabs.first);
      }
    }

    return false;
  }
}

class NavigationTabs {
  /// Default constructor is private because this class will be only used for
  /// static fields and you should not instantiate it.
  NavigationTabs._();

  static const first = 0;
  static const second = 1;
  static const third = 2;
  static const fourth = 3;
}

@immutable
class NavigationTab {
  const NavigationTab({
    this.name,
    this.iconData,
    this.initialRoute,
  });

  final String name;
  final IconData iconData;
  final String initialRoute;
}
