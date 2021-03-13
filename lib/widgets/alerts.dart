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

// ignore: must_be_immutable
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

// ignore: must_be_immutable
class OperationFailedAlert extends Flushbar {
  OperationFailedAlert(BuildContext context, {String message})
      : super(
          title: S.of(context).operation_failed,
          message: message ?? S.of(context).login_with_google_failure,
          icon: Icon(
            Icons.error_outline_rounded,
            color: Theme.of(context).errorColor,
            size: 28,
          ),
          borderRadius: 8,
          margin: const EdgeInsets.all(8),
          duration: const Duration(seconds: 3),
        );
}

// ignore: must_be_immutable
class OperationSuccessAlert extends Flushbar {
  OperationSuccessAlert({@required String message})
      : super(
          message: message,
          icon: Icon(
            Icons.check_circle_outline_rounded,
            color: Colors.green,
            size: 28,
          ),
          borderRadius: 8,
          margin: const EdgeInsets.all(8),
          duration: const Duration(seconds: 3),
        );
}

// ignore: must_be_immutable
class UnsupportedOperationAlert extends Flushbar {
  UnsupportedOperationAlert(BuildContext context)
      : super(
          message: S.of(context).unsupported_operation,
          icon: Icon(
            Icons.info_outline_rounded,
            color: Colors.deepOrange,
            size: 28,
          ),
          borderRadius: 8,
          margin: const EdgeInsets.all(8),
          duration: const Duration(seconds: 3),
        );
}
