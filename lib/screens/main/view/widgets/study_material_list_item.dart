/*
 * Created Date: 3/13/21 12:55 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

import '../../../../di/injection_container.dart';
import '../../../../generated/l10n.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/widget.dart';
import 'download_button.dart';

class StudyMaterialListItem extends StatefulWidget {
  const StudyMaterialListItem({
    Key key,
    @required this.materialEntity,
  }) : super(key: key);

  final StudyMaterial materialEntity;

  @override
  _StudyMaterialListItemState createState() => _StudyMaterialListItemState();
}

class _StudyMaterialListItemState extends State<StudyMaterialListItem> {
  StudyMaterial get materialEntity => widget.materialEntity;
  bool isDownloaded = false;

  bool get isExternalResource =>
      materialEntity.type == StudyMaterialType.externalResource;

  Future<String> get localPath async => await getFileDownloadDirectory(
        materialEntity.label,
        'pdf',
      );

  StudyMaterialDownloadController downloadController;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
      child: Container(
        constraints: BoxConstraints(
          minWidth: 100,
          minHeight: 50,
          maxHeight: 500,
          maxWidth: 500,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.all(8),
              constraints: BoxConstraints(maxWidth: 56, maxHeight: 56),
              child: AspectRatio(
                aspectRatio: 1,
                child: CachedNetworkImage(
                  imageUrl: materialEntity.iconUrl,
                  placeholder: (c, s) {
                    return Icon(
                      isExternalResource
                          ? Icons.link_outlined
                          : Icons.insert_drive_file_rounded,
                      color: Theme.of(context).primaryColor,
                      size: 48,
                    );
                  },
                  errorWidget: (context, _, __) {
                    return Icon(
                      isExternalResource
                          ? Icons.link_outlined
                          : Icons.insert_drive_file_rounded,
                      color: Theme.of(context).primaryColor,
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            materialEntity.label,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        isExternalResource || !isDownloaded
                            ? IconButton(
                                icon: Icon(
                                  Icons.open_with_rounded,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onPressed: () {
                                  if (isExternalResource) {
                                    launchInBrowser(
                                        context, materialEntity.materialUrl);
                                  } else {
                                    openMaterial();
                                  }
                                },
                              )
                            : PopupMenuButton(
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                      child: Text('Open With'),
                                      value: 0,
                                    ),
                                    PopupMenuItem(
                                      child: Text('Delete from device'),
                                      value: 1,
                                    ),
                                  ];
                                },
                                onSelected: (i) {
                                  if (i == 0) {
                                  } else {
                                    deleteMaterial(materialEntity);
                                  }
                                },
                              ),
                      ],
                    ),
                    Text(
                      materialEntity.courseName,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    Text(
                      getMaterialTypString(materialEntity.type, context),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            '${S.of(context).by} ${materialEntity.uploaderName}',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                        Builder(builder: (ctx) {
                          bool isStarred = ctx
                              .select((AuthenticationBloc ab) =>
                                  ab.state.user.starredMaterials)
                              .contains(materialEntity.id);
                          return IconButton(
                            icon: Icon(
                              isStarred
                                  ? Icons.star_rounded
                                  : Icons.star_border,
                              color: isStarred ? Colors.amber : null,
                            ),
                            onPressed: () {
                              if (isStarred) {
                                sl<UserRepository>().removeMaterialFromStarred(
                                    materialEntity.id);
                              } else {
                                sl<UserRepository>()
                                    .addMaterialToStarred(materialEntity.id);
                              }
                            },
                          );
                        }),
                        isExternalResource
                            ? IconButton(
                                icon: Icon(Icons.copy_rounded),
                                onPressed: () {
                                  copyToClipboard(materialEntity.materialUrl);
                                  OperationSuccessAlert(
                                    message: S.of(context).copied_to_clipboard,
                                  ).show(context);
                                },
                              )
                            : Builder(
                                builder: (ctx) {
                                  // TODO : Handle when material updates.
                                  List<StudyMaterialEntity> downloadedItems =
                                      ctx.select(
                                          (OfflineBloc ob) => ob.state.items);
                                  isDownloaded = downloadedItems == null
                                      ? false
                                      : downloadedItems.any((element) =>
                                          element.id == materialEntity.id);
                                  downloadController =
                                      StudyMaterialDownloadController(
                                    downloadStatus: isDownloaded
                                        ? DownloadStatus.downloaded
                                        : DownloadStatus.notDownloaded,
                                    materialUrl: materialEntity.materialUrl,
                                    onOpenDownload: () {
                                      openMaterial();
                                    },
                                    onDownloadDone: (path) {
                                      context
                                          .read<OfflineBloc>()
                                          .addDownloadedMaterial(materialEntity
                                              .copyWith(localPath: path));
                                    },
                                    fileName: materialEntity.label,
                                  );

                                  return SizedBox(
                                    width: 48.0,
                                    child: AnimatedBuilder(
                                      animation: downloadController,
                                      builder: (context, child) {
                                        return DownloadButton(
                                          status:
                                              downloadController.downloadStatus,
                                          downloadProgress:
                                              downloadController.progress,
                                          onDownload:
                                              downloadController.startDownload,
                                          onCancel:
                                              downloadController.stopDownload,
                                          onOpen:
                                              downloadController.openDownload,
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onPressed: () {
        openMaterial();
      },
    );
  }

  void openMaterial() async {
    if (isExternalResource) {
      launchInWebViewWithJavaScript(context, materialEntity.materialUrl);
    } else {
      if (isDownloaded) {
        print('open material : downloaded material');
        // TODO : maybe Implement pdf viewer.
        if (await Permission.storage.request().isGranted) {
          print('open material : permission granted');
          final path = await localPath;
          print(path);
          OpenFile.open(
            path,
          );
        }
      } else {
        if (downloadController != null) {
          downloadController.startDownload();
        }
      }
    }
  }
}

void deleteMaterial(StudyMaterial materialEntity) async {
  try {
    final path = await getFileDownloadDirectory(materialEntity.label, 'pdf');
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  } catch (e) {
    print(e);
  }
}

class StudyMaterialDownloadController extends DownloadController
    with ChangeNotifier {
  StudyMaterialDownloadController({
    DownloadStatus downloadStatus = DownloadStatus.notDownloaded,
    double progress = 0.0,
    @required VoidCallback onOpenDownload,
    @required String materialUrl,
    @required String fileName,
    Function(String) onDownloadDone,
  })  : _downloadStatus = downloadStatus,
        _progress = progress,
        _onOpenDownload = onOpenDownload,
        _onDownloadDone = onDownloadDone,
        assert(fileName != null),
        assert(materialUrl != null),
        _materialUrl = materialUrl,
        _fileName = fileName;

  DownloadStatus _downloadStatus;

  @override
  DownloadStatus get downloadStatus => _downloadStatus;

  double _progress;

  @override
  double get progress => _progress;

  final VoidCallback _onOpenDownload;
  final Function(String) _onDownloadDone;
  final String _materialUrl;
  final String _fileName;
  StreamSubscription<List<int>> _downloadSubscription;

  bool _isDownloading = false;

  @override
  void startDownload() async {
    if (downloadStatus == DownloadStatus.notDownloaded) {
      if (await Permission.storage.request().isGranted) {
        _doDownload();
      }
    }
  }

  @override
  void stopDownload() {
    if (_isDownloading) {
      _isDownloading = false;
      _downloadStatus = DownloadStatus.notDownloaded;
      _progress = 0.0;
      notifyListeners();
      if (_downloadSubscription != null) {
        _downloadSubscription.cancel();
      }
    }
  }

  @override
  void openDownload() {
    if (downloadStatus == DownloadStatus.downloaded) {
      _onOpenDownload();
    }
  }

  Future<void> _doDownload() async {
    _isDownloading = true;
    _downloadStatus = DownloadStatus.fetchingDownload;
    notifyListeners();

    final downloadUri = Uri.parse(await _getUrl(_materialUrl));

    print('Start download : download uri : ${downloadUri.toString()}');

    final request = Request('GET', downloadUri);
    final StreamedResponse response = await Client().send(request);
    if (response.statusCode != 200) {
      print('Start download : failure : status code : ${response.statusCode}');
      stopDownload();
      return;
    }

    double contentLength;

    if (response.contentLength != null) {
      contentLength = response.contentLength.toDouble();
    } else {
      contentLength = double.parse(
          response.headers['x-decompressed-content-length'] ?? '50000');
    }

    print('Start download : content length : $contentLength');

    // If the user chose to cancel the download, stop the simulation.
    if (!_isDownloading) {
      return;
    }

    // Shift to the downloading phase.
    _downloadStatus = DownloadStatus.downloading;
    _progress = 0;
    notifyListeners();

    List<int> bytes = [];

    final file = await _getFile('pdf');

    _downloadSubscription = response.stream.listen(
      (List<int> newBytes) {
        // update progress
        bytes.addAll(newBytes);
        final downloadedLength = bytes.length;
        if (contentLength == null) contentLength = 50000.0;
        final progress = downloadedLength / contentLength;
        if (progress > 1) _progress = null;
        _progress = progress;
        notifyListeners();
      },
      onDone: () async {
        // save file
        _progress = 0;
        _downloadStatus = DownloadStatus.downloaded;
        _isDownloading = false;
        await file.writeAsBytes(bytes);
        notifyListeners();
        print(file.path);
        _onDownloadDone(file.path);
      },
      onError: (e) {
        _downloadStatus = DownloadStatus.notDownloaded;
        _isDownloading = false;
        notifyListeners();
        print(e);
      },
      cancelOnError: true,
    );
  }

  Future<String> _getUrl(String materialUrl) async {
    final url = materialUrl.toLowerCase();
    print('materialUrl : $materialUrl');
    bool isOnGoogleDrive = url.contains('drive.google');
    if (isOnGoogleDrive) {
      final driveId = StudyMaterial.googleDriveIdFromUrl(materialUrl);
      print('materialDriveID : $driveId');
      final downloadLink =
          'https://drive.google.com/uc?export=download&id=$driveId';
      print('materialDownloadUrl : $downloadLink');
      return downloadLink;
    }
    return materialUrl;
  }

  Future<File> _getFile(String contentType) async {
    return File(
        path.join(await getFileDownloadDirectory(_fileName, contentType)));
  }
}

Future<String> getFileDownloadDirectory(
    String fileName, String contentType) async {
  if (Platform.isAndroid) {
    final directory = await DownloadsPathProvider.downloadsDirectory;
    return path.join(directory.path, '$fileName.$contentType');
  }
  // Right now i only target android platform,
  // implement other platforms functionalities if you want to.
  throw UnimplementedError();
}
