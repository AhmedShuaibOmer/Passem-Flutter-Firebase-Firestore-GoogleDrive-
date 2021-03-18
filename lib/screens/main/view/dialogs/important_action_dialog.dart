/*
 * Created Date: 3/16/21 5:57 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:flutter/material.dart';
import 'package:passem/generated/l10n.dart';

class ImportantActionDialog extends StatelessWidget {
  final Widget title;

  final Widget content;

  final Function(BuildContext) onYes;
  final Function(BuildContext) onCancel;

  const ImportantActionDialog({
    Key key,
    @required this.title,
    @required this.content,
    @required this.onYes,
    @required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: SingleChildScrollView(
        child: content,
      ),
      actions: <Widget>[
        TextButton(
          child: Text(S.of(context).yes),
          onPressed: () {
            onYes(context);
          },
        ),
        TextButton(
          child: Text(S.of(context).cancel),
          onPressed: () {
            onCancel(context);
          },
        ),
      ],
    );
  }
}
