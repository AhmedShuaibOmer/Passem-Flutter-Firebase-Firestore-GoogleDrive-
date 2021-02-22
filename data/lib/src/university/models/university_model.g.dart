// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'university_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

University _$UniversityFromJson(Map<String, dynamic> json) {
  return University(
    id: json['id'] as String,
    name: json['name'] as String,
    logoUrl: json['logoUrl'] as String,
  );
}

Map<String, dynamic> _$UniversityToJson(University instance) {
  final val = <String, dynamic>{
    'name': instance.name,
    'logoUrl': instance.logoUrl,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', University.toNull(instance.id));
  return val;
}
