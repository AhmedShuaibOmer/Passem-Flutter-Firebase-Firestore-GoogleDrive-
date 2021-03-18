/*
 * Created Date: 3/16/21 9:56 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:passem/di/di.dart';
import 'package:passem/generated/l10n.dart';
import 'package:passem/screens/main/view/dialogs/dialogs.dart';
import 'package:passem/screens/main/view/widgets/widgets.dart';
import 'package:passem/widgets/widget.dart';

class SearchResultsView extends StatefulWidget {
  SearchResultsView({
    Key key,
    @required this.searchTextController,
  }) : super(key: key);

  final TextEditingController searchTextController;

  @override
  _SearchResultsViewState createState() => _SearchResultsViewState();
}

class _SearchResultsViewState extends State<SearchResultsView> {
  PaginateQueryChangeListener _queryChangeListener =
      PaginateQueryChangeListener();

  @override
  void initState() {
    super.initState();
    if (widget.searchTextController != null)
      widget.searchTextController.addListener(() {
        final text = widget.searchTextController.text;
        if (text != null && text.isNotEmpty) {
          print('query changed: query: $text');
          _queryChangeListener.query = _getQuery(text);
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    bool isAdmin = context.read<AuthenticationBloc>().state.user.isAdmin;
    return SafeArea(
      top: false,
      bottom: false,
      child: PaginateFirestore(
        physics: BouncingScrollPhysics(),
        itemBuilderType: PaginateBuilderType.listView,
        itemBuilder: (index, context, documentSnapshot) {
          print('Resources tabBar view build: courses index $index');
          print(documentSnapshot.toJson);

          CourseEntity course = Course.fromJson(documentSnapshot.toJson);
          return courseListItem(course, context);
        },
        emptyDisplay: _buildEmptyDisplay(isAdmin),
        listeners: _getListeners(),
        query: null,
      ),
    );
  }

  Query _getQuery(
    String queryText,
  ) {
    return sl<FirestoreService>().searchCourses(queryText);
  }

  List<ChangeNotifier> _getListeners() {
    if (widget.searchTextController != null) {
      List<ChangeNotifier> listeners = [];

      listeners.add(_queryChangeListener);
      return listeners;
    }
    return null;
  }

  Widget _buildEmptyDisplay(bool isAdmin) {
    return Container(
      alignment: Alignment.center,
      child: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 50,
          ),
          Container(
            alignment: Alignment.center,
            child: Text(S.of(context).no_courses_were_found),
          ),
          SizedBox(height: 32),
          isAdmin
              ? TextButton.icon(
                  onPressed: () async {
                    final courseId = await showPrimaryDialog<String>(
                      context: context,
                      dialog: AddCourse(),
                    );
                    if (courseId != null && courseId.isNotEmpty) {
                      OperationSuccessAlert(
                        message: S.of(context).added_successfully,
                      ).show(context);
                    }
                  },
                  icon: Icon(Icons.add),
                  label: Text(S.of(context).try_adding_course),
                )
              : Container(),
        ],
      ),
    );
  }
}

class ResourceTabItem {
  final String name;
  final StudyMaterialType materialType;

  ResourceTabItem(this.name, this.materialType);
}
