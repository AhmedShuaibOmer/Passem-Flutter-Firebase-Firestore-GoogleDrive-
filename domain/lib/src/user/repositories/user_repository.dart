/*
 * Created Date: 2/17/21 5:05 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021 SafePass
 *
 */

import 'package:dartz/dartz.dart';

import '../../../domain.dart';

abstract class UserRepository {
  /// A stream that holds the current user across the app.
  ///
  /// Emits an updated user after each update to the user info.
  Stream<UserEntity> get userChanges;

  /// Tries to fetch the user from the server.
  ///
  /// Throws a [UserFetchingFailure] if an exception occurs.
  Future<Either<Failure, void>> tryFetchUser();

  Future<Either<Failure, void>> updateUser({
    String name,
    String role,
    String universityId,
    String photoUrl,
  });

  /// Used to clean or the resources from the memory.
  void dispose();
}
