import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hidden_hiding_app/screens/SecretVault/widgets/dialogs/expand_media_file_dialog.dart';
import 'package:hidden_hiding_app/screens/SecretVault/widgets/video_player_screen.dart';
import '../../../controller/secret_vault_controller.dart';
import '../services/file_picker.dart';
import 'dialogs/edit_media_file_name_dialog.dart';
import 'dialogs/export_delete_media_dialog.dart';

class FileViewUI extends StatelessWidget {
  const FileViewUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SecretVaultController _vaultCont = Get.find();
    return Expanded(
      child: Obx(
        () => Scrollbar(
          controller: _vaultCont.fileController,
          thumbVisibility: _vaultCont.getIsFilterMode.value,
          thickness: 3,
          child: GridView.builder(
            controller: _vaultCont.fileController,
            clipBehavior: Clip.hardEdge,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 4 / 3,
            ),
            itemCount: _vaultCont.items.length,
            itemBuilder: (context, index) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[700]!,
                      width: 0,
                    ),
                  ),
                  // media element
                  child: GestureDetector(
                    onTap: () async {
                      if (_vaultCont.items[index].key.statSync().type ==
                          FileSystemEntityType.directory) {
                        _vaultCont.setCurrentPath =
                            _vaultCont.items[index].key.path;
                        _vaultCont.setIsDefaultPath =
                            _vaultCont.getCurrentPath ==
                                (await FilePickerService.createNFolder()).path;
                        await _vaultCont.getStorageItems();
                      } else if (_vaultCont.getFileInfo(
                              _vaultCont.items[index].value, "extension") ==
                          "mp4") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoPlayerScreen(
                                mediaFile: _vaultCont.items[index]),
                          ),
                        );
                      } else {
                        Get.dialog(ExpandMediaFileDialog(index: index));
                      }
                    },
                    onLongPress: () async {
                      // if (_vaultCont.items[index].key.statSync().type ==
                      //     FileSystemEntityType.directory) {
                      //   Get.dialog(
                      //     ExportOrDeleteMediaDialog(
                      //       index: index,
                      //     ),
                      //   );
                      // }
                      Get.dialog(
                        ExportOrDeleteMediaDialog(
                          index: index,
                        ),
                      );
                    },
                    child: _vaultCont.items[index].key.statSync().type !=
                            FileSystemEntityType.directory
                        ? _vaultCont.getFileInfo(_vaultCont.items[index].value,
                                    "extension") !=
                                "mp4"
                            ? Stack(
                                alignment: AlignmentDirectional.bottomCenter,
                                children: [
                                  AspectRatio(
                                    aspectRatio: 4 / 3,
                                    child: Image.file(
                                      File(_vaultCont.items[index].key.path),
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                  Container(
                                    color: Colors.black.withOpacity(0.4),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          flex: 8,
                                          child: Text(
                                            _vaultCont.getFileInfo(
                                                _vaultCont.items[index].value,
                                                "name"),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ),
                                        Flexible(
                                          flex: 2,
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.dialog(
                                                EditMediaFileNameDialog(
                                                  index: index,
                                                ),
                                              );
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.all(2),
                                              child: Icon(Icons.edit),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Stack(
                                alignment: AlignmentDirectional.bottomCenter,
                                children: [
                                  AspectRatio(
                                    aspectRatio: 4 / 3,
                                    child: FutureBuilder<Uint8List>(
                                      future: _vaultCont.videoThumbnail(
                                          _vaultCont.items[index].key.path),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                                ConnectionState.done &&
                                            snapshot.hasData) {
                                          return Image.memory(
                                            snapshot.data!,
                                            fit: BoxFit.cover,
                                          );
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.green[700],
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  const Positioned(
                                    right: 2,
                                    top: 2,
                                    child: Icon(Icons.video_collection),
                                  ),
                                  Container(
                                    color: Colors.black.withOpacity(0.4),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          flex: 8,
                                          child: Text(
                                            _vaultCont.getFileInfo(
                                                _vaultCont.items[index].value,
                                                "name"),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ),
                                        Flexible(
                                          flex: 2,
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.dialog(
                                                EditMediaFileNameDialog(
                                                  index: index,
                                                ),
                                              );
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.all(2),
                                              child: Icon(Icons.edit),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                        : Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            children: [
                              AspectRatio(
                                aspectRatio: 4 / 3,
                                child: Container(
                                  color: Colors.transparent,
                                  child: const Icon(
                                    Icons.folder,
                                    size: 50,
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.black.withOpacity(0.4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 8,
                                      child: Text(
                                        _vaultCont.getFileInfo(
                                            _vaultCont.items[index].value,
                                            "name"),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.dialog(
                                            EditMediaFileNameDialog(
                                              index: index,
                                            ),
                                          );
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(2),
                                          child: Icon(Icons.edit),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                // media name and edit
              ],
            ),
          ),
        ),
      ),
    );
  }
}
