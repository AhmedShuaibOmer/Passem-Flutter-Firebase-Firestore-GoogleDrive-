/*
 * Created Date: 3/10/21 12:18 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:flutter/material.dart';

import 'custom_tab_indicator.dart';

TabBar roundedIndicatorTabBar(
    {@required BuildContext context, @required List<Widget> tabs}) {
  return TabBar(
    physics: BouncingScrollPhysics(),
    isScrollable: true,
    labelColor: Theme.of(context).primaryColor,
    labelStyle: TextStyle(),
    unselectedLabelColor: Theme.of(context).primaryColor.withOpacity(0.5),
    indicator: RoundedUnderlinedIndicator(
      indicatorSize: RoundedUnderlinedIndicatorSize.full,
      indicatorColor: Theme.of(context).primaryColor,
      indicatorHeight: 5.0,
    ),
    tabs: tabs,
  );
}
