import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hidden_hiding_app/controller/secret_vault_controller.dart';
import 'package:hidden_hiding_app/screens/SecretVault/services/file_picker.dart';

class AddNewFolderDialog extends StatelessWidget {
  const AddNewFolderDialog({Key? key}) : super(key: key);

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
                    "Write Folder Name:",
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
              controller: _vaultCont.folderNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
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
                    _vaultCont.folderNameController.clear();
                    Get.back();
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    bool isValid = false;
                    if (_vaultCont.folderNameController.text.isNotEmpty) {
                      await FilePickerService.createFolderInGivenPath(
                        _vaultCont.folderNameController.text,
                        _vaultCont.getCurrentPath,
                        context,
                      );
                      isValid = true;
                    }
                    _vaultCont.folderNameController.clear();
                    if (isValid) await _vaultCont.getStorageItems();
                    Get.back();
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
