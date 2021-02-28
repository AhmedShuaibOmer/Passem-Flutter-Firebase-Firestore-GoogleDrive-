/*
 * Created Date: 2/22/21 9:07 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../router/router.dart';
import '../../../../../../widgets/widget.dart';
import '../../../widgets/widgets.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: <Widget>[
            Center(
              child: IconBadge(
                icon: Icons.notifications_rounded,
                iconColor: Theme.of(context).primaryColor,
                badgeText: '2',
                onPressed: () {},
              ),
            ),
            Center(
              child: IconButton(
                icon: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: ProfileImage(
                      userPhotoUrl: context.select((AuthenticationBloc bloc) =>
                          bloc.state.user.photoUrl),
                    ),
                  ),
                ),
                onPressed: () {},
              ),
            ),
            SizedBox(width: 8.0),
          ],
        ),
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            _buildLogo(),
            _buildSearchButton(context),
            buildTitleRow(context),
            buildRoomList(),
            buildProductList(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() => Container(
        margin: EdgeInsets.symmetric(
          vertical: 50,
          horizontal: 100,
        ),
        child: Image.asset(
          'assets/passem_logo.png',
        ),
      );

  Widget _buildSearchButton(BuildContext context) => Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Hero(
          tag: 'Search Field',
          child: FlatButton(
            splashColor: Colors.transparent,
            padding: EdgeInsetsDirectional.only(
              start: 22,
              top: 12,
              bottom: 12,
              end: 10,
            ),
            color: Color(0xfff3f3f4),
            shape: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            onPressed: () {
              ExtendedNavigator.of(context).push(MainScreenRoutes.searchPage);
            },
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Search',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                    ),
                  ),
                ),
                Icon(
                  // Feather.search,
                  Icons.search_rounded,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      );

  buildRoomList() {
    return Container(
      height: 275,
      color: Colors.white,
      /*
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: furnitures.length,
        itemBuilder: (BuildContext context, int index) {
          Map furniture = furnitures[index];

          return RoomItem(
            furniture: furniture,
          );
        },
      ),*/
    );
  }

  buildTitleRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "Popular Products",
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w800,
          ),
        ),
        FlatButton(
          child: Text(
            "View More",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  buildProductList() {
    return Container(
      height: 140.0,
      color: Colors.white,
      /*child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: furnitures.length,
        itemBuilder: (BuildContext context, int index) {
          Map furniture = furnitures[index];

          return ProductItem(
            furniture: furniture,
          );
        },
      ),*/
    );
  }
}
