// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'college_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

College _$CollegeFromJson(Map<String, dynamic> json) {
  return College(
    id: json['id'] as String,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$CollegeToJson(College instance) {
  final val = <String, dynamic>{
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', College.toNull(instance.id));
  return val;
}
