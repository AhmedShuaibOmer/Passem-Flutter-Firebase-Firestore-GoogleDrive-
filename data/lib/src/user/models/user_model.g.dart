// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    role: json['role'] as String,
    photoUrl: json['photoUrl'] as String,
    universityId: json['universityId'] as String,
    collegeId: json['collegeId'] as String,
    baseAppFolderId: json['baseAppFolderId'] as String,
    courses: (json['courses'] as List)?.map((e) => e as String)?.toList(),
    sharedMaterials:
        (json['sharedMaterials'] as List)?.map((e) => e as String)?.toList(),
    sharedMaterialsCount: json['sharedMaterialsCount'] as int,
    starredMaterials:
        (json['starredMaterials'] as List)?.map((e) => e as String)?.toList(),
    sharedHardBooks:
        (json['sharedHardBooks'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$UserToJson(User instance) {
  final val = <String, dynamic>{
    'email': instance.email,
    'name': instance.name,
    'role': instance.role,
    'photoUrl': instance.photoUrl,
    'universityId': instance.universityId,
    'collegeId': instance.collegeId,
    'baseAppFolderId': instance.baseAppFolderId,
    'courses': instance.courses,
    'sharedMaterials': instance.sharedMaterials,
    'sharedMaterialsCount': instance.sharedMaterialsCount,
    'starredMaterials': instance.starredMaterials,
    'sharedHardBooks': instance.sharedHardBooks,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', User.toNull(instance.id));
  return val;
}
