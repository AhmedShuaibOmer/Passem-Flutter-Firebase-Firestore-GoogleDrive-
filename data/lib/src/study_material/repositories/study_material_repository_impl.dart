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
  final GoogleDriveService _googleDriveService;
  final NetworkInfo _networkInfo;

  StudyMaterialRepositoryImpl({
    @required FirestoreService firestoreService,
    @required GoogleDriveService googleDriveService,
    @required NetworkInfo networkInfo,
  })  : assert(firestoreService != null),
        assert(googleDriveService != null),
        assert(networkInfo != null),
        this._firestoreService = firestoreService,
        this._googleDriveService = googleDriveService,
        this._networkInfo = networkInfo;

  @override
  Future<Either<Failure, void>> addMaterial({
    String filePath,
    String courseId,
    String courseName,
    StudyMaterialType type,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final User currentUser = await _firestoreService.currentUser;
        await _googleDriveService
            .uploadFileToDrive(filePath: filePath)
            .then((value) async {
          final studyMaterial = StudyMaterial(
            id: value.id,
            label: value.name,
            description: value.description,
            thumbnailUrl: value.thumbnailLink,
            materialUrl: value.webContentLink,
            fileSize: value.size,
            iconUrl: value.iconLink,
            courseId: courseId,
            courseName: courseName,
            created: value.createdTime.millisecondsSinceEpoch,
            type: type,
            uploaderId: currentUser.id,
            uploaderName: currentUser.name,
          );
          await _firestoreService.addStudyMaterial(studyMaterial);
        });
        return Right(() {});
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
    bool ownedByMe,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        if (ownedByMe) {
          await _googleDriveService.deleteFileFromDrive(fileId: materialId);
        }
        await _firestoreService.deleteStudyMaterial(
            materialId: materialId, uploaderId: uploaderId);
        return Right(() {});
      } catch (e) {
        return Left(DeleteMaterialFailure());
      }
    } else {
      return Left(NoConnectionFailure());
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
        await _googleDriveService.updateFile(
          fileId: materialId,
          name: label,
          description: description,
        );
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
  ) =>
      _firestoreService.materialsForCourse(
        courseId: courseId,
        materialType: materialType,
      );

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
}
