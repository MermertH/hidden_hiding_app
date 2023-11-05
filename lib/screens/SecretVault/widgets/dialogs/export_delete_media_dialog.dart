import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hidden_hiding_app/controller/secret_vault_controller.dart';
import 'package:hidden_hiding_app/preferences.dart';
import '../../services/file_picker.dart';
import 'delete_selected_file_dialog.dart';

class ExportOrDeleteMediaDialog extends StatelessWidget {
  final int index;
  const ExportOrDeleteMediaDialog({Key? key, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SecretVaultController _vaultCont = Get.find();
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Colors.grey.shade900,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Select a directory to export your file or delete it",
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
            child: Text(
              "Selected file:\n${_vaultCont.getFileInfo(_vaultCont.items[index].value, "name")}",
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (_vaultCont.items[index].key.statSync().type ==
                    FileSystemEntityType.file)
                  ElevatedButton(
                    onPressed: () async {
                      if (!Preferences().getIsExportPathSelected) {
                        var selectedPath =
                            await _vaultCont.getDirectoryToExportMediaFile();
                        Preferences().setExportPath = selectedPath;
                        debugPrint(
                            "set export path worked, selected path: $selectedPath");
                      }
                      if (Preferences().getExportPath != "none") {
                        Preferences().setIsExportPathSelected = true;
                        await FilePickerService.moveFile(
                          File(_vaultCont.items[index].key.path),
                          (await FilePickerService.joinFilePaths(
                                  Preferences().getExportPath,
                                  _vaultCont.items[index].key.path
                                      .split("/")
                                      .last))
                              .path,
                        ).then((value) => _vaultCont.getStorageItems());
                        debugPrint("move the file to selected path worked");
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Export location is not selected!'),
                        ));
                      }
                      Navigator.of(context).pop(true);
                    },
                    child: const Text("Export"),
                  ),
                ElevatedButton(
                  onPressed: () {
                    Get.dialog(
                      DeleteSelectedFileDialog(
                        index: index,
                        path: _vaultCont.items[index].key.path,
                      ),
                    );
                  },
                  child: const Text("Delete"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("Cancel"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
