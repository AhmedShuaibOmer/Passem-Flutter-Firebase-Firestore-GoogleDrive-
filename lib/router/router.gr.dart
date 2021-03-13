// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';

import '../screens/screens.dart';

class Routes {
  static const String splashScreen = '/splash-screen';
  static const String loginScreen = '/login-screen';
  static const String newUserScreen = '/new-user-screen';
  static const String courseScreen = '/course-screen';
  static const String mainScreen = '/main-screen';
  static const all = <String>{
    splashScreen,
    loginScreen,
    newUserScreen,
    courseScreen,
    mainScreen,
  };
}

class AppRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.splashScreen, page: SplashScreen),
    RouteDef(Routes.loginScreen, page: LoginScreen),
    RouteDef(Routes.newUserScreen, page: NewUserScreen),
    RouteDef(Routes.courseScreen, page: CourseScreen),
    RouteDef(
      Routes.mainScreen,
      page: MainScreen,
      generator: MainScreenRouter(),
    ),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    SplashScreen: (data) {
      return MaterialPageRoute<void>(
        builder: (context) => SplashScreen(),
        settings: data,
      );
    },
    LoginScreen: (data) {
      return MaterialPageRoute<void>(
        builder: (context) => LoginScreen(),
        settings: data,
      );
    },
    NewUserScreen: (data) {
      return MaterialPageRoute<void>(
        builder: (context) => NewUserScreen(),
        settings: data,
      );
    },
    CourseScreen: (data) {
      final args = data.getArgs<CourseScreenArguments>(
        orElse: () => CourseScreenArguments(),
      );
      return MaterialPageRoute<void>(
        builder: (context) => CourseScreen(
          key: args.key,
          course: args.course,
          courseId: args.courseId,
        ),
        settings: data,
      );
    },
    MainScreen: (data) {
      return MaterialPageRoute<void>(
        builder: (context) => MainScreen(),
        settings: data,
      );
    },
  };
}

class MainScreenRoutes {
  static const String homePage = '/home-page';
  static const String myCoursesPage = '/my-courses-page';
  static const String starredPage = '/starred-page';
  static const String offlinePage = '/offline-page';
  static const all = <String>{
    homePage,
    myCoursesPage,
    starredPage,
    offlinePage,
  };
}

class MainScreenRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(MainScreenRoutes.homePage, page: HomePage),
    RouteDef(MainScreenRoutes.myCoursesPage, page: MyCoursesPage),
    RouteDef(MainScreenRoutes.starredPage, page: StarredPage),
    RouteDef(MainScreenRoutes.offlinePage, page: OfflinePage),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    HomePage: (data) {
      return MaterialPageRoute<void>(
        builder: (context) => HomePage(),
        settings: data,
      );
    },
    MyCoursesPage: (data) {
      return MaterialPageRoute<void>(
        builder: (context) => MyCoursesPage(),
        settings: data,
      );
    },
    StarredPage: (data) {
      return MaterialPageRoute<void>(
        builder: (context) => StarredPage(),
        settings: data,
      );
    },
    OfflinePage: (data) {
      return MaterialPageRoute<void>(
        builder: (context) => OfflinePage(),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// CourseScreen arguments holder class
class CourseScreenArguments {
  final Key key;
  final CourseEntity course;
  final String courseId;
  CourseScreenArguments({this.key, this.course, this.courseId});
}
