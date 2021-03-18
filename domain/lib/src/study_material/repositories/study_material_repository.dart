/*
 * Created Date: 2/26/21 11:53 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../domain.dart';
import '../entities/study_material_entity.dart';

abstract class StudyMaterialRepository {
  Stream<List<StudyMaterialEntity>> get recentlyAdded;

  Future<Either<Failure, List<StudyMaterialEntity>>> getMaterials(
      List<String> materialsIds);

  Stream<List<StudyMaterialEntity>> materialsForCourse(
    String courseId,
    StudyMaterialType materialType,
  );

  Future<Either<Failure, String>> addMaterial({
    @required String name,
    @required String description,
    @required String materialUrl,
    @required String courseId,
    @required String courseName,
    @required StudyMaterialType type,
  });

  Future<Either<Failure, String>> addExternalMaterial({
    String url,
    String description,
    String title,
    String courseId,
    String courseName,
  });

  Future<Either<Failure, void>> deleteMaterial(
    String materialId,
    String uploaderId,
  );

  Future<Either<Failure, void>> updateMaterial({
    String materialId,
    String label,
    String description,
    StudyMaterialType type,
  });

  Future<Either<Failure, List<StudyMaterialEntity>>> getDownloadedMaterials();

  Future<Either<Failure, bool>> addDownloadedMaterial(
      StudyMaterialEntity materialEntity);

  Future<Either<Failure, bool>> removeDownloadedMaterial(
      StudyMaterialEntity materialEntity);
}
