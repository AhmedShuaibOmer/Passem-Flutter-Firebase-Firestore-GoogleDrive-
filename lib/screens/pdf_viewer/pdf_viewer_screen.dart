/*
 * Created Date: 3/14/21 8:56 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:flutter/material.dart';

import 'view/pdf_viewer_page.dart';

class PdfViewerScreen extends StatelessWidget {
  final String filepath;
  final String fileName;

  const PdfViewerScreen(
      {Key key, @required this.filepath, @required this.fileName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PdfViewerPage(
      filePath: filepath,
      fileName: fileName,
    );
  }
}
