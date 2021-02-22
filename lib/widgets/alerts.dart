/*
 * Created Date: 2/22/21 6:41 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:passem/generated/l10n.dart';

class NoConnectionAlert extends Flushbar {
  NoConnectionAlert(BuildContext context, {String specificMessage})
      : super(
          title: S.of(context).no_internet_failure_title,
          message: specificMessage ?? S.of(context).no_internet_message,
          icon: Icon(
            Icons.cloud_off_rounded,
            size: 28,
          ),
          borderRadius: 8,
          margin: EdgeInsets.all(8),
          duration: Duration(seconds: 3),
        );
}

class OperationFailedAlert extends Flushbar {
  OperationFailedAlert(BuildContext context, {String message})
      : super(
          title: S.of(context).operation_failed,
          message: S.of(context).login_with_google_failure,
          icon: Icon(
            Icons.error_outline_rounded,
            color: Theme.of(context).errorColor,
            size: 28,
          ),
          padding: EdgeInsets.all(8),
          borderRadius: 8,
          margin: EdgeInsets.all(8),
          duration: Duration(seconds: 3),
        );
}
