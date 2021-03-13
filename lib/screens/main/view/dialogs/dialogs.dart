/*
 * Created Date: 3/12/21 1:32 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:flutter/material.dart';

export 'add_course.dart';
export 'add_materials.dart';

Future<T> showPrimaryDialog<T>({BuildContext context, Widget dialog}) {
  return showGeneralDialog<T>(
    context: context,
    barrierColor: Theme.of(context).primaryColor.withOpacity(0.6),
    // background color
    barrierDismissible: false,
    // should dialog be dismissed when tapped outside
    barrierLabel: "Dialog",
    // label for barrier
    transitionDuration: Duration(milliseconds: 400),
    // how long it takes to popup dialog after button click
    pageBuilder: (_, __, ___) {
      // your widget implementation
      return dialog;
    },
  );
}
