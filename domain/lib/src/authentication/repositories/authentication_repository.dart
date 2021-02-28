/*
 * Created Date: 2/7/21 1:08 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021 SafePass
 *
 */
import 'package:dartz/dartz.dart';

import '../../core/core.dart';

enum AuthenticationStatus {
  authenticated,
  newUserAuthenticated,
  unauthenticated,
  authenticationFailed,
  unknown
}

abstract class AuthenticationRepository {
  /// Stream of [AuthenticationStatus] which will emit the current status when
  /// the authentication status changes.
  ///
  /// Emits [UserEntity.empty] if the user is not authenticated.
  ///
  Stream<AuthenticationStatus> get status;

  /// Authenticates a user using his google email address
  ///
  /// Throws a [LoginWithGoogleFailure] if an exception occurs.
  Future<Either<Failure, void>> loginWithGoogle();

  /// Asks for the user permission to fully access there drive storage,
  /// returns [True] if the user accepted or [False] otherwise.
  ///
  /// Throws a [RequestPermissionFailure] if an exception occurs.
  Future<Either<Failure, bool>> requestDrivePermission();

  /// Signs out the current user which will emit
  /// [UserEntity.empty] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<Either<Failure, void>> logOutUser();

  /// Used to clean or the resources from the memory.
  void dispose();
}
