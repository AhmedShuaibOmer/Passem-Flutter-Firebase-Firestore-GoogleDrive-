/*
 * Created Date: 3/15/21 12:29 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:passem/router/router.gr.dart';

class DynamicLinksHandler extends StatefulWidget {
  final Widget child;

  const DynamicLinksHandler({Key key, this.child}) : super(key: key);

  @override
  _DynamicLinksHandlerState createState() => _DynamicLinksHandlerState();
}

class _DynamicLinksHandlerState extends State<DynamicLinksHandler>
    with WidgetsBindingObserver {
  final DynamicLinkService _dynamicLinkService = DynamicLinkService();
  Timer _timerLink;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _timerLink = new Timer(
        const Duration(milliseconds: 1000),
        () {
          _dynamicLinkService.retrieveDynamicLink((String courseId) {
            ExtendedNavigator.root.push(
              Routes.courseScreen,
              arguments: CourseScreenArguments(
                courseId: courseId,
              ),
            );
          });
        },
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_timerLink != null) {
      _timerLink.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
