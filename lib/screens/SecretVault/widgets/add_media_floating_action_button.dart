import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hidden_hiding_app/controller/secret_vault_controller.dart';

import '../services/file_picker.dart';
import 'dialogs/add_new_folder_dialog.dart';

class AddMediaFloatingActionButton extends StatelessWidget {
  const AddMediaFloatingActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SecretVaultController _vaultCont = Get.find();
    return Obx(
      () => Stack(
        children: [
          AnimatedPositioned(
            onEnd: () {
              if (_vaultCont.getIsExpanded.value) {
                _vaultCont.setIsLabelVisible = true;
              }
            },
            bottom: _vaultCont.getIsExpanded.value ? 160 : 0,
            duration: const Duration(milliseconds: 150),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                _vaultCont.getIsLabelVisible.value
                    ? Positioned(
                        left: -130,
                        bottom: 10,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade900,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Create Folder"),
                          ),
                        ),
                      )
                    : const SizedBox(),
                FloatingActionButton(
                  backgroundColor: Colors.greenAccent[700],
                  heroTag: "createFolderButton",
                  onPressed: () {
                    if (_vaultCont.getIsFileMoving.value) {
                      return;
                    }
                    Get.dialog(const AddNewFolderDialog());
                  },
                  child: const Icon(
                    Icons.create_new_folder_sharp,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          AnimatedPositioned(
            bottom: _vaultCont.getIsExpanded.value ? 80 : 0,
            duration: const Duration(milliseconds: 150),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                _vaultCont.getIsLabelVisible.value
                    ? Positioned(
                        left: -110,
                        bottom: 10,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade900,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Add Media"),
                          ),
                        ),
                      )
                    : const SizedBox(),
                FloatingActionButton(
                  backgroundColor: Colors.yellow,
                  heroTag: "addButton",
                  onPressed: () async {
                    if (_vaultCont.getIsFileMoving.value) {
                      return;
                    }
                    await FilePickerService.getFilesWithFilter().then(
                      (_) async => await _vaultCont.getStorageItems(),
                    );
                  },
                  child: const Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 160,
              ),
              FloatingActionButton(
                backgroundColor: !_vaultCont.getIsExpanded.value
                    ? Colors.greenAccent[700]!
                    : Colors.red,
                heroTag: "interactionButton",
                child: Icon(
                  !_vaultCont.getIsExpanded.value ? Icons.add : Icons.close,
                  color: Colors.black,
                  size: 26,
                ),
                onPressed: () {
                  if (_vaultCont.getIsFileMoving.value) {
                    return;
                  }
                  _vaultCont.setIsExpanded = !_vaultCont.getIsExpanded.value;
                  _vaultCont.getIsLabelVisible.value = false;
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
