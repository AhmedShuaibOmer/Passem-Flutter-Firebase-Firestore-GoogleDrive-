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
    return CachedNetworkImage(
      imageUrl: userPhotoUrl == null
          ? ''
          : userPhotoUrl.substring(0, userPhotoUrl.length - 15) +
              's${scale ?? 96}-c/photo.jpg',
      placeholder: (ctx, str) => Container(
        alignment: Alignment.center,
        color: Theme.of(context).primaryColor,
        child: LayoutBuilder(
          builder: (ctx, constraints) => Icon(
            Icons.person_outline_rounded,
            color: Colors.white,
            size: constraints.biggest.height / 2,
          ),
        ),
      ),
    );
  }
}
