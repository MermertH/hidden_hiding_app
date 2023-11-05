import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hidden_hiding_app/controller/secret_vault_controller.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionWarningDialog extends StatelessWidget {
  final bool isPermanentlyDenied;
  final bool isExternalStoragePermanentlyDenied;
  final bool? otherPermissionsDenied;
  const PermissionWarningDialog({
    Key? key,
    required this.isPermanentlyDenied,
    required this.isExternalStoragePermanentlyDenied,
    this.otherPermissionsDenied = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SecretVaultController _vaultCont = Get.find();
    var warningMsg =
        "In order to use this application, required permissions must be given."
        "${isPermanentlyDenied || isExternalStoragePermanentlyDenied || otherPermissionsDenied! ? "Please go to app permission settings and activate permissions manually" : ''}";
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
                    warningMsg,
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
                if (isPermanentlyDenied ||
                    isExternalStoragePermanentlyDenied ||
                    otherPermissionsDenied!)
                  ElevatedButton(
                    onPressed: () async {
                      await openAppSettings();
                      await _vaultCont.requestPermission();
                      Get.back();
                    },
                    child: const Text("Permit"),
                  ),
                ElevatedButton(
                  onPressed: () {
                    exit(0);
                  },
                  child: const Text("Close App"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
