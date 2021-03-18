/*
 * Created Date: 3/12/21 9:11 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:flutter/material.dart';
import 'package:passem/widgets/widget.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchInWebViewWithJavaScript(
    BuildContext context, String url) async {
  if (await canLaunch(url)) {
    await launch(
      url,
      forceWebView: true,
      enableJavaScript: true,
    );
  } else {
    launchInBrowser(context, url);
  }
}

Future<void> launchInBrowser(BuildContext context, String url) async {
  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
    );
  } else {
    UnsupportedOperationAlert(context).show(context);
  }
}
