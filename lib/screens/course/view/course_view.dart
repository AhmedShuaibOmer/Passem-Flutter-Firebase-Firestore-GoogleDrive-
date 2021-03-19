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
import 'package:passem/di/injection_container.dart';
import 'package:passem/generated/l10n.dart';
import 'package:passem/widgets/alerts.dart';
import 'package:passem/widgets/widget.dart';
import 'package:share/share.dart';

import '../../main/view/dialogs/dialogs.dart';
import '../../main/view/widgets/resources_tab_bar_view.dart';
import '../../main/view/widgets/widgets.dart';

class CourseView extends StatelessWidget {
  final PaginateRefreshedChangeListener refreshedChangeListener =
      PaginateRefreshedChangeListener();

  @override
  Widget build(BuildContext context) {
    final kCourseTabs = getCourseTabs(context);
    bool isAdmin = context.read<AuthenticationBloc>().state.user.isAdmin;
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
                actions: [
                  Builder(
                    builder: (ctx) {
                      final courseEntity =
                          ctx.select((CourseBloc cb) => cb.state.courseEntity);
                      bool isSubscribed = ctx
                          .select(
                              (AuthenticationBloc ab) => ab.state.user.courses)
                          .contains(courseEntity.id);
                      return courseEntity == null
                          ? Container()
                          : _buildPopupMenuButton(
                              context, courseEntity, isAdmin, isSubscribed);
                    },
                  )
                ],
                bottom: roundedIndicatorTabBar(
                  context: context,
                  tabs: kCourseTabs.map((tab) => Tab(text: tab.name)).toList(),
                ),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                pinned: true,
                forceElevated: innerBoxIsScrolled,
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
                return Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            '404',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Flexible(
                          child: Text(
                            'Not found',
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is CourseFetchFailure) {
                return LoadFailed(
                  onTryAgain: () =>
                      context.read<CourseBloc>().add(CourseRefreshRequested()),
                );
              } else {
                return ResourcesTabBarView(
                  courseTabs: kCourseTabs,
                  courseId: state.courseEntity.id,
                  refreshedChangeListener: refreshedChangeListener,
                );
              }
            },
          )),
          floatingActionButton: isAdmin
              ? FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () async {
                    final String materialId =
                        await showFloatingModalBottomSheet(
                      context: context,
                      builder: (c) {
                        final course =
                            context.read<CourseBloc>().state.courseEntity;
                        return AddMaterials(
                          course: course,
                        );
                      },
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                    );
                    if (materialId != null && materialId.isNotEmpty) {
                      refreshedChangeListener.refreshed = true;
                      OperationSuccessAlert(
                        message: S.of(context).added_successfully,
                      ).show(context);
                    }
                  },
                )
              : null,
        ),
      ),
    );
  }

  PopupMenuButton _buildPopupMenuButton(BuildContext context,
      CourseEntity courseEntity, bool isAdmin, isSubscribed) {
    List<PopupMenuItem> items = [];
    items.add(
      PopupMenuItem(
        child: ListTile(
          leading: Icon(
            Icons.share,
          ),
          title: Text(S.of(context).share),
        ),
        value: 0,
      ),
    );

    items.add(
      PopupMenuItem(
        child: ListTile(
          leading: Icon(
            isSubscribed
                ? Icons.remove_circle_outline_rounded
                : Icons.add_circle_outline_outlined,
            color: isSubscribed ? Colors.red : Colors.green,
          ),
          title: Text(isSubscribed
              ? S.of(context).remove_from_my_courses
              : S.of(context).add_to_my_courses),
        ),
        value: 1,
      ),
    );

    if (isAdmin) {
      items.add(
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.delete_forever_rounded, color: Colors.red),
            title: Text(S.of(context).delete_forever),
          ),
          value: 2,
        ),
      );
    }

    return PopupMenuButton(
      icon: Icon(
        Icons.adaptive.more_rounded,
        color: Theme.of(context).primaryColor,
      ),
      iconSize: 24,
      itemBuilder: (context) {
        return items;
      },
      onSelected: (i) async {
        if (i == 0) {
          Share.share(courseEntity.deepLink);
        } else if (i == 1) {
          if (isSubscribed) {
            sl<UserRepository>().unsubscribeFromCourse(courseEntity.id).then((value) {
              value.fold((l) {
                OperationFailedAlert(context,
                    message: S
                        .of(context)
                        .removing_from_my_courses_failure)
                    .show(context);
              }, (r) {
                OperationSuccessAlert(
                    message: S
                        .of(context)
                        .removing_from_my_courses_success)
                    .show(context);
              });
            });;
          } else {
            sl<UserRepository>().subscribeToCourse(courseEntity.id).then((value) {
              value.fold((l) {
                OperationFailedAlert(context,
                    message: S
                        .of(context)
                        .adding_to_my_courses_failure)
                    .show(context);
              }, (r) {
                OperationSuccessAlert(
                    message: S
                        .of(context)
                        .adding_to_my_courses_success)
                    .show(context);
              });
            });
          }
        } else if (i == 2) {
          // TODO : Implement delete course materials.
          final int result = await showPrimaryDialog<int>(
            context: context,
            dialog: ImportantActionDialog(
              title: Text(S.of(context).delete_forever),
              content: Text(S.of(context).delete_forever_content),
              onCancel: (C) {
                Navigator.of(context).pop();
              },
              onYes: (c) {
                sl<CourseRepository>()
                    .deleteCourse(courseEntity.id)
                    .then((value) {
                  value.fold((l) {
                    OperationFailedAlert(context,
                            message: S.of(context).item_delete_failure)
                        .show(context);
                  }, (r) {
                    OperationSuccessAlert(
                            message: S.of(context).item_delete_success)
                        .show(context);
                  });
                });
                Navigator.of(context).pop(0);
              },
            ),
          );
          if (result == 0) Navigator.of(context).pop();
        }
      },
    );
  }
}
