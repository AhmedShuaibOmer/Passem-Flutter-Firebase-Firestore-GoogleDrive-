/*
 * Created Date: 2/19/21 11:30 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/src/services/services.dart';
import 'package:data/src/study_material/models/study_material_model.dart';
import 'package:domain/domain.dart';

import '../../college/models/college_model.dart';
import '../../course/models/course_model.dart';
import '../../university/models/university_model.dart';
import '../../user/models/user_model.dart';
import '../firebase_auth/firebase_auth_service.dart';
import 'collections_paths.dart';

class FirestoreService {
  static FirestoreService _instance;
  static FirebaseFirestore _firestore;
  static FirebaseAuthService _firebaseAuthService;

  FirestoreService._internal();

  static FirestoreService get instance {
    if (_instance == null) {
      _instance = FirestoreService._internal();
    }

    if (_firestore == null) {
      _firestore = FirebaseFirestore.instance;
    }

    if (_firebaseAuthService == null) {
      _firebaseAuthService = FirebaseAuthService.instance;
    }

    return _instance;
  }

  // **************************************************************************
  // User related: BEGIN
  // **************************************************************************

  CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection(usersPath);
  final _controller = StreamController<User>();

  /// This stream is directly linked to the authentication state when it send
  /// an empty user it means no user authenticated.
  /// and it emits every change in the user, a new user entity well be
  /// emitted every time [FirestoreService.getUser()] invoked to get
  /// the current user.
  Stream<UserEntity> get userChanges async* {
    yield* _controller.stream.map((event) {
      currentUser = event;
      return event;
    });
  }

  void userLoggedOut() {
    _controller.add(UserEntity.empty);
  }

  UserEntity currentUser;

  Future<void> addNewUser(User newUser) async {
    await _usersCollection
        .doc(
          /* The document id should be the same as user id;
      * allowing easier referencing.
      * */
          newUser.id,
        )
        .set(
          /* pass the user info .*/
          newUser.toJson(),
        )
        .then((value) async => await getUser());
  }

  /// Gets user info from cloud firestore.
  ///
  /// [userId] - the id for the required user info , if null the current
  /// authenticated user info well be retrieved.
  Future<void> getUser({String userId}) async {
    print('fetching from firestore....');

    final DocumentSnapshot userDoc = await _usersCollection
        .doc(
          userId ?? _firebaseAuthService.currentUserId,
        )
        .get();
    print('User document fetched from firestore');
    final user = User.fromJson(userDoc.toJson);
    print('all User properties mapped into an object.');
    if (userId == null) _controller.add(user);
    print('User Entity emitted : ${user.name}');
  }

  Stream<List<UserEntity>> mostContributors() async* {
    yield* _usersCollection
        .orderBy(
          'sharedMaterialsCount',
          descending: true,
        )
        .where(
          'universityId',
          isEqualTo: currentUser.universityId,
        )
        .where(
          'collegeId',
          isEqualTo: currentUser.collegeId,
        )
        .limit(10)
        .snapshots()
        .map((querySnapshot) {
      final List<User> users = [];
      querySnapshot.docs.forEach((queryDocumentSnapshot) {
        users.add(User.fromJson(queryDocumentSnapshot.toJson));
      });
      return users;
    });
  }

  Future<void> updateUser({
    String name,
    String photoUrl = '',
    String role,
    String universityId,
    String collegeId,
  }) async {
    final Map<String, dynamic> data = {};

    if (name != null) data.addAll({"name": name});
    if (photoUrl != '') data.addAll({"photoUrl": photoUrl});
    if (role != null) data.addAll({"role": role});
    if (universityId != null) data.addAll({"universityId": universityId});
    if (collegeId != null) data.addAll({"collegeId": collegeId});

    _usersCollection
        .doc(
          _firebaseAuthService.currentUserId,
        )
        .update(
          data,
        )
        .then((value) async => await getUser());
  }

  // **************************************************************************
  // User related: END
  // **************************************************************************

  // **************************************************************************
  // University related: BEGIN
  // **************************************************************************

  CollectionReference _universitiesCollection =
      FirebaseFirestore.instance.collection(universitiesPath);

  Future<List<University>> getAllUniversities() async {
    final List<University> universities = [];
    await _universitiesCollection.get().then((snapshot) {
      snapshot.docs.forEach((universityDoc) {
        universities.add(
          University.fromJson(universityDoc.toJson),
        );
        print('New University added to the list.');
      });
    });
    print(
        'Universities list from universities collection fetched from firestore.');
    return universities;
  }

  Future<University> getUniversity({String universityId}) async {
    University university;
    await _universitiesCollection
        .doc(universityId ?? currentUser.universityId)
        .get()
        .then((value) => university = University.fromJson(value.toJson));
    return university;
  }

  // **************************************************************************
  // University related: END
  // **************************************************************************

  // **************************************************************************
  // College related: BEGIN
  // **************************************************************************
  CollectionReference _collegesCollection(String universityId) {
    return FirebaseFirestore.instance.collection(
      collegesPath(universityId),
    );
  }

  Future<College> getCollege({String collegeId}) async {
    College college;

    await _collegesCollection(currentUser.universityId)
        .doc(collegeId ?? currentUser.collegeId)
        .get()
        .then((value) => college = College.fromJson(value.toJson));
    return college;
  }

  Future<List<College>> getAllColleges(String universityId) async {
    final List<College> colleges = [];
    await _collegesCollection(universityId).get().then((snapshot) {
      snapshot.docs.forEach((collegeDoc) {
        colleges.add(
          College.fromJson(collegeDoc.toJson),
        );
        print('New College added to the list.');
      });
    });
    print('Colleges list from colleges collection fetched from firestore.');

    return colleges;
  }

  // **************************************************************************
  // College related: END
  // **************************************************************************

  // **************************************************************************
  // Course related: BEGIN
  // **************************************************************************
  CollectionReference get _coursesCollection {
    return FirebaseFirestore.instance.collection(
      coursesPath(
        currentUser.universityId,
        currentUser.collegeId,
      ),
    );
  }

  Future<String> addCourse({
    String courseName,
  }) async {
    List<String> searchKeywords = await _generateSearchKeywords(courseName);

    String courseId;
    await _coursesCollection.add(
      {
        "name": courseName,
        "searchKeywords": searchKeywords,
      },
    ).then((courseRef) async {
      courseId = courseRef.id;
      final dynamicLinksService = DynamicLinkService();
      String deepLinK =
          await dynamicLinksService.createCourseDynamicLink(courseId);
      await _coursesCollection
          .doc(courseId)
          .set({"deepLink": deepLinK}, SetOptions(merge: true));
    });
    return courseId;
  }

  Future<void> subscribeToCourse({
    String courseId,
  }) async {
    await _usersCollection
        .doc(
      _firebaseAuthService.currentUserId,
    )
        .update(
      {
        "courses": FieldValue.arrayUnion([courseId]),
      },
    ).then((value) async => await getUser());
  }

  Query searchCourses(String query) {
    String sQuery = query.toLowerCase();
    return _coursesCollection
        .where(
          'searchKeywords',
          arrayContains: sQuery,
        )
        .orderBy('name');
  }

  Future<void> unsubscribeFromCourse({
    String courseId,
  }) async {
    await _usersCollection
        .doc(
      _firebaseAuthService.currentUserId,
    )
        .update(
      {
        "courses": FieldValue.arrayRemove([courseId]),
      },
    ).then((value) async => await getUser());
  }

  Future<List<Course>> getCourses(List<String> coursesIds) async {
    List<Course> courses = [];
    if (coursesIds == null || coursesIds.isEmpty) return null;
    for (var element in coursesIds) {
      await _coursesCollection.doc(element).get().then((value) {
        print('courses fetched from firestore ${value.toJson}');
        courses.add(
          Course.fromJson(value.toJson),
        );
      });
    }
    return courses;
  }

  Future<void> updateCourse({
    String courseId,
    String name,
  }) async {
    await _coursesCollection
        .doc(
      courseId,
    )
        .update(
      {"name": name},
    );
  }

  Future<void> deleteCourse({
    String courseId,
  }) async {
    await _coursesCollection
        .doc(
          courseId,
        )
        .delete();
  }

  // **************************************************************************
  // Course related: END
  // **************************************************************************

  // **************************************************************************
  // Study Material related: BEGIN
  // **************************************************************************
  CollectionReference get _studyMaterialsCollection {
    return FirebaseFirestore.instance.collection(
      studyMaterialsPath(
        currentUser.universityId,
        currentUser.collegeId,
      ),
    );
  }

  Future<void> addMaterialToStarred({String materialId}) async {
    await _usersCollection
        .doc(
      _firebaseAuthService.currentUserId,
    )
        .update(
      {
        "starredMaterials": FieldValue.arrayUnion([materialId]),
      },
    ).then((value) async => await getUser());
  }

  Future<void> removeMaterialFromStarred({String materialId}) async {
    await _usersCollection
        .doc(
      _firebaseAuthService.currentUserId,
    )
        .update(
      {
        "starredMaterials": FieldValue.arrayRemove([materialId]),
      },
    ).then((value) async => await getUser());
  }

  Future<String> addStudyMaterial({
    String name,
    String description,
    String materialUrl,
    String courseId,
    String courseName,
    StudyMaterialType type,
  }) async {
    String materialId;

    Map<String, dynamic> data = {
      "label": name,
      "description": description,
      "materialUrl": materialUrl,
      "courseId": courseId,
      "courseName": courseName,
      "created": DateTime.now().millisecondsSinceEpoch,
      "type": StudyMaterial.materialTypeToString(type),
      "uploaderId": currentUser.id,
      "uploaderName": currentUser.name,
    };

    List<String> searchKeywords = await _generateSearchKeywords(courseName);
    data.addAll({'searchKeywords': searchKeywords});

    await _studyMaterialsCollection.add(data).then(
      (value) async {
        materialId = value.id;
        await _usersCollection
            .doc(
          _firebaseAuthService.currentUserId,
        )
            .update(
          {
            "sharedMaterials": FieldValue.arrayUnion([materialId]),
            "sharedMaterialsCount": FieldValue.increment(1),
          },
        ).then((value) async => await getUser());
      },
    );
    return materialId;
  }

  Future<String> addExternalStudyMaterial({
    String name,
    String description,
    String materialUrl,
    String courseId,
    String courseName,
  }) async {
    String materialId;
    Map<String, dynamic> data = <String, dynamic>{
      'label': name,
      'description': description,
      'materialUrl': materialUrl,
      'courseName': courseName,
      'type': StudyMaterial.materialTypeToString(
          StudyMaterialType.externalResource),
      'courseId': courseId,
      'uploaderName': currentUser.name,
      'uploaderId': currentUser.id,
      'created': DateTime.now().millisecondsSinceEpoch,
    };
    List<String> searchKeywords = await _generateSearchKeywords(courseName);
    data.addAll({'searchKeywords': searchKeywords});
    await _studyMaterialsCollection.add(data).then(
      (value) async {
        materialId = value.id;
        await _usersCollection
            .doc(
          _firebaseAuthService.currentUserId,
        )
            .update(
          {
            "sharedMaterials": FieldValue.arrayUnion([materialId]),
            "sharedMaterialsCount": FieldValue.increment(1),
          },
        ).then((value) async => await getUser());
      },
    );
    return materialId;
  }

  Future<void> deleteStudyMaterial(
      {String materialId, String uploaderId}) async {
    await _studyMaterialsCollection
        .doc(materialId)
        .delete()
        .then((value) async {
      await _usersCollection.doc(uploaderId).update({
        "sharedMaterials": FieldValue.arrayRemove([materialId]),
        "sharedMaterialsCount": FieldValue.increment(1),
      }).then((value) async => await getUser());
    });
  }

  Future<void> updateMaterial(
      {String materialId, String name, String description}) async {
    Map<String, String> data = {};
    if (name != null) data.addAll({"name": name});
    if (description != null) data.addAll({"description": description});

    _studyMaterialsCollection.doc(materialId).update(data);
  }

  Query materialsForCourse({
    String courseId,
    StudyMaterialType materialType,
  }) {
    return _studyMaterialsCollection
        .where(
          'courseId',
          isEqualTo: courseId,
        )
        .where(
          'type',
          isEqualTo: StudyMaterial.materialTypeToString(materialType),
        );
  }

  Stream<List<StudyMaterialEntity>> recentlyAddedMaterials() async* {
    print('starting study materials stream.');
    yield* _studyMaterialsCollection
        .orderBy(
          'created',
          descending: true,
        )
        .limit(10)
        .snapshots()
        .map((querySnapshot) {
      final List<StudyMaterialEntity> materials = [];
      querySnapshot.docs.forEach((element) {
        materials.add(StudyMaterial.fromJson(element.toJson));
      });
      return materials;
    });
  }

  Future<List<StudyMaterial>> getMaterials(
    List<String> materialsIds,
  ) async {
    List<StudyMaterial> materials = [];
    if (materialsIds == null || materialsIds.isEmpty) return null;
    for (var element in materialsIds) {
      await _studyMaterialsCollection.doc(element).get().then((value) {
        if (value.exists) {
          print('study materials fetched from firestore ${value.toJson}');
          materials.add(
            StudyMaterial.fromJson(value.toJson),
          );
        }
      });
    }
    return materials;
  }

  Query searchMaterials({String query, StudyMaterialType materialType}) {
    String sQuery = query.toLowerCase();
    return _studyMaterialsCollection
        .where(
          'searchKeywords',
          arrayContains: sQuery,
        )
        .where(
          'type',
          isEqualTo: StudyMaterial.materialTypeToString(materialType),
        )
        .orderBy('label');
  }

  // **************************************************************************
  // Study Material related: END
  // **************************************************************************

  // **************************************************************************
  // Version related: BEGIN
  // **************************************************************************

  CollectionReference _versionCollection =
      FirebaseFirestore.instance.collection(versionPath);

  Future<Map<String, dynamic>> getLatestVersionData() async {
    print('fetching from firestore....');

    final DocumentSnapshot versionDoc =
        await _versionCollection.doc('latest_version').get();
    print('Version document fetched from firestore');
    final version = versionDoc.data();
    return version;
  }

  // **************************************************************************
  // Version related: END
  // **************************************************************************

  void dispose() {
    _controller.close();
    _instance = null;
    _firestore = null;
    _firebaseAuthService = null;
  }

/*List<String> _getDocsIds(QuerySnapshot snapshot) {
    List<String> ids;
    for (var doc in snapshot.docs) {
      ids.add(doc.id);
    }
    return ids;
  }*/

  Future<List<String>> _generateSearchKeywords(String searchableValue) async {
    List<String> words = searchableValue.toLowerCase().split(" ");
    List<String> searchKeywordsList = [];
    words.forEach((word) {
      searchKeywordsList.add(word);
      String temp = "";
      for (int i = 0; i < word.length; i++) {
        temp = temp + word[i];
        if (temp != word) {
          searchKeywordsList.add(temp);
        }
        String temp1 = word.substring(i);
        if (temp1 != word) {
          searchKeywordsList.add(temp1);
        }
      }
      if (word.length > 2) {
        int i = word.length / 2 == 0 ? 1 : 0;
        for (int j = i; j < word.length / 2; j++) {
          searchKeywordsList.add(
            word.substring(j, word.length - j),
          );
        }
      }
    });
    // used to delete duplicate values.
    final List<String> keywordsList =
        List<String>.from(Set<String>.from(searchKeywordsList));
    return keywordsList;
  }
}

/// Creates json type from all document fields including the document id.
extension DocumentSnapshotExtensions on DocumentSnapshot {
  Map<String, dynamic> get toJson {
    final jsonData = data();
    jsonData.addAll({"id": id});
    return jsonData;
  }
}
