/*
 * Created Date: 2/24/21 1:56 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:auto_route/auto_route_annotations.dart';

import '../screens/screens.dart';

export 'router.gr.dart';

/// All routes are defined in this single router.
///
/// Do NOT specify `initial` to true for any of these routes if you want to
/// reuse this router for nested navigation (as in this app).
///
/// You will declare `initialRoute` in each `ExtendedNavigator` accordingly.
@MaterialAutoRouter(
  routes: [
    MaterialRoute<void>(page: SplashScreen),
    MaterialRoute<void>(page: LoginScreen),
    MaterialRoute<void>(page: NewUserScreen),
    MaterialRoute<void>(page: CourseScreen),
    MaterialRoute<void>(page: MainScreen, children: [
      MaterialRoute<void>(page: HomePage),
      MaterialRoute<void>(page: MyCoursesPage),
      MaterialRoute<void>(page: StarredPage),
      MaterialRoute<void>(page: OfflinePage),
    ]),
  ],
)
class $AppRouter {}
