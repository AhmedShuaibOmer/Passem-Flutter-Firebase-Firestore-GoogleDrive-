/*
 * Created Date: 3/14/21 8:18 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:domain/domain.dart';
import 'package:flutter/material.dart';

import '../di/di.dart';
import '../generated/l10n.dart';
import 'alerts.dart';

class LoadFailed extends StatelessWidget {
  const LoadFailed({
    Key key,
    @required this.onTryAgain,
  }) : super(key: key);

  final VoidCallback onTryAgain;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            S.of(context).something_went_wrong,
            style: Theme.of(context).textTheme.headline3,
          ),
          SizedBox(
            height: 20,
          ),
          TextButton.icon(
              onPressed: () async {
                final NetworkInfo networkInfo = sl<NetworkInfo>();
                if (await networkInfo.isConnected) {
                  onTryAgain();
                } else {
                  NoConnectionAlert(
                    context,
                  ).show(context);
                }
              },
              icon: Icon(Icons.refresh),
              label: Text(S.of(context).try_again)),
        ],
      ),
    );
  }
}
