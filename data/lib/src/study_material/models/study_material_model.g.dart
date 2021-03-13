// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_material_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudyMaterial _$StudyMaterialFromJson(Map<String, dynamic> json) {
  return StudyMaterial(
    id: json['id'] as String,
    label: json['label'] as String,
    description: json['description'] as String,
    thumbnailUrl: json['thumbnailUrl'] as String,
    iconUrl: json['iconUrl'] as String,
    materialUrl: json['materialUrl'] as String,
    localPath: json['localPath'] as String,
    courseName: json['courseName'] as String,
    created: json['created'] as int,
    type: StudyMaterial.materialTypeFromString(json['type'] as String),
    courseId: json['courseId'] as String,
    uploaderName: json['uploaderName'] as String,
    uploaderId: json['uploaderId'] as String,
    fileSize: json['fileSize'] as String,
  );
}

Map<String, dynamic> _$StudyMaterialToJson(StudyMaterial instance) {
  final val = <String, dynamic>{
    'label': instance.label,
    'description': instance.description,
    'thumbnailUrl': instance.thumbnailUrl,
    'iconUrl': instance.iconUrl,
    'materialUrl': instance.materialUrl,
    'courseName': instance.courseName,
    'courseId': instance.courseId,
    'uploaderName': instance.uploaderName,
    'uploaderId': instance.uploaderId,
    'created': instance.created,
    'fileSize': instance.fileSize,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', StudyMaterial.toNull(instance.id));
  writeNotNull('localPath', StudyMaterial.toNull(instance.localPath));
  val['type'] = StudyMaterial.materialTypeToString(instance.type);
  return val;
}
