/*
 * Created Date: 2/22/21 11:34 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../router/router.dart';
import '../bloc/navigation_bloc.dart';
import 'widgets/custom_bottom_navigation_bar.dart';

class MainContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<NavigationBloc>();
    return BlocBuilder<NavigationBloc, int>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: bloc.onWillPop,
          child: Scaffold(
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
