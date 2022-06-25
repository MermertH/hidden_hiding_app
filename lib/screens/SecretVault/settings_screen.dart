import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hidden_hiding_app/global.dart';
import 'package:hidden_hiding_app/preferences.dart';
import 'package:hidden_hiding_app/screens/SecretVault/services/file_picker.dart';
import 'package:hidden_hiding_app/screens/SecretVault/widgets/set_combination_dialog.dart';
import 'package:hidden_hiding_app/screens/WordGame/game_screen.dart';
import 'package:hidden_hiding_app/screens/WordGame/widgets/pin_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var filePickService = FilePickerService();
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

  void getStorageItems() async {
    Global().items =
        await filePickService.getDirMedia(Directory(Global().currentPath));
    Global().items = Global().applyExtensionFilter(Global().items);
    Global().items =
        Global().applySelectedSort(Global().items, Preferences().getSortData);
    setState(() {});
  }

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
        showDialog(
                context: context, builder: (context) => deleteAllDataDialog())
            .then((value) => value ? getStorageItems() : false);
        break;
      case "export":
        var selectedPath = await Global().getDirectoryToExportMediaFile();
        Preferences().setExportPath = selectedPath;
        debugPrint("set export path worked, selected path: $selectedPath");
        if (Preferences().getExportPath != "none") {
          Preferences().setIsExportPathSelected = true;
        } else {
          Preferences().setIsExportPathSelected = false;
        }
        break;
      case "pin":
        showDialog(
            context: context,
            builder: (context) => const PinDialog(
                  isPasswordSet: true,
                  isInVault: true,
                  isTutorial: false,
                ));
        break;
      case "security":
        showDialog(
            context: context,
            builder: (context) => const SetCombinationDialog());

        break;
      case "gameScreen":
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const GameScreen()),
          (Route<dynamic> route) => false,
        );
        break;
      default:
        return;
    }
  }

  Widget deleteAllDataDialog() {
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
                    style: Theme.of(context).textTheme.bodyText2,
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
                    await filePickService.deleteFilesFormApp();
                    Navigator.of(context).pop(true);
                  },
                  child: Text("ACCEPT",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: Colors.red)),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
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
