/*
 * Created Date: 3/12/21 11:21 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:flutter/services.dart';

Future<void> copyToClipboard(String text) async {
  ClipboardData data = ClipboardData(text: text);
  await Clipboard.setData(data);
}

Future<String> pasteFromClipboard() async {
  ClipboardData data = await Clipboard.getData(Clipboard.kTextPlain);
  return data.text;
}
