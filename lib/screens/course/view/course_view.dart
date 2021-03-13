/*
 * Created Date: 3/9/21 11:28 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:passem/generated/l10n.dart';
import 'package:passem/widgets/alerts.dart';

import '../../main/view/dialogs/dialogs.dart';
import '../../main/view/widgets/resources_tab_bar_view.dart';
import '../../main/view/widgets/widgets.dart';

class CourseView extends StatelessWidget {
  final PaginateRefreshedChangeListener refreshedChangeListener =
      PaginateRefreshedChangeListener();
  @override
  Widget build(BuildContext context) {
    final kCourseTabs = getCourseTabs(context);
    return DefaultTabController(
      length: kCourseTabs.length,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: NestedScrollView(headerSliverBuilder:
              (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                leading: IconButton(
                    onPressed: () {
                      ExtendedNavigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).primaryColor,
                    )),
                title: Builder(
                  builder: (ctx) {
                    final courseEntity =
                        ctx.select((CourseBloc cb) => cb.state.courseEntity);
                    String courseName;
                    if (courseEntity != null) {
                      courseName = courseEntity.name;
                    }
                    return courseName == null
                        ? LinearProgressIndicator()
                        : Text(
                            courseName,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          );
                  },
                ),
                bottom: roundedIndicatorTabBar(
                  context: context,
                  tabs: kCourseTabs.map((tab) => Tab(text: tab.name)).toList(),
                ),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                pinned: true,
                forceElevated: innerBoxIsScrolled,
                //bottom: _tabBar(),
              ),
            ];
          }, body: BlocBuilder<CourseBloc, CourseState>(
            builder: (ctx, state) {
              if (state is CourseInitial) {
                return Container(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 32,
                    width: 32,
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state is CourseNotFound) {
                // TODO : Unimplemented.
                return Container();
              } else if (state is CourseFetchFailure) {
                // TODO : Unimplemented.
                return Container();
              } else {
                return ResourcesTabBarView(
                  courseTabs: kCourseTabs,
                  courseId: state.courseEntity.id,
                  refreshedChangeListener: refreshedChangeListener,
                );
              }
            },
          )),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              final String materialId = await showFloatingModalBottomSheet(
                context: context,
                builder: (c) {
                  final course = context.read<CourseBloc>().state.courseEntity;
                  return AddMaterials(
                    course: course,
                  );
                },
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              );
              if (materialId != null && materialId.isNotEmpty) {
                refreshedChangeListener.refreshed = true;
                OperationSuccessAlert(
                  message: S.of(context).added_successfully,
                ).show(context);
              }
            },
          ),
        ),
      ),
    );
  }
}
