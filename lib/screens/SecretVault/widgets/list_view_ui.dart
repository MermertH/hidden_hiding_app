import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hidden_hiding_app/screens/SecretVault/services/file_picker.dart';
import 'package:hidden_hiding_app/screens/SecretVault/widgets/dialogs/edit_media_file_name_dialog.dart';
import 'package:hidden_hiding_app/screens/SecretVault/widgets/video_player_screen.dart';

import '../../../controller/secret_vault_controller.dart';
import 'dialogs/expand_media_file_dialog.dart';
import 'dialogs/export_delete_media_dialog.dart';

class ListViewUI extends StatelessWidget {
  const ListViewUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SecretVaultController _vaultCont = Get.find();
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Obx(
          () => Scrollbar(
            controller: _vaultCont.filterController,
            thumbVisibility: _vaultCont.getIsFilterMode.value,
            thickness: 3,
            child: ListView.builder(
              controller: _vaultCont.listController,
              shrinkWrap: true,
              itemCount: _vaultCont.items.length,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  onTap: () async {
                    if (_vaultCont.items[index].key.statSync().type ==
                        FileSystemEntityType.directory) {
                      _vaultCont.setCurrentPath =
                          _vaultCont.items[index].key.path;
                      _vaultCont.setIsDefaultPath = _vaultCont.getCurrentPath ==
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
                  onLongPress: () {
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
                  leading: _vaultCont.items[index].key.statSync().type !=
                          FileSystemEntityType.directory
                      ? _vaultCont.getFileInfo(
                                  _vaultCont.items[index].value, "extension") !=
                              "mp4"
                          ? ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 60,
                                maxHeight: 60,
                              ),
                              child: AspectRatio(
                                aspectRatio: 4 / 3,
                                child: Image.file(
                                  File(_vaultCont.items[index].key.path),
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                ),
                              ),
                            )
                          : ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 60,
                                maxHeight: 60,
                              ),
                              child: AspectRatio(
                                aspectRatio: 4 / 3,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: AspectRatio(
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
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.green[700],
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    const Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Icon(
                                        Icons.video_collection,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                      : ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 60,
                            maxHeight: 60,
                          ),
                          child: const AspectRatio(
                              aspectRatio: 4 / 3,
                              child: Center(
                                child: Icon(
                                  Icons.folder,
                                  size: 35,
                                ),
                              )),
                        ),
                  title: Text(
                    _vaultCont.getFileInfo(
                        _vaultCont.items[index].value, "name"),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  subtitle: _vaultCont.items[index].key.statSync().type ==
                          FileSystemEntityType.file
                      ? Text(_vaultCont.getFileSizeFormat(
                          bytes: int.parse(_vaultCont.getFileInfo(
                              _vaultCont.items[index].value, "size")),
                          decimals: 2))
                      : null,
                  trailing: GestureDetector(
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
