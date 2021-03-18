/*
 * Created Date: 1/26/21 6:19 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021 SafePass
 *
 */

import 'dart:convert';

import 'package:domain/domain.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../study_material/study_material.dart';
import 'shared_pref_keys.dart';

class SharedPreferencesService {
  static SharedPreferencesService _instance;
  static SharedPreferences _preferences;

  SharedPreferencesService._internal();

  static Future<SharedPreferencesService> get instance async {
    if (_instance == null) {
      _instance = SharedPreferencesService._internal();
    }

    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }

    return _instance;
  }

  /// saving the current user preferred theme mode.
  /// use [PrefsConstants.SYSTEM_THEME_MODE] => system settings mode.
  /// use [PrefsConstants.LIGHT_THEME_MODE] => light theme mode.
  /// use [PrefsConstants.DARK_THEME_MODE] => dark theme mode.
  Future<bool> setThemeModeInfo(int themeMode) async =>
      await _preferences.setInt(SharedPrefKeys.THEME_MODE, themeMode);

  int get themeModeInfo => _preferences.getInt(SharedPrefKeys.THEME_MODE);

  Future<bool> addDownloadedMaterial(StudyMaterialEntity studyMaterial) async {
    List<String> materials = _preferences.getStringList(
      SharedPrefKeys.DOWNLOADED_MATERIALS,
    );
    String material = jsonEncode(StudyMaterial.jsonFrom(studyMaterial)
      ..addAll({"id": studyMaterial.id}));
    if (materials != null) {
      materials.add(material);
    } else {
      materials = [material];
    }
    return _preferences.setStringList(
      SharedPrefKeys.DOWNLOADED_MATERIALS,
      materials,
    );
  }

  Future<bool> removeDownloadedMaterial(
      StudyMaterialEntity studyMaterial) async {
    List<String> materials = _preferences.getStringList(
      SharedPrefKeys.DOWNLOADED_MATERIALS,
    );
    String material = jsonEncode(StudyMaterial.jsonFrom(studyMaterial)
      ..addAll({"id": studyMaterial.id}));
    bool success = false;
    if (materials != null) {
      success = materials.remove(material);
    } else {
      return false;
    }

    if (success) {
      return _preferences.setStringList(
        SharedPrefKeys.DOWNLOADED_MATERIALS,
        materials,
      );
    } else {
      return false;
    }
  }

  List<StudyMaterial> get downloadedMaterials {
    List<StudyMaterial> materials = [];
    List<String> jsonMaterials =
        _preferences.getStringList(SharedPrefKeys.DOWNLOADED_MATERIALS);
    for (var jsonMaterial in jsonMaterials) {
      Map<String, dynamic> material = jsonDecode(jsonMaterial);
      materials.add(StudyMaterial.fromJson(material));
    }
    return materials;
  }
}
