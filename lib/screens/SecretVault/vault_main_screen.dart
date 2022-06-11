import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hidden_hiding_app/global.dart';
import 'package:hidden_hiding_app/preferences.dart';
import 'package:hidden_hiding_app/screens/SecretVault/models/storage_item.dart';
import 'package:hidden_hiding_app/screens/SecretVault/services/file_picker.dart';
import 'package:hidden_hiding_app/screens/SecretVault/services/storage_service.dart';
import 'package:hidden_hiding_app/screens/SecretVault/widgets/video_player.dart';
import 'package:permission_handler/permission_handler.dart';

class VaultMainScreen extends StatefulWidget {
  const VaultMainScreen({Key? key}) : super(key: key);

  @override
  State<VaultMainScreen> createState() => _VaultMainScreenState();
}

class _VaultMainScreenState extends State<VaultMainScreen> {
  var storageService = StorageService();
  var filePickService = FilePickerService();
  var textKeyController = TextEditingController();

  void getStorageItems() async {
    Global().items = await storageService.readAllSecureData();
    Global()
        .items
        .sort((a, b) => a.value.toLowerCase().compareTo(b.value.toLowerCase()));
    print(Global().items.length);
    for (var element in Global().items) {
      print(element.key);
    }
    setState(() {});
  }

  @override
  void initState() {
    requestPermission();
    getStorageItems();
    super.initState();
  }

  void requestPermission() async {
    var storagePermissionStatus = await Permission.storage.status;
    if (!storagePermissionStatus.isGranted) {
      await Permission.storage.request();
    }

    var externalStoragePermissionStatus =
        await Permission.manageExternalStorage.status;
    if (!externalStoragePermissionStatus.isGranted) {
      await Permission.manageExternalStorage.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent[700],
        heroTag: "interactionButton",
        child: const Icon(
          Icons.add,
          color: Colors.black,
          size: 26,
        ),
        onPressed: () {
          showDialog(context: context, builder: (context) => addFileDialog())
              .then((value) => value ? getStorageItems() : value);
        },
      ),
      appBar: AppBar(
        title: const Text("Hidden Vault"),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed("/SettingsScreen");
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.settings),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(12.0),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  crossAxisSpacing: 10,
                ),
                itemCount: Global().items.length,
                itemBuilder: (context, index) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[700]!,
                          width: 2,
                        ),
                      ),
                      // media element
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return expandMediaFileDialog(index);
                            },
                          );
                        },
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return exportOrDeleteMediaFileDialog(index);
                            },
                          ).then((value) => value ? getStorageItems() : value);
                        },
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: ClipRRect(
                            clipBehavior: Clip.hardEdge,
                            child: Global().getFileInfo(
                                        Global().items[index].value,
                                        "extension") !=
                                    "mp4"
                                ? Image.file(
                                    File(Global().items[index].key),
                                    fit: BoxFit.cover,
                                  )
                                : Stack(
                                    children: [
                                      VideoPlayerWidget(
                                        mediaFile: Global().items[index],
                                        isExpandedVideo: false,
                                      ),
                                      const Positioned(
                                        right: 2,
                                        top: 2,
                                        child: Icon(Icons.video_collection),
                                      )
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                    // media name and edit
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 8,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Text(
                              Global().getFileInfo(
                                  Global().items[index].value, "name"),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) =>
                                      editMediaFileName(index)).then(
                                  (value) => value ? getStorageItems() : value);
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.edit),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.grey[700],
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await storageService.deleteAllSecureData();
                        await filePickService.deleteFilesFormApp();
                        getStorageItems();
                      },
                      child: const Text("Delete All"),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget expandMediaFileDialog(int index) {
    return Dialog(
      insetPadding: const EdgeInsets.all(0),
      elevation: 0,
      child: Stack(
        children: [
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Global().getFileInfo(
                              Global().items[index].value, "extension") !=
                          "mp4"
                      ? Image.file(
                          File(Global().items[index].key),
                          fit: BoxFit.contain,
                        )
                      : VideoPlayerWidget(
                          mediaFile: Global().items[index],
                          isExpandedVideo: true),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Wrap(
                    children: [
                      Text(
                        Global()
                            .getFileInfo(Global().items[index].value, "name"),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText2,
                      )
                    ],
                  ),
                )
              ],
            ),
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

  Widget editMediaFileName(int index) {
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
                    style: Theme.of(context).textTheme.headline6,
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
              controller: textKeyController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText:
                    Global().getFileInfo(Global().items[index].value, "name"),
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
                    textKeyController.clear();
                    Navigator.of(context).pop(false);
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (textKeyController.text.isNotEmpty) {
                      await storageService.writeSecureData(
                        StorageItem(
                            Global().items[index].key,
                            Global().setNewFileName(
                                "${textKeyController.text}.${Global().getFileInfo(Global().items[index].value, "name").split(".").last}",
                                index)),
                      );
                    }
                    textKeyController.clear();
                    Navigator.of(context).pop(true);
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

  Widget addFileDialog() {
    return Dialog(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    "Please select a method to pick a file:",
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
                    await filePickService.getSingleFile();
                    Navigator.of(context).pop(true);
                  },
                  child: const Text("Add File"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await filePickService.getDir();

                    Navigator.of(context).pop(true);
                  },
                  child: const Text("Dir Info"),
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

  Widget exportOrDeleteMediaFileDialog(int index) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Colors.grey.shade900,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Select a directory to export your file or delete it",
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
            child: Text(
              "Selected file:\n${Global().getFileInfo(Global().items[index].value, "name")}",
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (!Preferences().getIsExportPathSelected) {
                      var selectedPath =
                          await Global().getDirectoryToExportMediaFile();
                      Preferences().setExportPath = selectedPath;
                      print(
                          "set export path worked, selected path: $selectedPath");
                    }
                    if (Preferences().getExportPath != "none") {
                      Preferences().setIsExportPathSelected = true;
                      filePickService.moveFile(
                        File(Global().items[index].key),
                        (await filePickService.joinFilePaths(
                                Preferences().getExportPath,
                                Global().items[index].key.split("/").last))
                            .path,
                      );
                      await storageService
                          .deleteSecureData(Global().items[index]);
                      print("move the file to selected path worked");
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Export location is not selected!'),
                      ));
                    }
                    Navigator.of(context).pop(true);
                  },
                  child: const Text("Export"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await storageService
                        .deleteSecureData(Global().items[index]);
                    await filePickService
                        .deleteFile(File(Global().items[index].key));
                    Navigator.of(context).pop(true);
                  },
                  child: const Text("Delete"),
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
