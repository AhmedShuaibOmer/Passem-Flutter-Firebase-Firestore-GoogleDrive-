/*
 * Created Date: 2/19/21 11:30 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/src/university/models/university_model.dart';
import 'package:meta/meta.dart';

import '../../user/models/user_model.dart';
import 'collections_paths.dart';

class FirestoreService {
  static FirestoreService _instance;
  static FirebaseFirestore _firestore;

  FirestoreService._internal();

  static FirestoreService get instance {
    if (_instance == null) {
      _instance = FirestoreService._internal();
    }

    if (_firestore == null) {
      _firestore = FirebaseFirestore.instance;
    }

    return _instance;
  }

  CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection(usersPath);
  CollectionReference _universitiesCollection =
      FirebaseFirestore.instance.collection(universitiesPath);

  void addNewUser(User newUser) {
    _usersCollection.doc(
      /* The document id should be the same as user id;
      * allowing easier referencing.
      * */
      newUser.id,
    )..set(
        /* pass the user info .*/
        newUser.toJson(),
      );
  }

  Future<User> getUser({@required String userId}) async {
    print('fetching from firestore....');
    final DocumentReference userDocRef = _usersCollection.doc(userId);
    final DocumentSnapshot userDoc = await userDocRef.get();
    print('User document fetched from firestore');

    final user = User.fromJson(userDoc.toJson);

    final List<String> coursesIds =
        _getDocsIds(await userDocRef.collection('courses').get());
    final List<String> starredDocumentsIds =
        _getDocsIds(await userDocRef.collection('starredCourses').get());
    final List<String> uploadedDocumentsIds =
        _getDocsIds(await userDocRef.collection('uploadedCourses').get());
    final List<String> sharedHardBooksIds =
        _getDocsIds(await userDocRef.collection('sharedHardBooks').get());
    print('all User properties fetched from firestore.');
    return user.copyWith(
      courses: coursesIds,
      starredDocuments: starredDocumentsIds,
      sharedHardBooks: sharedHardBooksIds,
      uploadedDocuments: uploadedDocumentsIds,
    );
  }

  Future<List<University>> getAllUniversities() async {
    final QuerySnapshot results = await _universitiesCollection.get();
    print('Universities collection fetched from firestore.');
    final List<QueryDocumentSnapshot> universityDocuments = results.docs;
    print(
        'Universities list fro universities collection fetched from firestore.');
    final List<University> universities = [];
    universityDocuments.forEach((universityDoc) {
      universities.add(
        University.fromJson(universityDoc.toJson),
      );
      print('New University added to the list.');
    });
    print('All Universities added to the list.');
    return universities;
  }

  List<String> _getDocsIds(QuerySnapshot snapshot) {
    List<String> ids;
    for (var doc in snapshot.docs) {
      ids.add(doc.id);
    }
    return ids;
  }

  Future<void> updateUser({
    String userId,
    String name,
    String photoUrl = '',
    String role,
    String universityId,
  }) async {
    final Map<String, dynamic> data = {};

    if (name != null) data.addAll({"name": name});
    if (photoUrl != '') data.addAll({"photoUrl": photoUrl});
    if (role != null) data.addAll({"role": role});
    if (universityId != null) data.addAll({"universityId": universityId});

    _usersCollection.doc(userId).set(
          data,
          SetOptions(merge: true),
        );
  }
}

extension on DocumentSnapshot {
  Map<String, dynamic> get toJson {
    final jsonData = data();
    jsonData.addAll({"id": id});
    return jsonData;
  }
}
