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
    @required String name,
    @required String email,
    String role,
    @required String photoUrl,
    String universityId,
    String collegeId,
    String baseAppFolderId,
    List<String> courses = const [],
    List<String> sharedMaterials = const [],
    int sharedMaterialsCount = 0,
    List<String> starredMaterials = const [],
    List<String> sharedHardBooks = const [],
  }) : super(
          id: id,
          name: name,
          email: email,
          role: role,
          photoUrl: photoUrl,
          universityId: universityId,
          collegeId: collegeId,
          baseAppFolderId: baseAppFolderId,
          courses: courses,
          sharedMaterials: sharedMaterials,
          sharedMaterialsCount: sharedMaterialsCount,
          starredMaterials: starredMaterials,
          sharedHardBooks: sharedHardBooks,
        );

  User copyWith({
    String uid,
    String email,
    String name,
    String role,
    String photoUrl,
    String universityId,
    String collegeId,
    String baseAppFolderId,
    List<String> courses,
    List<String> sharedMaterials,
    int sharedMaterialsCount,
    List<String> starredMaterials,
    List<String> sharedHardBooks,
  }) =>
      User(
        id: id ?? this.id,
        email: email ?? this.email,
        name: name ?? this.name,
        role: role ?? this.role,
        photoUrl: photoUrl ?? this.photoUrl,
        universityId: universityId ?? this.universityId,
        collegeId: collegeId ?? this.collegeId,
        baseAppFolderId: baseAppFolderId ?? this.baseAppFolderId,
        courses: courses ?? this.courses,
        sharedMaterials: sharedMaterials ?? this.sharedMaterials,
        sharedMaterialsCount: sharedMaterialsCount ?? this.sharedMaterialsCount,
        starredMaterials: starredMaterials ?? this.starredMaterials,
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

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
