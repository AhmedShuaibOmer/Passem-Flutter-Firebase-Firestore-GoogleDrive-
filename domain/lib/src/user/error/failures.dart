/*
 * Created Date: 2/19/21 3:10 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import '../../core/core.dart';

/// Thrown during the fetching user from server process if a failure occurs.
class UserFetchingFailure extends Failure {}

/// Thrown during the updating user process if a failure occurs.
class UserUpdateFailure extends Failure {}

/// Thrown during subscribing the user to a course process if a failure occurs.
class SubscribeToCourseFailure extends Failure {}

/// Thrown during unsubscribe the user from a course process if a failure occurs.
class UnsubscribeFromCourseFailure extends Failure {}

class StarringMaterialFailure extends Failure {}

class UnStarringMaterialFailure extends Failure {}
