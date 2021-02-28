/*
 * Created Date: 2/26/21 10:02 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v2.dart';

class GoogleAuthService {
  static GoogleSignIn _googleSignIn;
  static GoogleAuthService _instance;

  GoogleAuthService._internal();

  static GoogleAuthService get instance {
    if (_instance == null) {
      _instance = GoogleAuthService._internal();
    }

    if (_googleSignIn == null) {
      _googleSignIn = GoogleSignIn.standard();
    }

    return _instance;
  }

  Future<GoogleSignInAuthentication> signIn() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    return googleAuth;
  }

  Future<bool> requestDrivePermission() async {
    bool granted = false;
    await _googleSignIn
        .requestScopes([DriveApi.DriveScope]).then((value) => granted = value);
    print("User permission ${(granted) ? 'granted' : 'not granted'}");
    return Future.value(granted);
  }

  Future<void> signOut() => _googleSignIn.signOut();

  Future<bool> isSignedIn() => _googleSignIn.isSignedIn();

  Future<Map<String, String>> get authHeaders =>
      _googleSignIn.currentUser.authHeaders;
}
