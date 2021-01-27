/*
 *
 *  Created Date: 1/24/21 12:26 AM
 *  Author: Ahmed S.Omer
 *
 * Copyright (c) 2021 SafePass
 *
 */

import 'dart:async';

//import 'package:uuid/uuid.dart';//Uuid().v4()
import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;
import 'package:flutter_wordpress/schemas/user.dart';
import 'package:preferences/preferences.dart';

class UserRepository {
  User _user;

  final wp.WordPressService _wordPress = wp.WordPressService.instance;

  final SharedPreferencesService _sharedPrefService;

  static Future<UserRepository> getInstance() async {
    SharedPreferencesService sharedPrefService =
        await SharedPreferencesService.instance;

    return UserRepository(sharedPrefService);
  }

  UserRepository(this._sharedPrefService);

  Future<User> getUser() async {
    if (_user != null) return _user;
    String token = _sharedPrefService.authToken;
    return _wordPress
        .authenticateViaToken(token)
        .then((value) => _user = value);
  }
}
