/*
 * Created Date: 2/22/21 8:51 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:passem/current_version.dart';
import 'package:passem/screens/main/view/dialogs/dialogs.dart';
import 'package:passem/utils/utils.dart';

import '../../di/di.dart';
import '../../dynamic_links_handler.dart';
import '../../generated/l10n.dart';
import '../../router/router.gr.dart';
import '../../screens/main/view/main_content.dart';
import 'bloc/navigation_bloc.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    sl<FirestoreService>().getLatestVersionData().then((value) {
      try {
        final double version = value['version'];
        if (version > PASSEM_CURRENT_VERSION) {
          showPrimaryDialog(
            context: context,
            dialogBuilder: (ctx) {
              return AlertDialog(
                title: Text(S.of(context).new_version_available),
                actions: <Widget>[
                  TextButton(
                    child: Text(S.of(context).update),
                    onPressed: () async {
                      await launchInBrowser(
                          ctx, value['downloadUrl'] as String);
                      Navigator.of(ctx).pop();
                    },
                  ),
                  TextButton(
                    child: Text(S.of(context).not_now),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        print(e);
      }
    });
  }

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
      child: DynamicLinksHandler(
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
      ),
    );
  }
}
