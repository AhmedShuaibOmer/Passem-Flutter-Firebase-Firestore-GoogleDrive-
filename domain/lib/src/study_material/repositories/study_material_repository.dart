/*
 * Created Date: 2/26/21 11:53 AM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'package:dartz/dartz.dart';

import '../../../domain.dart';
import '../entities/study_material_entity.dart';

abstract class StudyMaterialRepository {
  Stream<List<StudyMaterialEntity>> get recentlyAdded;

  Future<Either<Failure, List<StudyMaterialEntity>>> getMaterials(
      List<String> materialsIds);

  Stream<Either<Failure, List<StudyMaterialEntity>>> searchMaterials(
    String query,
  );

  Stream<List<StudyMaterialEntity>> materialsForCourse(
    String courseId,
    StudyMaterialType materialType,
  );

  Future<Either<Failure, void>> addMaterial({
    String filePath,
  });

  Future<Either<Failure, void>> deleteMaterial(
    String materialId,
    String uploaderId,
    bool ownedByMe,
  );

  Future<Either<Failure, void>> updateMaterial({
    String materialId,
    String label,
    String description,
    StudyMaterialType type,
  });
}
