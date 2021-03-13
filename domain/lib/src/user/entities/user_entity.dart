/*
 * Created Date: 2/7/21 9:49 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021 SafePass
 *
 */
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// {@template user}
/// User entity
///
/// [UserEntity.empty] represents an unauthenticated user.
/// {@endtemplate}
class UserEntity extends Equatable {
  /// {@macro user}
  const UserEntity({
    @required this.email,
    @required this.id,
    @required this.name,
    @required this.role,
    @required this.photoUrl,
    @required this.universityId,
    @required this.collegeId,
    @required this.courses,
    @required this.sharedMaterials,
    this.sharedMaterialsCount = 0,
    @required this.starredMaterials,
    @required this.sharedHardBooks,
    @required this.baseAppFolderId,
  })  : assert(email != null),
        assert(id != null);

  /// The current user's id.
  final String id;

  /// The current user's email address.
  final String email;

  /// The current user's name (display name).
  final String name;

  /// the current user's role.
  final String role;

  /// Url for the current user's photo url.
  final String photoUrl;

  /// The current user's university ID.
  final String universityId;

  /// The current user's college ID.
  final String collegeId;

  /// The id if the folder we save all the user user uploaded
  /// materials in his drive storage.
  final String baseAppFolderId;

  /// The current user's followed courses IDs.
  final List<String> courses;

  /// The current user's shared materials IDs.
  final List<String> sharedMaterials;

  /// The current user's shared materials count.
  final int sharedMaterialsCount;

  /// The current user's starred materials IDs.
  final List<String> starredMaterials;

  /// The current user's shared books IDs.
  final List<String> sharedHardBooks;

  /// Empty user which represents an unauthenticated user.
  static const empty = UserEntity(
    email: '',
    id: '',
    name: null,
    role: null,
    photoUrl: null,
    universityId: null,
    collegeId: null,
    courses: null,
    sharedMaterials: null,
    starredMaterials: null,
    sharedHardBooks: null,
    baseAppFolderId: null,
  );

  /// If true true the user haven't complete their sign up process.
  bool get isNewUser =>
      this.id.isNotEmpty &&
      this.email.isNotEmpty &&
      (this.universityId == null || this.collegeId == null);

  @override
  List<Object> get props => [
        email,
        id,
        name,
        role,
        photoUrl,
        universityId,
        collegeId,
        courses,
        sharedMaterials,
        sharedMaterialsCount,
        starredMaterials,
        sharedHardBooks,
        baseAppFolderId,
      ];
}
