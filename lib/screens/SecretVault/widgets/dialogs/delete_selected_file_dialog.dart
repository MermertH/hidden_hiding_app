import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hidden_hiding_app/controller/secret_vault_controller.dart';
import '../../services/file_picker.dart';

class DeleteSelectedFileDialog extends StatelessWidget {
  final String path;
  final int index;
  const DeleteSelectedFileDialog({
    Key? key,
    required this.path,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SecretVaultController _vaultCont = Get.find();
    return Dialog(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Colors.grey.shade900,
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Are you sure you want to delete this file? This cannot be undone.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await FilePickerService.deleteMedia(
                            _vaultCont.items[index].key.statSync().type ==
                                    FileSystemEntityType.file
                                ? File(path)
                                : Directory(path))
                        .then(
                      (_) => _vaultCont.getStorageItems(),
                    );
                    Get.back();
                    if (Get.isOverlaysOpen) Get.back();
                  },
                  child: Text("ACCEPT",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.red)),
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
