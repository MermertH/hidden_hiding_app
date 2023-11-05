import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hidden_hiding_app/controller/secret_vault_controller.dart';
import 'package:hidden_hiding_app/screens/SecretVault/services/file_picker.dart';

class DeleteAllDataDialog extends StatelessWidget {
  const DeleteAllDataDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    "Are you sure you want to delete all data? This cannot be undone.",
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
                  onPressed: () async =>
                      await FilePickerService.deleteFilesFormApp()
                          .then((_) => Get.find<SecretVaultController>()
                              .getStorageItems())
                          .then((_) => Get.back()),
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
