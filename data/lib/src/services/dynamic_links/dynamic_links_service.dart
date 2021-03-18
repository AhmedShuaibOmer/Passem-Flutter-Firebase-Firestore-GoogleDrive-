/*
 * Created Date: 3/14/21 11:03 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinkService {
  Future<String> createCourseDynamicLink(String courseId) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://passem.page.link',
      link: Uri.parse(('https://passem.page.link.com/?courseId=$courseId')),
      androidParameters: AndroidParameters(
        fallbackUrl: Uri.parse('https://passem35.web.app'),
        packageName: 'com.aso.passem',
        minimumVersion: 0,
      ),
      iosParameters: IosParameters(
        bundleId: 'dfgyggthdhd',
        minimumVersion: '0',
        appStoreId: 'fvdtyuhuhyhudh',
        fallbackUrl: Uri.parse('https://passem35.web.app'),
        ipadFallbackUrl: Uri.parse('https://passem35.web.app'),
      ),
    );
    var dynamicUrl = await parameters.buildShortLink();

    return dynamicUrl.shortUrl.toString();
  }

  Future<void> retrieveDynamicLink(Function(String p1) onLinkRetrieved) async {
    try {
      final PendingDynamicLinkData data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      _handleDynamicLink(data, onLinkRetrieved);

      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData dynamicLink) async {
        _handleDynamicLink(dynamicLink, onLinkRetrieved);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void _handleDynamicLink(
      PendingDynamicLinkData dynamicLink, Function(String p1) onLinkRetrieved) {
    Uri deepLink = dynamicLink?.link;

    if (deepLink != null) {
      if (deepLink.queryParameters.containsKey('courseId')) {
        String courseId = deepLink.queryParameters['courseId'];
        onLinkRetrieved(courseId);
      }
    }
  }
}
