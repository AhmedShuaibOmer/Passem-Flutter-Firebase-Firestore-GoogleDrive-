/*
 * Created Date: 2/22/21 8:51 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:passem/di/di.dart';
import 'package:passem/generated/l10n.dart';
import 'package:passem/router/router.gr.dart';
import 'package:passem/screens/main/view/main_content.dart';

import 'bloc/navigation_bloc.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tabs = <NavigationTab>[
      NavigationTab(
        name: S.of(context).home,
        iconData: Feather.home,
        initialRoute: MainScreenRoutes.homePage,
      ),
      NavigationTab(
        name: S.of(context).my_courses,
        iconData: Feather.book_open,
        initialRoute: MainScreenRoutes.myCoursesPage,
      ),
      NavigationTab(
        name: S.of(context).starred,
        iconData: Feather.star,
        initialRoute: MainScreenRoutes.starredPage,
      ),
      NavigationTab(
        name: S.of(context).offline,
        iconData: Feather.download,
        initialRoute: MainScreenRoutes.offlinePage,
      ),
    ];
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // transparent status bar
        systemNavigationBarColor:
            Theme.of(context).scaffoldBackgroundColor, // navigation bar color
        statusBarIconBrightness: Brightness.dark, // status bar icons' color
        systemNavigationBarIconBrightness:
            Brightness.dark, //navigation bar icons' color
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => sl<NavigationBloc>()..setTabs(tabs),
          ),
          BlocProvider(
            create: (_) => sl<RecentlyAddedCubit>(),
          ),
          BlocProvider(
            create: (_) => sl<MostContributorsCubit>(),
          ),
        ],
        child: MainContent(),
      ),
    );
  }
}
