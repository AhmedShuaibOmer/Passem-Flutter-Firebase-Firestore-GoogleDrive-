/*
 * Created Date: 3/13/21 12:55 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021.  A.S.Omer
 *
 */

import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:data/data.dart';
import 'package:device_info/device_info.dart';
import 'package:domain/domain.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:open_file/open_file.dart';
import 'package:passem/router/router.gr.dart';
import 'package:passem/screens/main/view/dialogs/dialogs.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../di/injection_container.dart';
import '../../../../generated/l10n.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/widget.dart';
import 'download_button.dart';

class StudyMaterialListItem extends StatefulWidget {
  const StudyMaterialListItem({
    Key key,
    @required this.materialEntity,
  })  : assert(materialEntity != null),
        super(key: key);

  final StudyMaterial materialEntity;

  @override
  _StudyMaterialListItemState createState() => _StudyMaterialListItemState();
}

class _StudyMaterialListItemState extends State<StudyMaterialListItem> {
  StudyMaterial get materialEntity => widget.materialEntity;

  Future<String> get localPath async => await getFileDownloadDirectory(
        materialEntity.label,
        'pdf',
      );

  bool get isExternalResource =>
      materialEntity.type == StudyMaterialType.externalResource;

  StudyMaterialDownloadController downloadController;

  @override
  void initState() {
    downloadController = StudyMaterialDownloadController(
      downloadStatus: DownloadStatus.notDownloaded,
      materialUrl: materialEntity.materialUrl,
      onOpenDownload: () {},
      onDownloadDone: (path) {
        context
            .read<OfflineBloc>()
            .addDownloadedMaterial(materialEntity.copyWith(localPath: path));
      },
      onError: () {
        OperationFailedAlert(
          context,
          message: S.of(context).download_failed,
        ).show(context);
      },
      fileName: materialEntity.label,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfflineBloc, BaseListState<StudyMaterialEntity>>(
        builder: (context, state) {
      bool isDownloaded = false;

      if (state.status == BaseListStatus.hasData) {
        final offlineItems = context.select((OfflineBloc ob) => ob.state.items);
        isDownloaded =
            offlineItems.any((element) => element.id == materialEntity.id);
      }

      if (isDownloaded) {
        downloadController.downloadStatus = DownloadStatus.downloaded;
      } else {
        downloadController.downloadStatus = DownloadStatus.notDownloaded;
      }

      return _buildListItem(context, isDownloaded);
    });
  }

  TextButton _buildListItem(BuildContext context, bool isDownloaded) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
      child: _buildContent(context, isDownloaded),
      onPressed: () {
        openMaterial(isDownloaded, context);
      },
    );
  }

  Container _buildContent(BuildContext context, bool isDownloaded) {
    return Container(
      constraints: BoxConstraints(
        minWidth: 100,
        minHeight: 50,
        maxHeight: 300,
        maxWidth: 500,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMaterialIcon(context),
          _buildContentBody(context, isDownloaded),
        ],
      ),
    );
  }

  Expanded _buildContentBody(BuildContext context, bool isDownloaded) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildLabel(context),
                _buildPopupMenu(isDownloaded),
              ],
            ),
            _buildCourseName(context),
            _buildMaterialType(context),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildUploadedBy(context),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildIsStarred(),
                    _buildCopyDownloadButton(),
                  ],
                ),
              ],
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  Widget _buildCopyDownloadButton() {
    return isExternalResource ? _buildCopyButton() : _buildDownloadButton();
  }

  Builder _buildDownloadButton() {
    return Builder(
      builder: (ctx) {
        return SizedBox(
          width: 48.0,
          child: AnimatedBuilder(
            animation: downloadController,
            builder: (context, child) {
              return DownloadButton(
                status: downloadController.downloadStatus,
                downloadProgress: downloadController.progress,
                onDownload: () {
                  downloadController.startDownload(context);
                },
                onCancel: downloadController.stopDownload,
                onOpen: downloadController.openDownload,
              );
            },
          ),
        );
      },
    );
  }

  IconButton _buildCopyButton() {
    return IconButton(
      icon: Icon(Icons.copy_rounded),
      onPressed: () async {
        await copyToClipboard(materialEntity.materialUrl);
        OperationSuccessAlert(
          message: S.of(context).copied_to_clipboard,
        ).show(context);
      },
    );
  }

  Builder _buildIsStarred() {
    return Builder(builder: (ctx) {
      bool isStarred = ctx
          .select((AuthenticationBloc ab) => ab.state.user.starredMaterials)
          .contains(materialEntity.id);
      return IconButton(
        icon: Icon(
          isStarred ? Icons.star_rounded : Icons.star_border,
          color: isStarred ? Colors.amber : null,
        ),
        onPressed: () {
          if (isStarred) {
            sl<UserRepository>().removeMaterialFromStarred(materialEntity.id);
          } else {
            sl<UserRepository>().addMaterialToStarred(materialEntity.id);
          }
        },
      );
    });
  }

  Expanded _buildUploadedBy(BuildContext context) {
    return Expanded(
      child: Text(
        '${S.of(context).by} ${materialEntity.uploaderName}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }

  Row _buildMaterialType(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            getMaterialTypString(materialEntity.type, context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
      ],
    );
  }

  Row _buildCourseName(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            materialEntity.courseName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      ],
    );
  }

  Builder _buildPopupMenu(bool isDownloaded) {
    return Builder(
      builder: (BuildContext context) {
        bool isAdmin = context.read<AuthenticationBloc>().state.user.isAdmin;
        List<PopupMenuItem> menuItems = [];
        menuItems.add(
          PopupMenuItem(
            child: ListTile(
                leading: Icon(
                  Icons.open_with_rounded,
                ),
                title: Text(S.of(context).open_with)),
            value: 0,
          ),
        );

        menuItems.add(
          PopupMenuItem(
            child: ListTile(
                leading: Icon(
                  Icons.library_books,
                ),
                title: Text(S.of(context).navigate_to_full_course)),
            value: 1,
          ),
        );
        if (isDownloaded) {
          menuItems.add(
            PopupMenuItem(
              child: ListTile(
                leading: Icon(
                  Icons.delete,
                ),
                title: Text(S.of(context).delete_from_device),
              ),
              value: 2,
            ),
          );
        }
        if (isAdmin) {
          menuItems.add(
            PopupMenuItem(
              child: ListTile(
                leading: Icon(
                  Icons.delete_forever_rounded,
                  color: Colors.red,
                ),
                title: Text(S.of(context).delete_forever),
              ),
              value: 3,
            ),
          );
        }
        return PopupMenuButton(
          itemBuilder: (context) {
            return menuItems;
          },
          onSelected: (i) async {
            if (i == 0) {
              if (isExternalResource) {
                if (await canLaunch(materialEntity.materialUrl)) {
                  launchInBrowser(context, materialEntity.materialUrl);
                } else {
                  UnsupportedOperationAlert(context).show(context);
                }
              } else {
                openMaterial(isDownloaded, context, isOpenWith: true);
              }
            } else if (i == 1) {
              ExtendedNavigator.root.push(
                Routes.courseScreen,
                arguments:
                    CourseScreenArguments(courseId: materialEntity.courseId),
              );
            } else if (i == 2) {
              final int result = await showPrimaryDialog<int>(
                context: context,
                dialog: ImportantActionDialog(
                  title: Text(S.of(context).delete_from_device),
                  content: Text(S.of(context).delete_from_device_content),
                  onCancel: (C) {
                    Navigator.of(C).pop();
                  },
                  onYes: (c) {
                    deleteMaterial(materialEntity).then((value) {
                      sl<StudyMaterialRepository>()
                          .removeDownloadedMaterial(materialEntity)
                          .then((value) {
                        value.fold((l) {
                          OperationFailedAlert(context,
                                  message: S.of(context).item_delete_failure)
                              .show(context);
                        }, (r) {
                          context
                              .read<OfflineBloc>()
                              .add(OfflineMaterialsChanged());
                          OperationSuccessAlert(
                                  message: S.of(context).item_delete_success)
                              .show(context);
                        });
                      });
                    });

                    Navigator.of(c).pop(0);
                  },
                ),
              );
            } else if (i == 3) {
              final int result = await showPrimaryDialog<int>(
                context: context,
                dialog: ImportantActionDialog(
                    title: Text(S.of(context).delete_forever),
                    content: Text(S.of(context).delete_forever_content),
                    onCancel: (C) {
                      Navigator.of(C).pop();
                    },
                    onYes: (c) {
                      sl<StudyMaterialRepository>()
                          .deleteMaterial(
                              materialEntity.id, materialEntity.uploaderId)
                          .then((value) {
                        value.fold((l) {
                          OperationFailedAlert(context,
                                  message: S.of(context).item_delete_failure)
                              .show(context);
                        }, (r) {
                          context
                              .read<OfflineBloc>()
                              .add(OfflineMaterialsChanged());
                          OperationSuccessAlert(
                                  message: S.of(context).item_delete_success)
                              .show(context);
                        });
                      });
                      Navigator.of(c).pop();
                    }),
              );
            }
          },
        );
      },
    );
  }

  Expanded _buildLabel(BuildContext context) {
    return Expanded(
      child: Text(
        materialEntity.label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Container _buildMaterialIcon(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      constraints: BoxConstraints(maxWidth: 56, maxHeight: 56),
      child: AspectRatio(
        aspectRatio: 1,
        child: Icon(
          isExternalResource
              ? Icons.link_outlined
              : Icons.insert_drive_file_rounded,
          color: Theme.of(context).primaryColor,
          size: 48,
        ),
      ),
    );
  }

  void openMaterial(bool isDownloaded, context,
      {bool isOpenWith = false}) async {
    if (isExternalResource) {
      launchInWebViewWithJavaScript(context, materialEntity.materialUrl);
    } else {
      if (isDownloaded) {
        print('open material : downloaded material');
        if (await _requestPermission(Permission.storage, context)) {
          print('open material : permission granted');
          final path = await localPath;
          print(path);
          final file = File(path);
          if (await file.exists()) {
            if (isOpenWith) {
              OpenFile.open(
                path,
              );
            } else {
              ExtendedNavigator.root.push(
                Routes.pdfViewerScreen,
                arguments: PdfViewerScreenArguments(
                  fileName: materialEntity.label,
                  filepath: path,
                ),
              );
            }
          } else {
            OperationFailedAlert(
              context,
              message: S.of(context).file_not_found,
            ).show(context);
          }
        } else {}
      } else {
        if (downloadController != null) {
          downloadController.startDownload(context);
        }
      }
    }
  }
}

Future<void> deleteMaterial(StudyMaterial materialEntity) async {
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
    Function() onError,
  })  : _downloadStatus = downloadStatus,
        _progress = progress,
        _onOpenDownload = onOpenDownload,
        _onDownloadDone = onDownloadDone,
        _onError = onError,
        assert(fileName != null),
        assert(materialUrl != null),
        _materialUrl = materialUrl,
        _fileName = fileName;

  DownloadStatus _downloadStatus;

  @override
  DownloadStatus get downloadStatus => _downloadStatus;

  set downloadStatus(DownloadStatus status) {
    _downloadStatus = status;
  }

  double _progress;

  @override
  double get progress => _progress;

  final VoidCallback _onOpenDownload;
  final Function(String) _onDownloadDone;
  final Function() _onError;
  final String _materialUrl;
  final String _fileName;
  StreamSubscription<List<int>> _downloadSubscription;

  bool _isDownloading = false;

  @override
  void startDownload(BuildContext context) async {
    if (downloadStatus == DownloadStatus.notDownloaded) {
      if (await _requestPermission(Permission.storage, context)) {
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

    if (!await sl<NetworkInfo>().isConnected) {
      stopDownload();
      _onError();
      return;
    }

    final downloadUri = Uri.parse(await _getUrl(_materialUrl));

    print('Start download : download uri : ${downloadUri.toString()}');

    final request = Request('GET', downloadUri);
    final StreamedResponse response = await Client().send(request);
    if (response.statusCode != 200) {
      print('Start download : failure : status code : ${response.statusCode}');
      stopDownload();
      _onError();
      return;
    }

    File file;

    try {
      file = await _getFile('pdf');
    } catch (_) {
      stopDownload();
      _onError();
      return;
    }

    double contentLength = 0;

    if (response.contentLength != null) {
      contentLength = response.contentLength.toDouble();
    } else {
      contentLength = double.parse(
          response.headers['x-decompressed-content-length'] ?? '5000000');
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

    _downloadSubscription = response.stream.listen(
      (List<int> newBytes) {
        // update progress
        bytes.addAll(newBytes);
        final downloadedLength = bytes.length;
        if (contentLength == null) contentLength = 5000000.0;
        final progress = downloadedLength / contentLength;
        print(progress);
        if (progress >= 1.0)
          _progress = 777777777.777777777;
        else
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
        _onError();
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
    return File(await getFileDownloadDirectory(_fileName, contentType));
  }
}

Future<String> getFileDownloadDirectory(
    String fileName, String contentType) async {
  Directory directory;
  try {
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt < 30) {
        String newPath = "";
        print(directory);
        List<String> paths = directory.path.split("/");
        for (int x = 1; x < paths.length; x++) {
          String folder = paths[x];
          if (folder != "Android") {
            newPath += "/" + folder;
          } else {
            break;
          }
        }
        newPath = newPath + "/PassemApp";
        directory = Directory(newPath);
      }
    } else {
      /*if (await _requestPermission(Permission.photos)) {
        directory = await getTemporaryDirectory();
      } else {
        // TODO : implement Permission rejected.
      }*/
    }

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    return path.join(directory.path, '$fileName.$contentType');
  } catch (e) {
    print(e);
    throw e;
  }
}

Future<bool> _requestPermission(
    Permission permission, BuildContext context) async {
  if (await permission.isGranted) {
    return true;
  } else {
    var result = await permission.request();
    if (result == PermissionStatus.granted) {
      return true;
    } else if (result == PermissionStatus.denied) {
      Flushbar(
        message: S.of(context).storage_permission_denied,
        icon: Icon(
          Icons.error_outline_rounded,
          color: Colors.orangeAccent,
          size: 28,
        ),
        borderRadius: 8,
        margin: const EdgeInsets.all(8),
        duration: const Duration(seconds: 6),
      ).show(context);
      return false;
    } else if (result == PermissionStatus.permanentlyDenied) {
      Flushbar(
        message: S.of(context).storage_permission_permanently_denied,
        icon: Icon(
          Icons.error_outline_rounded,
          color: Colors.orangeAccent,
          size: 28,
        ),
        borderRadius: 8,
        margin: const EdgeInsets.all(8),
        duration: const Duration(seconds: 6),
        mainButton: TextButton(
          child: Text(S.of(context).open_settings),
          onPressed: () async {
            final result = await openAppSettings();
            if (result == false) {
              UnsupportedOperationAlert(context).show(context);
            }
          },
        ),
      ).show(context);
      return false;
    }
  }
  return false;
}
