/*
 * Created Date: 2/25/21 1:15 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:passem/screens/main/view/widgets/custom_tab_indicator.dart';
import 'package:passem/screens/main/view/widgets/search_field.dart';

class SearchView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              ExtendedNavigator.of(context).pop();
            },
            icon: Icon(
              Icons.close_rounded,
              color: Theme.of(context).primaryColor,
            ),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: SearchField(),
          bottom: TabBar(
            physics: BouncingScrollPhysics(),
            isScrollable: true,
            labelColor: Theme.of(context).primaryColor,
            labelStyle: TextStyle(),
            unselectedLabelColor:
                Theme.of(context).primaryColor.withOpacity(0.5),
            indicator: RoundedUnderlinedIndicator(
              indicatorSize: RoundedUnderlinedIndicatorSize.full,
              indicatorColor: Theme.of(context).primaryColor,
              indicatorHeight: 5.0,
            ),
            tabs: [
              Tab(
                text: 'Courses',
              ),
              Tab(
                text: 'General',
              ),
              Tab(
                text: 'Summaries',
              ),
              Tab(
                text: 'Lecture Notes',
              ),
              Tab(
                text: 'Exams',
              ),
              Tab(
                text: 'Tutorials',
              ),
              Tab(
                text: 'External Resources',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Icon(Icons.close_rounded),
            Icon(Icons.close_rounded),
            Icon(Icons.close_rounded),
            Icon(Icons.close_rounded),
            Icon(Icons.close_rounded),
            Icon(Icons.close_rounded),
            Icon(Icons.close_rounded),
          ],
        ),
      ),
    );
  }
}
