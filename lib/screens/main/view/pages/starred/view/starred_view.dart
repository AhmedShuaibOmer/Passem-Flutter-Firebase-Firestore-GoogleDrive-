/*
 * Created Date: 2/22/21 9:08 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passem/generated/l10n.dart';

import '../../../../../../screens/main/view/widgets/widgets.dart';

class StarredView extends StatefulWidget {
  @override
  _StarredViewState createState() => _StarredViewState();
}

class _StarredViewState extends State<StarredView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final ids = context
        .select((AuthenticationBloc ab) => ab.state.user.starredMaterials);
    context.read<StarredBloc>().add(StudyMaterialIdsChanged(ids));
    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          // These are the slivers that show up in the "outer" scroll view.
          return <Widget>[
            SliverAppBar(
              leading: _buildMenuCloseButton(),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Text(
                S.of(context).starred_materials,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              pinned: true,
              forceElevated: innerBoxIsScrolled,
              //bottom: _tabBar(),
            ),
          ];
        },
        body: BlocBuilder<StarredBloc, BaseListState>(
          builder: (BuildContext context, BaseListState state) {
            switch (state.status) {
              case BaseListStatus.hasData:
                return CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: <Widget>[
                    SliverPadding(
                      padding: const EdgeInsets.all(8.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final StudyMaterialEntity material =
                                state.items[index];
                            return StudyMaterialListItem(
                              materialEntity: material,
                            );
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
