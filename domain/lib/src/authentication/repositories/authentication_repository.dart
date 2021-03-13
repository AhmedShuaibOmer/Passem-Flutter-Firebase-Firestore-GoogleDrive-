/*
 * Created Date: 2/7/21 1:08 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021 SafePass
 *
 */
import 'package:dartz/dartz.dart';
import 'package:domain/domain.dart';

import '../../core/core.dart';

abstract class AuthenticationRepository {
  /// Stream of [UserEntity] which will emit the current user when
  /// the authentication status changes.
  ///
  /// This stream holds the current user across the app.
  ///
  /// Emits an updated user after each update to the user info.
  ///
  /// Emits [UserEntity.empty] if there is no user authenticated.
  ///
  Stream<UserEntity> get user;

  /// Authenticates a user using his google email address
  ///
  /// Throws a [LoginWithGoogleFailure] if an exception occurs.
  Future<Either<Failure, void>> loginWithGoogle();

  /// Signs out the current user which will emit
  /// [UserEntity.empty] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<Either<Failure, void>> logOutUser();
}
