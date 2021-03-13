/*
 * Created Date: 3/12/21 11:47 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:passem/generated/l10n.dart';

// ignore: missing_return
String getMaterialTypString(StudyMaterialType type, BuildContext context) {
  switch (type) {
    case StudyMaterialType.generalDocument:
      return S.of(context).general_document;

    case StudyMaterialType.summary:
      return S.of(context).summary;

    case StudyMaterialType.lectureNotes:
      return S.of(context).lecture_notes;

    case StudyMaterialType.examPapers:
      return S.of(context).exam_papers;

    case StudyMaterialType.exercise:
      return S.of(context).exercise;

    case StudyMaterialType.externalResource:
      return S.of(context).external_resource;
  }
}
