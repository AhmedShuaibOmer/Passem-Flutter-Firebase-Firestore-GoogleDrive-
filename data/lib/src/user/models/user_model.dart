/*
 * Created Date: 2/8/21 2:12 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021 SafePass
 *
 */

import 'package:domain/domain.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User extends UserEntity {
  /// {@macro user}
  const User({
    @required this.id,
    String name,
    @required String email,
    String role,
    String photoUrl,
    String universityId,
    this.courses,
    this.uploadedDocuments,
    this.starredDocuments,
    this.sharedHardBooks,
  }) : super(
          id: id,
          name: name,
          email: email,
          role: role,
          photoUrl: photoUrl,
          universityId: universityId,
          courses: courses,
          uploadedDocuments: uploadedDocuments,
          starredDocuments: starredDocuments,
          sharedHardBooks: sharedHardBooks,
        );

  User copyWith({
    String uid,
    String email,
    String name,
    String role,
    String photoUrl,
    String universityId,
    List<String> courses,
    List<String> uploadedDocuments,
    List<String> starredDocuments,
    List<String> sharedHardBooks,
  }) =>
      User(
        id: id ?? this.id,
        email: email ?? this.email,
        name: name ?? this.name,
        role: role ?? this.role,
        photoUrl: photoUrl ?? this.photoUrl,
        universityId: universityId ?? this.universityId,
        courses: courses ?? this.courses,
        uploadedDocuments: uploadedDocuments ?? this.uploadedDocuments,
        starredDocuments: starredDocuments ?? this.starredDocuments,
        sharedHardBooks: sharedHardBooks ?? this.sharedHardBooks,
      );

  /// The current user's id.
  ///
  /// we do not need to write the user id inside the document in firestore
  /// since it gonna be the document id.
  ///
  /// this is a workaround to disallow including the file only in the
  /// toJson function.
  @override
  @JsonKey(toJson: toNull, includeIfNull: false)
  final String id;

  static toNull(_) => null;

  /// the next four fields well be added as subCollections inside the
  /// user document and they well be treated as collections,
  /// so we won't map them to/from json.
  @override
  @JsonKey(ignore: true)
  final List<String> courses;
  @override
  @JsonKey(ignore: true)
  final List<String> uploadedDocuments;
  @override
  @JsonKey(ignore: true)
  final List<String> starredDocuments;
  @override
  @JsonKey(ignore: true)
  final List<String> sharedHardBooks;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
