/*
 * Created Date: 2/26/21 11:55 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum StudyMaterialType {
  generalDocument,
  summary,
  lectureNotes,
  examPapers,
  exercise,
  externalResource,
}

class StudyMaterialEntity extends Equatable {
  final String id;
  final String label;
  final String description;
  final String thumbnailUrl;

  /// The url of the icon for the file type eg(pdf..).
  final String iconUrl;
  final String materialUrl;
  final String courseName;

  /// the of the study material on the device if its downloaded.
  final String localPath;
  final String courseId;
  final String uploaderName;
  final String uploaderId;
  final int created;
  final String fileSize;

  /// type of the material.
  final StudyMaterialType type;

  StudyMaterialEntity({
    @required this.id,
    @required this.label,
    this.description,
    this.thumbnailUrl,
    this.iconUrl,
    this.fileSize,
    this.localPath,
    @required this.materialUrl,
    @required this.courseName,
    @required this.created,
    @required this.type,
    @required this.courseId,
    @required this.uploaderName,
    @required this.uploaderId,
  })  : assert(id != null),
        assert(label != null),
        assert(materialUrl != null),
        assert(courseName != null),
        assert(created != null),
        assert(type != null),
        assert(courseId != null),
        assert(uploaderName != null),
        assert(uploaderId != null);

  @override
  List<Object> get props => [
        id,
        label,
        description,
        thumbnailUrl,
        iconUrl,
        materialUrl,
        courseName,
        courseId,
        localPath,
        fileSize,
        created,
        type,
        uploaderName,
        uploaderId,
      ];
}
