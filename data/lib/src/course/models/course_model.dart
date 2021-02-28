/*
 * Created Date: 2/26/21 2:50 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:domain/domain.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'course_model.g.dart';

@JsonSerializable()
class Course extends CourseEntity {
  Course({
    @required this.id,
    @required String name,
  }) : super(
          id: id,
          name: name,
        );

  /// The current course's id.
  ///
  /// we do not need to write the course id inside the document in firestore
  /// since it gonna be the document id.
  ///
  /// this is a workaround to disallow including the field only in the
  /// toJson function.
  @override
  @JsonKey(toJson: toNull, includeIfNull: false)
  final String id;

  static toNull(_) => null;

  Course copyWith({
    String id,
    String name,
  }) =>
      Course(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);

  Map<String, dynamic> toJson() => _$CourseToJson(this);
}
