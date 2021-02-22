/*
 * Created Date: 2/20/21 10:55 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:domain/domain.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'university_model.g.dart';

@JsonSerializable()
class University extends UniversityEntity {
  const University({
    @required this.id,
    @required String name,
    String logoUrl,
  }) : super(id: id, name: name, logoUrl: logoUrl);

  /// The current university's id.
  ///
  /// we do not need to write the university id inside the document in firestore
  /// since it gonna be the document id.
  ///
  /// this is a workaround to disallow including the file only in the
  /// toJson function.
  @override
  @JsonKey(toJson: toNull, includeIfNull: false)
  final String id;

  static toNull(_) => null;

  University copyWith({
    String uid,
    String name,
    String logoUrl,
  }) =>
      University(
        id: id ?? this.id,
        name: name ?? this.name,
        logoUrl: logoUrl ?? this.logoUrl,
      );

  factory University.fromJson(Map<String, dynamic> json) =>
      _$UniversityFromJson(json);

  Map<String, dynamic> toJson() => _$UniversityToJson(this);
}
