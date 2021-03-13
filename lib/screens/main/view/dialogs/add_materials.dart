/*
 * Created Date: 3/13/21 9:14 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:passem/generated/l10n.dart';

import 'add_external_study_material.dart';
import 'add_study_material.dart';
import 'dialogs.dart';

class AddMaterials extends StatelessWidget {
  final CourseEntity course;

  const AddMaterials({Key key, this.course}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: ModalScrollController.of(context),
      shrinkWrap: true,
      children: [
        Container(
          alignment: Alignment.center,
          height: 50,
          child: Text(
            S.of(context).add,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        ListTile(
          leading: Icon(Icons.insert_drive_file_rounded),
          title: Text(S.of(context).file),
          subtitle: Text(
            S.of(context).any_document_related_to_this_course,
          ),
          onTap: () async {
            final String materialId = await showPrimaryDialog<String>(
              context: context,
              dialog: AddStudyMaterial(
                targetedCourse: course,
              ),
            );
            Navigator.of(context).pop<String>(materialId);
          },
        ),
        ListTile(
          leading: Icon(Icons.add_link),
          title: Text(S.of(context).external_link),
          subtitle: Text(
            S.of(context).add_external_link_subtitle,
          ),
          onTap: () async {
            final String materialId = await showPrimaryDialog(
              context: context,
              dialog: AddExternalStudyMaterial(
                targetedCourse: course,
              ),
            );
            Navigator.of(context).pop<String>(materialId);
          },
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
