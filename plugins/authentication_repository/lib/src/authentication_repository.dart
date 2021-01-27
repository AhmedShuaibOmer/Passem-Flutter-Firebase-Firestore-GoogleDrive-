/*
* Created Date: Saturday, January 23rd 2021, 10:55:13 pm
 * Author: Ahmed S.Omer
 * 
 * Copyright (c) 2021 SafePass
 */

import 'dart:async';

import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;
import 'package:meta/meta.dart';
import 'package:preferences/preferences.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  static Future<AuthenticationRepository> getInstance() async {
    SharedPreferencesService sharedPrefService =
        await SharedPreferencesService.instance;

    return AuthenticationRepository(sharedPrefService);
  }

  AuthenticationRepository(this._sharedPrefService) {
    _authToken = _sharedPrefService.authToken;
  }

  final SharedPreferencesService _sharedPrefService;

  String _authToken;

  final _controller = StreamController<AuthenticationStatus>();

  final wp.WordPressService _wordPress = wp.WordPressService.instance;

  Stream<AuthenticationStatus> get status async* {
    if (_authToken == null) {
      yield AuthenticationStatus.unauthenticated;
    } else {
      _wordPress.authenticateViaToken(_authToken);
      yield AuthenticationStatus.authenticated;
    }
    yield* _controller.stream;
  }

  Future<String> logIn({
    @required String username,
    @required String password,
  }) async {
    assert(username != null);
    assert(password != null);
    Future<wp.User> response = _wordPress.authenticateUser(
      username: username,
      password: password,
    );

    response.then((user) {
      _sharedPrefService.setAuthToken(_wordPress.getToken());
      _controller.add(AuthenticationStatus.authenticated);
      print('User authentecated: $user');
      return _wordPress.getToken();
    }).catchError((err) {
      print('Failed to fetch user: $err');
    });
    return null;
  }

  void logOut(/*{@required final String token}*/) {
    _sharedPrefService.setAuthToken(_wordPress.getToken());
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
