/*
 * Created Date: 2/22/21 11:34 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:passem/generated/l10n.dart';

import '../../../router/router.dart';
import '../bloc/navigation_bloc.dart';
import 'widgets/custom_bottom_navigation_bar.dart';

class MainContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final bloc = context.read<NavigationBloc>();
    return BlocBuilder<NavigationBloc, int>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: bloc.onWillPop,
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            drawerScrimColor: Theme.of(context).primaryColor.withOpacity(0.6),
            drawer: Drawer(
              // Add a ListView to the drawer. This ensures the user can scroll
              // through the options in the drawer if there isn't enough vertical
              // space to fit everything.
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: Stack(alignment: Alignment.center, children: [
                      Positioned(
                        width: 150,
                        height: 60,
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 100),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/passem_logo.png'),
                              fit: BoxFit.fitWidth,
                            ),
                            shape: BoxShape.rectangle,
                          ),
                        ),
                      ),
                    ]),
                  ),
                  AboutListTile(
                    icon: Icon(Icons.info_outline_rounded),
                    applicationName: S.of(context).app_name,
                    applicationVersion: '1.0.0',
                    applicationLegalese: '©2021 A.Shuaib Omer',
                    dense: false,
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                    onTap: () async {
                      context
                          .read<AuthenticationBloc>()
                          .add(AuthenticationLogoutRequested());
                      await Future.delayed(Duration(seconds: 1)).then((value) =>
                          ExtendedNavigator.of(context).pushAndRemoveUntil(
                            Routes.loginScreen,
                            (route) => false,
                          ));
                    },
                  ),
                ],
              ),
            ),
            body: IndexedStack(
              index: state,
              children: List.generate(bloc.tabs.length, (index) {
                final tab = bloc.tabs[index];

                return TickerMode(
                  enabled: index == state,
                  child: Offstage(
                    offstage: index != state,
                    child: ExtendedNavigator(
                      initialRoute: tab.initialRoute,
                      name: tab.name,
                      router: MainScreenRouter(),
                    ),
                  ),
                );
              }),
            ),
            bottomNavigationBar: CustomBottomNavigationBar(
              backgroundColor: Colors.white,
              itemColor: Theme.of(context).primaryColor,
              currentIndex: state,
              onChange: bloc.add,
              children: bloc.tabs.map((tab) {
                return CustomBottomNavigationItem(
                  icon: tab.iconData,
                  label: tab.name,
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
