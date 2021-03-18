/*
 * Created Date: 3/10/21 12:29 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import '../../../../di/di.dart';
import '../../../../generated/l10n.dart';
import '../../../../utils/utils.dart';
import 'study_material_list_item.dart';

List<ResourceTabItem> getCourseTabs(BuildContext context) => [
      ResourceTabItem(
        getMaterialTypString(StudyMaterialType.generalDocument, context),
        StudyMaterialType.generalDocument,
      ),
      ResourceTabItem(
        getMaterialTypString(StudyMaterialType.summary, context),
        StudyMaterialType.summary,
      ),
      ResourceTabItem(
        getMaterialTypString(StudyMaterialType.lectureNotes, context),
        StudyMaterialType.lectureNotes,
      ),
      ResourceTabItem(
        getMaterialTypString(StudyMaterialType.examPapers, context),
        StudyMaterialType.examPapers,
      ),
      ResourceTabItem(
        getMaterialTypString(StudyMaterialType.exercise, context),
        StudyMaterialType.exercise,
      ),
      ResourceTabItem(
        getMaterialTypString(StudyMaterialType.externalResource, context),
        StudyMaterialType.externalResource,
      ),
    ];

class ResourcesTabBarView extends StatefulWidget {
  final PaginateRefreshedChangeListener refreshedChangeListener;

  ResourcesTabBarView({
    Key key,
    @required this.courseTabs,
    this.courseId,
    this.queryText,
    this.searchTextController,
    this.refreshedChangeListener,
  }) : super(key: key);

  final String queryText;
  final List<ResourceTabItem> courseTabs;
  final String courseId;
  final TextEditingController searchTextController;

  @override
  _ResourcesTabBarViewState createState() => _ResourcesTabBarViewState();
}

class _ResourcesTabBarViewState extends State<ResourcesTabBarView> {
  PaginateQueryChangeListener _queryChangeListener =
      PaginateQueryChangeListener();

  @override
  void initState() {
    super.initState();
    if (widget.searchTextController != null)
      widget.searchTextController.addListener(() {
        final text = widget.searchTextController.text;
        if (text != null && text.isNotEmpty) {
          final tab = widget.courseTabs[DefaultTabController.of(context).index];
          print('query changed: tab:$tab ,query: $text');
          _queryChangeListener.query = _getQuery(tab, widget.courseId, text);
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: widget.courseTabs.map((tab) {
        return SafeArea(
          top: false,
          bottom: false,
          child: PaginateFirestore(
            physics: BouncingScrollPhysics(),
            itemBuilderType: PaginateBuilderType.listView,
            itemBuilder: (index, context, documentSnapshot) {
              print('Resources tabBar view build: courses index $index');
              print(documentSnapshot.toJson);
              StudyMaterial studyMaterial =
                  StudyMaterial.fromJson(documentSnapshot.toJson);
              return StudyMaterialListItem(
                materialEntity: studyMaterial,
              );
            },
            query: widget.searchTextController != null
                ? null
                : _getQuery(tab, widget.courseId, widget.queryText),
            emptyDisplay: _buildEmptyDisplay(),
            listeners: _getListeners(),
          ),
        );
      }).toList(),
    );
  }

  Query _getQuery(
    ResourceTabItem tab,
    String courseId,
    String queryText,
  ) {
    if (courseId == null) {
      return sl<FirestoreService>().searchMaterials(
        query: queryText,
        materialType: tab.materialType,
      );
    } else {
      return sl<FirestoreService>().materialsForCourse(
          courseId: courseId, materialType: tab.materialType);
    }
  }

  List<ChangeNotifier> _getListeners() {
    if (widget.refreshedChangeListener != null ||
        widget.searchTextController != null) {
      List<ChangeNotifier> listeners = [];
      if (widget.searchTextController != null) {
        listeners.add(_queryChangeListener);
      }
      if (widget.refreshedChangeListener != null) {
        listeners.add(widget.refreshedChangeListener);
      }
      return listeners;
    }
    return null;
  }

  Widget _buildEmptyDisplay() {
    return Container(
      alignment: Alignment.center,
      child: Text(S.of(context).no_results_found),
    );
  }
}

class ResourceTabItem {
  final String name;
  final StudyMaterialType materialType;

  ResourceTabItem(this.name, this.materialType);
}
