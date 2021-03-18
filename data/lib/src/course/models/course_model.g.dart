// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Course _$CourseFromJson(Map<String, dynamic> json) {
  return Course(
    id: json['id'] as String,
    name: json['name'] as String,
    deepLink: json['deepLink'] as String,
  );
}

Map<String, dynamic> _$CourseToJson(Course instance) {
  final val = <String, dynamic>{
    'name': instance.name,
    'deepLink': instance.deepLink,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', Course.toNull(instance.id));
  return val;
}
