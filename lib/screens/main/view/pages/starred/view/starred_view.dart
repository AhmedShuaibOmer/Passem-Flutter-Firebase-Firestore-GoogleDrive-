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

class StarredView extends StatelessWidget {
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
                          S.of(context).no_starred_items,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Flexible(
                        child: Text(
                          S.of(context).add_starred_items,
                        ),
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
