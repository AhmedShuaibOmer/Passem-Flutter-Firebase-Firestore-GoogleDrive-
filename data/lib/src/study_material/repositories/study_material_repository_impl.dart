/*
 * Created Date: 2/26/21 9:36 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:dartz/dartz.dart';
import 'package:data/src/study_material/models/study_material_model.dart';
import 'package:domain/domain.dart';
import 'package:meta/meta.dart';

import '../../../data.dart';

class StudyMaterialRepositoryImpl extends StudyMaterialRepository {
  final FirestoreService _firestoreService;
  final SharedPreferencesService _preferencesService;
  final NetworkInfo _networkInfo;

  StudyMaterialRepositoryImpl({
    @required SharedPreferencesService sharedPreferencesService,
    @required FirestoreService firestoreService,
    @required NetworkInfo networkInfo,
  })  : assert(firestoreService != null),
        assert(sharedPreferencesService != null),
        assert(networkInfo != null),
        this._firestoreService = firestoreService,
        this._preferencesService = sharedPreferencesService,
        this._networkInfo = networkInfo;

  @override
  Future<Either<Failure, String>> addMaterial({
    String name,
    String description,
    String materialUrl,
    String courseId,
    String courseName,
    StudyMaterialType type,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        String materialId = await _firestoreService.addStudyMaterial(
          name: name,
          description: description,
          materialUrl: materialUrl,
          courseId: courseId,
          courseName: courseName,
          type: type,
        );
        return Right(materialId);
      } catch (e) {
        print(e);
        return Left(UploadMaterialFailure());
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteMaterial(
    String materialId,
    String uploaderId,
  ) async {
    try {
      await _firestoreService.deleteStudyMaterial(
          materialId: materialId, uploaderId: uploaderId);
      return Right(() {});
    } catch (e) {
      return Left(DeleteMaterialFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateMaterial({
    String materialId,
    String label,
    String description,
    StudyMaterialType type,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        await _firestoreService.updateMaterial(
          materialId: materialId,
          name: label,
          description: description,
        );
        return Right(() {});
      } catch (e) {
        return Left(MaterialUpdateFailure());
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }

  @override
  Stream<List<StudyMaterialEntity>> materialsForCourse(
    String courseId,
    StudyMaterialType materialType,
  ) {
    // TODO: implement searchMaterials
    throw UnimplementedError();
  }

  @override
  Stream<List<StudyMaterialEntity>> get recentlyAdded =>
      _firestoreService.recentlyAddedMaterials();

  @override
  Stream<Either<Failure, List<StudyMaterialEntity>>> searchMaterials(
      String query) {
    // TODO: implement searchMaterials
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<StudyMaterialEntity>>> getMaterials(
    List<String> materialsIds,
  ) async {
    try {
      List<StudyMaterial> materials;
      await _firestoreService
          .getMaterials(materialsIds)
          .then((value) => materials = value);
      return Right(materials);
    } catch (e) {
      if (await _networkInfo.isConnected) return Left(NoConnectionFailure());
      return Left(StudyMaterialsFetchingFailure());
    }
  }

  @override
  Future<Either<Failure, String>> addExternalMaterial({
    String url,
    String description,
    String title,
    String courseName,
    String courseId,
  }) async {
    try {
      String materialId = await _firestoreService.addExternalStudyMaterial(
        courseId: courseId,
        name: title,
        description: description,
        materialUrl: url,
        courseName: courseName,
      );
      return Right(materialId);
    } catch (e) {
      print(e);
      return Left(AddExternalMaterialFailure());
    }
  }

  @override
  Future<Either<Failure, List<StudyMaterialEntity>>>
      getDownloadedMaterials() async {
    try {
      List<StudyMaterial> materials = _preferencesService.downloadedMaterials;
      return Right(materials);
    } catch (e) {
      print(e);
      return Left(StudyMaterialsFetchingFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> addDownloadedMaterial(
      StudyMaterialEntity materialEntity) async {
    try {
      bool result =
          await _preferencesService.addDownloadedMaterial(materialEntity);
      return Right(result);
    } catch (e) {
      print(e);
      return Left(StudyMaterialsCachingFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> removeDownloadedMaterial(
      StudyMaterialEntity materialEntity) async {
    try {
      bool result =
          await _preferencesService.removeDownloadedMaterial(materialEntity);
      return Right(result);
    } catch (e) {
      print(e);
      return Left(StudyMaterialsUnCachingFailure());
    }
  }
}
