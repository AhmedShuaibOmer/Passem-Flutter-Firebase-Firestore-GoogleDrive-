/*
 * Created Date: 2/23/21 11:04 PM
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

class OfflineView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                S.of(context).offline,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              pinned: true,
              forceElevated: innerBoxIsScrolled,
            )
          ];
        },
        body: BlocBuilder<OfflineBloc, BaseListState>(
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
                print('offline items ${state.items.length}');
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: state.items.length,
                  padding: EdgeInsets.all(8.0),
                  itemBuilder: (BuildContext context, int index) {
                    final studyMaterialEntity = state.items[index];
                    return StudyMaterialListItem(
                      materialEntity: studyMaterialEntity,
                    );
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
}
