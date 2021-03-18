/*
 * Created Date: 3/14/21 8:57 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class PdfViewerPage extends StatefulWidget {
  final String filePath;

  final String fileName;

  const PdfViewerPage(
      {Key key, @required this.filePath, @required this.fileName})
      : super(key: key);

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  static final int _initialPage = 1;
  int _actualPageNumber = _initialPage, _allPagesCount = 0;
  bool isSampleDoc = true;
  PdfController _pdfController;

  @override
  void initState() {
    _pdfController = PdfController(
      document: PdfDocument.openFile(widget.filePath),
      initialPage: _initialPage,
    );
    super.initState();
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // transparent status bar
          systemNavigationBarColor: Theme.of(context)
              .scaffoldBackgroundColor, // navigation bar color
          statusBarIconBrightness: Brightness.dark, // status bar icons' color
          systemNavigationBarIconBrightness:
              Brightness.dark, //navigation bar icons' color
        ),
    child: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              // These are the slivers that show up in the "outer" scroll view.
              return [
                SliverAppBar(
                  leading: Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                        onPressed: () {
                          ExtendedNavigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Theme.of(context).primaryColor,
                        ),
                      );
                    },
                  ),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  title: Text(
                    widget.fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.navigate_before,
                          color: Theme.of(context).primaryColor),
                      onPressed: () {
                        _pdfController.previousPage(
                          curve: Curves.ease,
                          duration: Duration(milliseconds: 100),
                        );
                      },
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        '$_actualPageNumber/$_allPagesCount',
                        style: TextStyle(
                            fontSize: 22,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.navigate_next,
                          color: Theme.of(context).primaryColor),
                      onPressed: () {
                        _pdfController.nextPage(
                          curve: Curves.ease,
                          duration: Duration(milliseconds: 100),
                        );
                      },
                    ),
                  ],
                  pinned: true,
                  forceElevated: true,
                  //bottom: _tabBar(),
                )
              ];
            },
            body: PdfView(
              physics: BouncingScrollPhysics(),
              documentLoader: Center(child: CircularProgressIndicator()),
              pageLoader: Center(child: CircularProgressIndicator()),
              controller: _pdfController,
              onDocumentLoaded: (document) {
                setState(() {
                  _allPagesCount = document.pagesCount;
                });
              },
              onPageChanged: (page) {
                setState(() {
                  _actualPageNumber = page;
                });
              },
            ),
          ),
        ),
  );
}
