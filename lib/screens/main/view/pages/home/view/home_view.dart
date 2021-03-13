/*
 * Created Date: 2/22/21 9:07 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../generated/l10n.dart';
import '../../../../../../widgets/widget.dart';
import '../../../widgets/widgets.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  AnimationController _menuCloseAnimationController;
  TextEditingController _searchTextController;
  ScrollController _nestedScrollViewController;
  bool isSearchMode = false;
  bool canExpandHeader = true;

  List<ResourceTabItem> courseTabs = [];

  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _nestedScrollViewController = ScrollController();
    _menuCloseAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
      reverseDuration: Duration(milliseconds: 400),
    );
    _searchTextController = TextEditingController();
    _searchTextController.addListener(() async {
      if (_searchTextController.value.text == null ||
          _searchTextController.value.text.isEmpty) {
        _menuCloseAnimationController.reverse();
        setState(() {
          canExpandHeader = true;
        });
        await _nestedScrollViewController.animateTo(
            _nestedScrollViewController.position.minScrollExtent,
            duration: Duration(milliseconds: 200),
            curve: Curves.fastLinearToSlowEaseIn);
        setState(() {
          isSearchMode = false;
        });
      } else {
        if (!isSearchMode) {
          _menuCloseAnimationController.forward();
          setState(() {
            isSearchMode = true;
            canExpandHeader = false;
          });
          await _nestedScrollViewController.animateTo(
              _nestedScrollViewController.position.maxScrollExtent,
              duration: Duration(milliseconds: 200),
              curve: Curves.fastLinearToSlowEaseIn);
        }
      }
    });
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final value = WidgetsBinding.instance.window.viewInsets.bottom;
    if (value == 0) {
      _searchFocusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    courseTabs = getCourseTabs(context);
    courseTabs.insert(
      0,
      ResourceTabItem(S.of(context).courses, null),
    );
    return DefaultTabController(
      length: courseTabs.length,
      child: SafeArea(
        child: NestedScrollView(
          controller: _nestedScrollViewController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            // These are the slivers that show up in the "outer" scroll view.
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  leading: _buildMenuCloseButton(),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  flexibleSpace: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return _header(constraints.biggest.height);
                    },
                  ),
                  pinned: true,
                  collapsedHeight: 132,
                  expandedHeight: canExpandHeader ? 300 : 132,
                  forceElevated: innerBoxIsScrolled,
                  //bottom: _tabBar(),
                ),
              ),
            ];
          },
          body: IndexedStack(
            index: isSearchMode ? 1 : 0,
            children: [
              _homeBody(),
              _searchModeBody(),
            ],
          ),
        ),
      ),
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
            _onMenuClosePressed(context);
          },
          tooltip: isSearchMode
              ? null
              : MaterialLocalizations.of(context).openAppDrawerTooltip,
        );
      },
    );
  }

  void _onMenuClosePressed(BuildContext context) {
    if (isSearchMode) {
      _searchTextController.clear();
    } else {
      Scaffold.of(context).openDrawer();
    }
  }

  Widget _header(double height) {
    print(height);
    final iHeight = 300 - 120.0;
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedPositioned(
          bottom: isSearchMode ? 0 : null,
          top: isSearchMode ? null : -80,
          right: 0,
          left: 0,
          duration: Duration(milliseconds: 300),
          curve: Curves.fastLinearToSlowEaseIn,
          child: roundedIndicatorTabBar(
            context: context,
            tabs: courseTabs.map((tab) => Tab(text: tab.name)).toList(),
          ),
        ),
        Positioned.directional(
          textDirection: Directionality.of(context),
          end: 8,
          top: 4,
          width: 48,
          height: 48,
          child: IconButton(
            iconSize: 32,
            icon: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: Builder(
                  builder: (context) => ProfileImage(
                    userPhotoUrl: context.select(
                        (AuthenticationBloc bloc) => bloc.state.user.photoUrl),
                  ),
                ),
              ),
            ),
            onPressed: () {},
          ),
        ),
        AnimatedPositioned(
          top: isSearchMode ? -80 : (120 * ((height - 120) / iHeight)),
          width: 150,
          height: 60,
          duration: Duration(milliseconds: 300),
          curve: Curves.fastLinearToSlowEaseIn,
          child: _buildLogo(),
        ),
        AnimatedPositionedDirectional(
          top: isSearchMode ? 8 : ((128) * ((height - 128) / (300 - 128))) + 64,
          start: isSearchMode ? 56 : 24,
          end: isSearchMode ? 8 : 24,
          height: 60,
          curve: Curves.fastLinearToSlowEaseIn,
          duration: Duration(milliseconds: 300),
          child: MyTextField(
            focusNode: _searchFocusNode,
            controller: _searchTextController,
            prefixIcon: Icon(
              // Feather.search,
              Icons.search_rounded,
              color: Theme.of(context).primaryColor,
            ),
            hintText: S.of(context).search_hint_home_page,
            fillColor: Color(0xfff3f3f4),
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/passem_logo.png'),
            fit: BoxFit.fitWidth,
          ),
          shape: BoxShape.rectangle,
        ),
      );

  Widget _searchModeBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 132),
      child: ResourcesTabBarView(
        courseTabs: courseTabs,
        searchTextController: _searchTextController,
      ),
    );
  }

  Widget _homeBody() {
    return SafeArea(
      top: false,
      bottom: false,
      child: Builder(
        builder: (BuildContext context) {
          return CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(8.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      switch (index) {
                        case 0:
                          return _buildTitleRow(
                            title: S.of(context).recently_added,
                          );
                        case 1:
                          return _buildRecentlyAddedList();
                        case 2:
                          return _buildTitleRow(
                            title: S.of(context).top_contributors,
                          );
                        default:
                          return _buildMostContributorsList();
                      }
                    },
                    childCount: 4,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTitleRow({String title}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.w800,
          color: Theme.of(context).primaryColor.withOpacity(0.7),
        ),
      ),
    );
  }

  Widget _buildRecentlyAddedList() {
    return BlocBuilder<RecentlyAddedCubit, BaseListState>(
      builder: (context, state) {
        switch (state.status) {
          case BaseListStatus.loading:
            return Container(
              height: 48,
              alignment: Alignment.center,
              child: SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(),
              ),
            );
          case BaseListStatus.hasData:
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: state.items
                  .map((item) => StudyMaterialListItem(materialEntity: item))
                  .toList(),
            );
          case BaseListStatus.empty:
            return Container();
          default:
            return Container();
        }
      },
    );
  }

  Widget _buildMostContributorsList() {
    return Container(
      alignment: Alignment.center,
      height: 200,
      child: BlocBuilder<MostContributorsCubit, BaseListState>(
        builder: (context, state) {
          switch (state.status) {
            case BaseListStatus.empty:
              return Container();
            case BaseListStatus.hasData:
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: state.items.length,
                itemBuilder: (BuildContext context, int index) {
                  UserEntity userEntity = state.items[index];

                  return TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () {},
                    child: Container(
                      width: 174,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              child: ClipOval(
                                child: Builder(
                                  builder: (context) => ProfileImage(
                                    userPhotoUrl: userEntity.photoUrl,
                                    scale: 200,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 10,
                              ),
                              child: Text(
                                userEntity.name,
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w800),
                              ),
                            ),
                            Text(
                              'Shares Count : ${userEntity.sharedMaterialsCount}',
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            default:
              return SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _menuCloseAnimationController.dispose();
    _nestedScrollViewController.dispose();
    _searchTextController.dispose();
    _searchTextController = null;
    super.dispose();
  }
}
