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
import 'package:passem/screens/main/view/widgets/list_items.dart';

class MyCoursesView extends StatefulWidget {
  @override
  _MyCoursesViewState createState() => _MyCoursesViewState();
}

class _MyCoursesViewState extends State<MyCoursesView>
    with SingleTickerProviderStateMixin {
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
              leading: _buildMenuCloseButton(),
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
              case BaseListStatus.loading:
                return Container(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(),
                  ),
                );
              case BaseListStatus.hasData:
                print('courses items ${state.items.length}');
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: state.items.length,
                  padding: EdgeInsets.all(8.0),
                  itemBuilder: (BuildContext context, int index) {
                    final CourseEntity course = state.items[index];
                    return courseListItem(course, context);
                  },
                );
              case BaseListStatus.empty:
                return Container();
              default:
                return Container();
            }
          },
        ),
      ),
    );
  }

  AnimationController _menuCloseAnimationController;

  @override
  void initState() {
    super.initState();
    _menuCloseAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
      reverseDuration: Duration(milliseconds: 400),
    );
  }

  Widget _buildMenuCloseButton() {
    return Builder(
      builder: (BuildContext context) {
        return IconButton(
          iconSize: 24,
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            color: Theme.of(context).primaryColor,
            progress: _menuCloseAnimationController,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        );
      },
    );
  }

  @override
  void dispose() {
    _menuCloseAnimationController.dispose();
    super.dispose();
  }
}
