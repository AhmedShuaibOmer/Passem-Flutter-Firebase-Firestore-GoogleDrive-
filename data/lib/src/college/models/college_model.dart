/*
 * Created Date: 2/28/21 1:08 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:domain/domain.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'college_model.g.dart';

@JsonSerializable()
class College extends CollegeEntity {
  const College({
    @required this.id,
    @required String name,
  }) : super(id: id, name: name);

  /// The current college's id.
  ///
  /// we do not need to write the college id inside the document in firestore
  /// since it gonna be the document id.
  ///
  /// this is a workaround to disallow including the field only in the
  /// toJson function.
  @override
  @JsonKey(toJson: toNull, includeIfNull: false)
  final String id;

  static toNull(_) => null;

  College copyWith({
    String id,
    String name,
  }) =>
      College(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory College.fromJson(Map<String, dynamic> json) =>
      _$CollegeFromJson(json);

  Map<String, dynamic> toJson() => _$CollegeToJson(this);
}
