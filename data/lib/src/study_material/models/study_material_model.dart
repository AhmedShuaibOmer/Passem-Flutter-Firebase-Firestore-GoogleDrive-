/*
 * Created Date: 2/26/21 3:02 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:domain/domain.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'study_material_model.g.dart';

@JsonSerializable()
class StudyMaterial extends StudyMaterialEntity {
  StudyMaterial({
    @required this.id,
    @required String label,
    @required String description,
    @required String thumbnailUrl,
    @required String iconUrl,
    @required String materialUrl,
    @required this.localPath,
    @required String courseName,
    @required int created,
    @required this.type,
    @required String courseId,
    @required String uploaderName,
    @required String uploaderId,
    String fileSize,
  }) : super(
          id: id,
          label: label,
          description: description,
          thumbnailUrl: thumbnailUrl,
          iconUrl: iconUrl,
          materialUrl: materialUrl,
          courseName: courseName,
          localPath: localPath,
          fileSize: fileSize,
          courseId: courseId,
          created: created,
          type: type,
          uploaderName: uploaderName,
          uploaderId: uploaderId,
        );

  /// The current material's id.
  ///
  /// we do not need to write the material id inside the document in firestore
  /// since it gonna be the document id.
  ///
  /// this is a workaround to disallow including the field only in the
  /// toJson function.
  @override
  @JsonKey(toJson: toNull, includeIfNull: false)
  final String id;

  /// this is a workaround to disallow including the field only in the
  /// toJson function.
  @override
  @JsonKey(toJson: toNull, includeIfNull: false)
  final String localPath;

  static toNull(_) => null;

  /// The Type of the current study material.
  ///
  /// we're mapping the type into a string before converting the object
  /// to json data type, also mapping it from json.
  @override
  @JsonKey(
    toJson: materialTypeToString,
    fromJson: materialTypeFromString,
  )
  final StudyMaterialType type;

  /// Converts [StudyMaterialType] into a [String].
  // ignore: missing_return
  static String materialTypeToString(StudyMaterialType type) {
    switch (type) {
      case StudyMaterialType.generalDocument:
        return 'generalDocument';
      case StudyMaterialType.summary:
        return 'summary';

      case StudyMaterialType.lectureNotes:
        return 'lectureNotes';

      case StudyMaterialType.examPapers:
        return 'examPapers';

      case StudyMaterialType.exercise:
        return 'exercise';

      case StudyMaterialType.externalResource:
        return 'externalResource';
    }
  }

  /// Getting [StudyMaterialType] from a [String].
  static StudyMaterialType materialTypeFromString(String typeString) {
    for (StudyMaterialType type in StudyMaterialType.values) {
      if (materialTypeToString(type) == typeString) {
        return type;
      }
    }
    return null;
  }

  static String googleDriveIdFromUrl(String driveUrl) {
    RegExp regExp = RegExp(r"([a-z0-9_-]{25,})[$/&?]",
        multiLine: true, caseSensitive: false);
    var match = regExp.stringMatch(driveUrl);

    return match.substring(0, match.length - 1);
  }

  StudyMaterial copyWith({
    String id,
    String label,
    String description,
    String thumbnailUrl,
    String iconUrl,
    String materialUrl,
    String courseName,
    String localPath,
    int created,
    StudyMaterialType type,
    String courseId,
    String uploaderName,
    String uploaderId,
  }) =>
      StudyMaterial(
        id: id ?? this.id,
        label: label ?? this.label,
        description: description ?? this.description,
        thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
        iconUrl: iconUrl ?? this.iconUrl,
        materialUrl: materialUrl ?? this.materialUrl,
        localPath: localPath ?? this.localPath,
        courseName: courseName ?? this.courseName,
        courseId: courseId ?? this.courseId,
        created: created ?? this.created,
        type: type ?? this.type,
        uploaderName: uploaderName ?? this.uploaderName,
        uploaderId: uploaderId ?? this.uploaderId,
      );


  factory StudyMaterial.fromJson(Map<String, dynamic> json) =>
      _$StudyMaterialFromJson(json);

  Map<String, dynamic> toJson() => _$StudyMaterialToJson(this);

  static Map<String, dynamic> jsonFrom(StudyMaterial materialEntity) =>
      _$StudyMaterialToJson(materialEntity);
}
