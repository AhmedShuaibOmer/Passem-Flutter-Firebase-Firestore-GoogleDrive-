/*
 * Created Date: 2/23/21 2:53 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final String userPhotoUrl;
  final int scale;

  const ProfileImage({Key key, @required this.userPhotoUrl, this.scale})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO Add default  asset.
    return CachedNetworkImage(
      imageUrl: userPhotoUrl == null
          ? ''
          : userPhotoUrl.substring(0, userPhotoUrl.length - 15) +
              's${scale ?? 96}-c/photo.jpg',
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
