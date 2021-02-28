/*
 * Created Date: 2/20/21 9:29 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';

import '../../user/user.dart';
import '../google_auth/google_auth_service.dart';

class FirebaseAuthService {
  static auth.FirebaseAuth _firebaseAuth;
  static GoogleAuthService _googleAuthService;
  static FirebaseAuthService _instance;

  FirebaseAuthService._internal();

  static FirebaseAuthService get instance {
    if (_instance == null) {
      _instance = FirebaseAuthService._internal();
    }

    if (_firebaseAuth == null) {
      _firebaseAuth = auth.FirebaseAuth.instance;
    }

    if (_googleAuthService == null) {
      _googleAuthService = GoogleAuthService.instance;
    }

    return _instance;
  }

  User get currentUser {
    final user = _firebaseAuth.currentUser;
    return user == null ? null : user.toUser;
  }

  String get currentUserId {
    return _firebaseAuth.currentUser.uid;
  }

  Future<bool> logInWithGoogle() async {
    bool isNewUser = false;

    final GoogleSignInAuthentication googleAuth =
        await _googleAuthService.signIn();
    // Create a new credential
    final auth.GoogleAuthCredential credential =
        auth.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Once signed in with google sign to firebase.
    await _firebaseAuth.signInWithCredential(credential).then((value) {
      // Check if the signed in user is new.
      if (value.additionalUserInfo.isNewUser) {
        isNewUser = true;
      }
    });
    return isNewUser;
  }

  Future<void> logoutUser() async {
    await _googleAuthService.signOut();
    await _firebaseAuth.signOut();
    if (!await _googleAuthService.isSignedIn()) print("User Sign Out");
  }

  Future<void> updateUserName(String name) async {
    await _firebaseAuth.currentUser.updateProfile(displayName: name);
  }

  Future<void> updateUserProfilePic(String photoUrl) async {
    await _firebaseAuth.currentUser.updateProfile(photoURL: photoUrl);
  }
}

extension on auth.User {
  User get toUser {
    return User(
      id: uid,
      email: email,
      name: displayName,
      photoUrl: photoURL,
    );
  }
}
