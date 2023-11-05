import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hidden_hiding_app/controller/secret_vault_controller.dart';
import 'package:hidden_hiding_app/global.dart';
import 'package:hidden_hiding_app/screens/SecretVault/services/file_picker.dart';
import 'package:hidden_hiding_app/screens/SecretVault/widgets/add_media_floating_action_button.dart';
import 'package:hidden_hiding_app/screens/SecretVault/widgets/dialogs/file_moving_dialog.dart';
import 'package:hidden_hiding_app/screens/SecretVault/widgets/file_view_ui.dart';
import 'package:hidden_hiding_app/screens/SecretVault/widgets/filter_area_widget.dart';
import 'package:hidden_hiding_app/screens/SecretVault/widgets/list_view_ui.dart';

class VaultMainScreen extends StatefulWidget {
  const VaultMainScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<VaultMainScreen> createState() => _VaultMainScreenState();
}

class _VaultMainScreenState extends State<VaultMainScreen> {
  final SecretVaultController _vaultCont = Get.find();

  @override
  void initState() {
    Global.applyFlag();
    Future.delayed(Duration.zero, () async {
      await _vaultCont.requestPermission();
    });
    super.initState();
  }

  @override
  void dispose() {
    _vaultCont.textKeyController.clear();
    _vaultCont.folderNameController.clear();
    super.dispose();
  }

  // vault screen
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: _vaultCont.getIsDefaultPath.value
              ? null
              : IconButton(
                  onPressed: () async {
                    if (_vaultCont.getIsFileMoving.value) {
                      return;
                    }
                    _vaultCont.setCurrentPath =
                        Directory(_vaultCont.getCurrentPath).parent.path;
                    _vaultCont.setIsDefaultPath = _vaultCont.getCurrentPath ==
                        (await FilePickerService.createNFolder()).path;
                    await _vaultCont.getStorageItems();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
          title: Text(_vaultCont.getIsDefaultPath.value
              ? "Hidden Vault"
              : _vaultCont.getCurrentPath.split("/").last),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () async {
                if (_vaultCont.getIsFileMoving.value) {
                  return;
                }
                _vaultCont.setIsFilterMode = !_vaultCont.getIsFilterMode.value;
                if (!_vaultCont.getIsFilterMode.value) {
                  await Future.delayed(const Duration(milliseconds: 300))
                      .whenComplete(() {
                    _vaultCont.setIsFlexible = !_vaultCont.getIsFlexible.value;
                  });
                } else {
                  _vaultCont.setIsFlexible = !_vaultCont.getIsFlexible.value;
                }
              },
              child: const Padding(
                  padding: EdgeInsets.only(right: 25),
                  child: Icon(Icons.filter_alt)),
            ),
            GestureDetector(
              onTap: () {
                if (_vaultCont.getIsFileMoving.value) {
                  return;
                }
                Navigator.of(context)
                    .pushNamed("/SettingsScreen")
                    .then((value) => setState(() {}));
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(Icons.settings),
              ),
            ),
          ],
        ),
        floatingActionButton: const AddMediaFloatingActionButton(),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Flexible(
                    flex: _vaultCont.getIsFlexible.value ? 1 : 0,
                    child: const FilterAreaWidget(),
                  ),
                  _vaultCont.getFileView.value
                      ? const FileViewUI()
                      : const ListViewUI(),
                ],
              ),
              if (_vaultCont.getIsFileMoving.value)
                Container(
                  color: Colors.transparent,
                  width: double.maxFinite,
                  height: double.maxFinite,
                ),
              if (_vaultCont.getIsFileMoving.value) const FileMovingDialog(),
            ],
          ),
        ),
      ),
    );
  }
}
