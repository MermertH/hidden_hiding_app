import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hidden_hiding_app/controller/secret_vault_controller.dart';

class ExpandMediaFileDialog extends StatelessWidget {
  final int index;
  const ExpandMediaFileDialog({Key? key, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SecretVaultController _vaultCont = Get.find();
    return Dialog(
      insetPadding: const EdgeInsets.all(0),
      elevation: 0,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            color: Colors.black,
            width: double.maxFinite,
            height: double.maxFinite,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                  child: Image.file(
                File(_vaultCont.items[index].key.path),
                fit: BoxFit.contain,
              )),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Wrap(
                  children: [
                    Text(
                      _vaultCont.getFileInfo(
                          _vaultCont.items[index].value, "name"),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  ],
                ),
              )
            ],
          ),
          Positioned(
            top: 5,
            left: 10,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.5),
                child: const Icon(
                  Icons.close,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
