/*
 * Created Date: 2/22/21 9:07 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passem/generated/l10n.dart';
import 'package:passem/screens/main/view/widgets/courses_list_item.dart';

class MyCoursesView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final ids =
        context.select((AuthenticationBloc ab) => ab.state.user.courses);
    context.read<MyCoursesBloc>().add(CoursesIdsChanged(ids));
    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          // These are the slivers that show up in the "outer" scroll view.
          return [
            SliverAppBar(
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    iconSize: 24,
                    icon: Icon(
                      Icons.menu,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    tooltip:
                    MaterialLocalizations.of(context).openAppDrawerTooltip,
                  );
                },
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Text(
                S.of(context).my_courses,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              pinned: true,
              forceElevated: innerBoxIsScrolled,
              //bottom: _tabBar(),
            )
          ];
        },
        body: BlocBuilder<MyCoursesBloc, BaseListState>(
          builder: (BuildContext context, BaseListState state) {
            switch (state.status) {
              case BaseListStatus.hasData:
                print('courses items ${state.items.length}');
                return CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: <Widget>[
                    SliverPadding(
                      padding: const EdgeInsets.all(8.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final CourseEntity course = state.items[index];
                            return courseListItem(course, context);
                          },
                          childCount: state.items.length,
                        ),
                      ),
                    ),
                  ],
                );
              case BaseListStatus.loading:
                return Container(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(),
                  ),
                );
              case BaseListStatus.empty:
                return Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          S.of(context).no_courses_found,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              S.of(context).how_to_add_courses,
                            ),
                          ),
                          Flexible(child: Text(S.of(context).how_to_add_courses_1)),
                          Flexible(child: Text(S.of(context).how_to_add_courses_2)),
                        ],
                      ),
                    ],
                  ),
                );
              default:
                return Container();
            }
          },
        ),
      ),
    );
  }
}
