/*
 * Created Date: 2/19/21 11:30 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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

  Stream<UserEntity> get userChanges async* {
    yield* _controller.stream;
  }

  Future<UserEntity> get currentUser async => await userChanges.last;

  void addNewUser(User newUser) {
    _usersCollection
        .doc(
          /* The document id should be the same as user id;
      * allowing easier referencing.
      * */
          newUser.id,
        )
        .set(
          /* pass the user info .*/
          newUser.toJson(),
        );
  }

  Future<void> getUser({String userId}) async {
    print('fetching from firestore....');

    if (userId == null) userId = _firebaseAuthService.currentUserId;

    final DocumentSnapshot userDoc = await _usersCollection.doc(userId).get();
    print('User document fetched from firestore');
    final user = User.fromJson(userDoc.toJson);
    print('all User properties mapped into an object.');
    _controller.add(user);
    print('User Entity emitted : $user');
  }

  Stream<List<UserEntity>> mostContributors() async* {
    User currentUser = await this.currentUser;
    yield* _usersCollection
        .orderBy('sharedMaterialsCount')
        .where(
          'universityId',
          isEqualTo: currentUser.universityId,
        )
        .limit(10)
        .snapshots()
        .map((querySnapshot) {
      final List<User> users = [];
      querySnapshot.docs.map((queryDocumentSnapshot) {
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
  }) async {
    final Map<String, dynamic> data = {};

    if (name != null) data.addAll({"name": name});
    if (photoUrl != '') data.addAll({"photoUrl": photoUrl});
    if (role != null) data.addAll({"role": role});
    if (universityId != null) data.addAll({"universityId": universityId});

    _usersCollection
        .doc(
          _firebaseAuthService.currentUserId,
        )
        .update(
          data,
        )
        .then((value) => getUser());
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
    UserEntity currentUser = await this.currentUser;
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
  Future<CollectionReference> get _collegesCollection async {
    UserEntity currentUser = await this.currentUser;
    return FirebaseFirestore.instance.collection(
      collegesPath(currentUser.universityId),
    );
  }

  Future<College> getCollege({String collegeId}) async {
    UserEntity currentUser = await this.currentUser;
    College college;
    CollectionReference collegesCollection = await _collegesCollection;
    await collegesCollection
        .doc(collegeId ?? currentUser.collegeId)
        .get()
        .then((value) => college = College.fromJson(value.toJson));
    return college;
  }

  Future<List<College>> getAllColleges(String universityId) async {
    final List<College> colleges = [];
    CollectionReference collegesCollection = await _collegesCollection;
    await collegesCollection.get().then((snapshot) {
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
  Future<CollectionReference> get _coursesCollection async {
    UserEntity currentUser = await this.currentUser;
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
    String courseId;
    await _coursesCollection.then((coursesRef) => coursesRef.add(
          {"name": courseName},
        ).then((courseRef) {
          courseId = courseRef.id;
        }));
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
    ).then((value) => getUser());
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
    ).then((value) => getUser());
  }

  Future<List<Course>> getCourses(List<String> coursesIds) async {
    List<Course> courses;

    CollectionReference coursesCollection = await _coursesCollection;

    coursesIds.forEach((element) {
      coursesCollection.doc(element).get().then((value) {
        courses.add(
          Course.fromJson(value.toJson),
        );
      });
    });
    return courses;
  }

  Future<void> updateCourse({
    String courseId,
    String name,
  }) async {
    await _coursesCollection.then((value) => value
            .doc(
          courseId,
        )
            .update(
          {"name": name},
        ));
  }

  Future<void> deleteCourse({
    String courseId,
  }) async {
    await _coursesCollection.then((value) => value
        .doc(
          courseId,
        )
        .delete());
  }

  // **************************************************************************
  // Course related: END
  // **************************************************************************

  // **************************************************************************
  // Study Material related: BEGIN
  // **************************************************************************
  Future<CollectionReference> get _studyMaterialsCollection async {
    UserEntity currentUser = await this.currentUser;
    return FirebaseFirestore.instance.collection(
      studyMaterialsPath(
        currentUser.universityId,
        currentUser.collegeId,
      ),
    );
  }

  Future<void> addStudyMaterial(StudyMaterial studyMaterial) async {
    await _studyMaterialsCollection.then(
      (studyMaterialsRef) => studyMaterialsRef
          .doc(studyMaterial.id)
          .set(
            studyMaterial.toJson(),
          )
          .then((value) async {
        await _usersCollection
            .doc(
          _firebaseAuthService.currentUserId,
        )
            .update(
          {
            "sharedMaterials": FieldValue.arrayUnion([studyMaterial.id]),
            "sharedMaterialsCount": FieldValue.increment(1),
          },
        ).then((value) => getUser());
      }),
    );
  }

  Future<void> deleteStudyMaterial(
      {String materialId, String uploaderId}) async {
    await _studyMaterialsCollection.then((value) {
      value.doc(materialId).delete().then((value) async {
        await _usersCollection.doc(uploaderId).update({
          "sharedMaterials": FieldValue.arrayRemove([materialId]),
          "sharedMaterialsCount": FieldValue.increment(1),
        }).then((value) => getUser());
      });
    });
  }

  updateMaterial({String materialId, String name, String description}) {
    Map<String, String> data = {};
    if (name != null) data.addAll({"name": name});
    if (description != null) data.addAll({"description": description});

    _studyMaterialsCollection.then((value) {
      value.doc(materialId).update(data);
    });
  }

  Stream<List<StudyMaterial>> materialsForCourse({
    String courseId,
    StudyMaterialType materialType,
  }) async* {
    final studyMaterialsCollection = await _studyMaterialsCollection;
    yield* studyMaterialsCollection
        .where(
          'courseId',
          isEqualTo: courseId,
        )
        .where(
          'type',
          isEqualTo: StudyMaterial.materialTypeToString(materialType),
        )
        .snapshots()
        .map((querySnapshot) {
      final List<StudyMaterial> materials = [];
      querySnapshot.docs.map((queryDocumentSnapshot) {
        materials.add(StudyMaterial.fromJson(queryDocumentSnapshot.toJson));
      });
      return materials;
    });
  }

  Stream<List<StudyMaterial>> recentlyAddedMaterials() async* {
    final studyMaterialsCollection = await _studyMaterialsCollection;
    yield* studyMaterialsCollection
        .orderBy('created')
        .snapshots()
        .map((querySnapshot) {
      final List<StudyMaterial> materials = [];
      querySnapshot.docs.map((queryDocumentSnapshot) {
        materials.add(StudyMaterial.fromJson(queryDocumentSnapshot.toJson));
      });
      return materials;
    });
  }

  Future<List<StudyMaterial>> getMaterials(
    List<String> materialsIds,
  ) async {
    List<StudyMaterial> materials;

    CollectionReference studyMaterialsCollection =
        await _studyMaterialsCollection;

    materialsIds.forEach((element) {
      studyMaterialsCollection.doc(element).get().then((value) {
        materials.add(
          StudyMaterial.fromJson(value.toJson),
        );
      });
    });
    return materials;
  }

  // **************************************************************************
  // Study Material related: END
  // **************************************************************************

  // **************************************************************************
  // Google Drive related: BEGIN
  // **************************************************************************

  Future<void> writeUserBaseFolderID(String id) async {
    await _usersCollection
        .doc(
      _firebaseAuthService.currentUserId,
    )
        .set(
      {"baseAppFolderId": id},
      SetOptions(merge: true),
    ).then((value) => getUser());
  }

  Future<String> get userBaseFolderID async {
    UserEntity currentUser = await this.currentUser;
    return currentUser.baseAppFolderId;
  }

  // **************************************************************************
  // Google Drive related: END
  // **************************************************************************

  void dispose() {
    _controller.close();
  }

/*List<String> _getDocsIds(QuerySnapshot snapshot) {
    List<String> ids;
    for (var doc in snapshot.docs) {
      ids.add(doc.id);
    }
    return ids;
  }*/

}

/// Creates json type from all document fields including the document id.
extension on DocumentSnapshot {
  Map<String, dynamic> get toJson {
    final jsonData = data();
    jsonData.addAll({"id": id});
    return jsonData;
  }
}
