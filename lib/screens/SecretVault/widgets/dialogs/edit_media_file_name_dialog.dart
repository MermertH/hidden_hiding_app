import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/secret_vault_controller.dart';
import '../../services/file_picker.dart';

class EditMediaFileNameDialog extends StatelessWidget {
  final int index;
  const EditMediaFileNameDialog({Key? key, required this.index})
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Edit File Name",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 12,
            ),
            child: TextField(
              textAlign: TextAlign.center,
              controller: _vaultCont.textKeyController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: _vaultCont.getFileInfo(
                    _vaultCont.items[index].value, "name"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _vaultCont.textKeyController.clear();
                    Get.back();
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_vaultCont.textKeyController.text.isNotEmpty) {
                      await FilePickerService.renameFileOrFolder(
                          _vaultCont.items[index].key,
                          _vaultCont.items[index].key.statSync().type ==
                                  FileSystemEntityType.file
                              ? "${_vaultCont.textKeyController.text}.${_vaultCont.getFileInfo(_vaultCont.items[index].value, "extension")}"
                              : _vaultCont.textKeyController.text);
                    }
                    _vaultCont.textKeyController.clear();
                    await _vaultCont.getStorageItems().then((_) => Get.back());
                  },
                  child: const Text("Submit"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
