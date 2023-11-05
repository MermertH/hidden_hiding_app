import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hidden_hiding_app/controller/secret_vault_controller.dart';
import 'package:hidden_hiding_app/preferences.dart';
import 'package:hidden_hiding_app/screens/SecretVault/widgets/dialogs/delete_all_data_dialog.dart';
import 'package:hidden_hiding_app/screens/SecretVault/widgets/dialogs/set_combination_dialog.dart';
import 'package:hidden_hiding_app/screens/WordGame/game_screen.dart';
import 'package:hidden_hiding_app/screens/WordGame/widgets/pin_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SecretVaultController _vaultCont = Get.find();
  List<Map<String, dynamic>> buttons = [
    {
      "tag": "security",
      "leading": const Icon(Icons.security),
      "title": const Text("Change trigger combination"),
      "trailing": const SizedBox(),
    },
    {
      "tag": "pin",
      "leading": const Icon(Icons.password),
      "title": const Text("Change secret pin"),
      "trailing": const SizedBox(),
    },
    {
      "tag": "export",
      "leading": const Icon(Icons.import_export),
      "title": const Text("Change export location"),
      "trailing": const SizedBox(),
    },
    {
      "tag": "gameScreen",
      "leading": const Icon(Icons.abc),
      "title": const Text("Return to the game"),
      "trailing": const SizedBox(),
    },
    {
      "tag": "delete",
      "leading": const Icon(Icons.delete),
      "title": const Text(
        "Delete all Data",
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      "trailing": const SizedBox(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: buttons.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => Card(
                  child: ListTile(
                    onTap: () {
                      buttonFunctions(buttons[index]["tag"]);
                    },
                    leading: buttons[index]["leading"],
                    title: buttons[index]["title"],
                    trailing: buttons[index]["trailing"],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void buttonFunctions(String tag) async {
    switch (tag) {
      case "delete":
        Get.dialog(
          const DeleteAllDataDialog(),
        );
        break;
      case "export":
        var selectedPath = await _vaultCont.getDirectoryToExportMediaFile();
        Preferences().setExportPath = selectedPath;
        debugPrint("set export path worked, selected path: $selectedPath");
        if (Preferences().getExportPath != "none") {
          Preferences().setIsExportPathSelected = true;
        } else {
          Preferences().setIsExportPathSelected = false;
        }
        break;
      case "pin":
        Get.dialog(
          const PinDialog(
            isPasswordSet: true,
            isInVault: true,
            isTutorial: false,
          ),
          barrierDismissible: false,
        );

        break;
      case "security":
        Get.dialog(
          const SetCombinationDialog(),
          barrierDismissible: false,
        );
        break;
      case "gameScreen":
        Get.offAll(() => const GameScreen());
        break;
      default:
        return;
    }
  }
}
