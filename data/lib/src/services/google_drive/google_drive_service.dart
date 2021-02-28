/*
 * Created Date: 2/26/21 9:52 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'dart:io' as io;

import 'package:googleapis/drive/v3.dart' as drive;
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;

import '../firestore/firestore_service.dart';
import '../google_auth/google_auth_service.dart';
import 'auth_client.dart';

class GoogleDriveService {
  static GoogleAuthService _googleAuthService;
  static FirestoreService _firestoreService;
  static GoogleDriveService _instance;
  static drive.DriveApi _drive;

  GoogleDriveService._internal();

  static Future<GoogleDriveService> get instance async {
    if (_instance == null) {
      _instance = GoogleDriveService._internal();
    }

    if (_googleAuthService == null) {
      _googleAuthService = GoogleAuthService.instance;
    }

    if (_firestoreService == null) {
      _firestoreService = FirestoreService.instance;
    }

    if (_drive == null) {
      var client = GoogleAuthClient(await _googleAuthService.authHeaders);
      _drive = drive.DriveApi(client);
    }

    return _instance;
  }

  Future<drive.File> uploadFileToDrive({
    @required String filePath,
  }) async {
    // TODO : Implement Setting shared property to true.
    String baseFolderId = await _firestoreService.userBaseFolderID;

    drive.File fileToUpload = drive.File();

    io.File file = io.File(filePath);

    String folderID = baseFolderId ?? await _createBaseFolder();

    fileToUpload.parents = [folderID];
    fileToUpload.name = path.basename(file.absolute.path);
    var response = await _drive.files
        .create(
      fileToUpload,
      uploadMedia: drive.Media(file.openRead(), file.lengthSync()),
    )
        .then((value) => null, onError: (e) {
      if (e is Exception) throw e;
    });
    print(response);
    return response;
  }

  Future<void> deleteFileFromDrive({
    @required String fileId,
  }) async {
    var response = await _drive.files.delete(fileId).then(
      (value) => null,
      onError: (e) {
        if (e is Exception) throw e;
      },
    );
    print(response);
  }

  Future<void> updateFile({
    String fileId,
    String name,
    String description,
  }) async {
    drive.File metadata = drive.File();
    if (name != null) metadata.name = name;
    if (description != null) metadata.description = description;
    var response = await _drive.files.update(metadata, fileId);
    return response;
  }

  // TODO Implement download file from drive.

  Future<String> _createBaseFolder() async {
    drive.File fileMetadata = drive.File();
    fileMetadata.name = "PassemApp";
    fileMetadata.mimeType = "application/vnd.google-apps.folder";

    var response = await _drive.files.create(fileMetadata);
    print("response file id: ${response.id}");
    await _firestoreService.writeUserBaseFolderID(response.id);
    return response.id;
  }
}
