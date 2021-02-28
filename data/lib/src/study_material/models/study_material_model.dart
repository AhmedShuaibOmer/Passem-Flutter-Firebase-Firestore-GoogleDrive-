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
  static String materialTypeToString(StudyMaterialType type) => type.toString();

  /// Getting [StudyMaterialType] from a [String].
  static StudyMaterialType materialTypeFromString(String typeString) {
    for (StudyMaterialType type in StudyMaterialType.values) {
      if (type.toString() == typeString) {
        return type;
      }
    }
    return null;
  }

  StudyMaterial copyWith({
    String id,
    String label,
    String description,
    String thumbnailUrl,
    String iconUrl,
    String materialUrl,
    String courseName,
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
}
