/*
 * Created Date: 2/9/21 4:39 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021 SafePass
 *
 */
import '../../core/core.dart';

/// Thrown during the login process if a failure occurs.
class LogInFailure extends Failure {}

/// Thrown during the logout process if a failure occurs.
class LogOutFailure extends Failure {}

/// Thrown during any permission request process if a failure occurs.
class RequestPermissionFailure extends Failure {}

