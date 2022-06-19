import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hidden_hiding_app/global.dart';
import 'package:hidden_hiding_app/preferences.dart';
import 'package:hidden_hiding_app/screens/SecretVault/services/file_picker.dart';
import 'package:hidden_hiding_app/screens/SecretVault/widgets/video_player_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class VaultMainScreen extends StatefulWidget {
  const VaultMainScreen({Key? key}) : super(key: key);

  @override
  State<VaultMainScreen> createState() => _VaultMainScreenState();
}

class _VaultMainScreenState extends State<VaultMainScreen>
    with SingleTickerProviderStateMixin {
  var filePickService = FilePickerService();
  var textKeyController = TextEditingController();
  var folderNameController = TextEditingController();
  bool _isExpanded = false;
  bool _islabelVisible = false;
  bool isFilterMode = false;
  bool isDefaultPath = true;

  @override
  void initState() {
    requestPermission();
    getStorageItems();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getInitDir() async {
    if (Global().isOnce) {
      var initDir = await filePickService.createNFolder();
      Global().currentPath = initDir.path;
      Global().isOnce = false;
    } else {}
  }

  void getStorageItems() async {
    await getInitDir();
    Global().items =
        await filePickService.getDirMedia(Directory(Global().currentPath));
    Global().items = Global().applyExtensionFilter(Global().items);
    Global().items =
        Global().applySelectedSort(Global().items, Preferences().getSortData);
    setState(() {});
  }

  void requestPermission() async {
    var storagePermissionStatus = await Permission.storage.status;
    if (!storagePermissionStatus.isGranted) {
      await Permission.storage.request().then((permission) {
        if (permission.isDenied || permission.isPermanentlyDenied) {
          // TODO warn user to accept, otherwise app wont work.
        }
      });
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: isDefaultPath
            ? null
            : IconButton(
                onPressed: () async {
                  Global().currentPath =
                      Directory(Global().currentPath).parent.path;
                  isDefaultPath = Global().currentPath ==
                      (await filePickService.createNFolder()).path;
                  getStorageItems();
                },
                icon: const Icon(Icons.arrow_back),
              ),
        title: Text(isDefaultPath
            ? "Hidden Vault"
            : Global().currentPath.split("/").last),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                isFilterMode = !isFilterMode;
              });
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 25),
              child: Icon(Icons.filter),
            ),
          ),
          GestureDetector(
            onTap: () {
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
      floatingActionButton: StatefulBuilder(
        builder: (context, setState) {
          return Stack(
            children: [
              AnimatedPositioned(
                onEnd: () {
                  setState(() {
                    if (_isExpanded) {
                      _islabelVisible = true;
                    }
                  });
                },
                bottom: _isExpanded ? 160 : 0,
                duration: const Duration(milliseconds: 150),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _islabelVisible
                        ? Positioned(
                            left: -130,
                            bottom: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade700,
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
                        setState(() {
                          showDialog(
                                  context: context,
                                  builder: (context) => addNewFolderDialog())
                              .then(
                                  (value) => value ? getStorageItems() : false);
                        });
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
                bottom: _isExpanded ? 80 : 0,
                duration: const Duration(milliseconds: 150),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _islabelVisible
                        ? Positioned(
                            left: -110,
                            bottom: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade700,
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
                      onPressed: () {
                        setState(() {
                          showDialog(
                                  context: context,
                                  builder: (context) => addFileDialog())
                              .then(
                                  (value) => value ? getStorageItems() : false);
                        });
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
                    backgroundColor:
                        !_isExpanded ? Colors.greenAccent[700]! : Colors.red,
                    heroTag: "interactionButton",
                    child: Icon(
                      !_isExpanded ? Icons.add : Icons.close,
                      color: Colors.black,
                      size: 26,
                    ),
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                        _islabelVisible = false;
                      });
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              child: AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
                child: isFilterMode
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: Text("View Style:",
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                              )),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 8,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Preferences().getViewStyle
                                                ? Colors.black
                                                : Colors.grey.shade700,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              Preferences().setViewStyle = true;
                                            });
                                          },
                                          child: Text("File",
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: !Preferences().getViewStyle
                                                ? Colors.black
                                                : Colors.grey.shade700,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              Preferences().setViewStyle =
                                                  false;
                                            });
                                          },
                                          child: Text("List",
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 12, bottom: 12),
                              child: Text("Extension Filter:",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      )),
                            ),
                            SizedBox(
                              height: 40,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 4,
                                      color: Colors.grey[600],
                                    ),
                                    Flexible(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            Preferences.extensionTypes.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 18),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Preferences()
                                                          .getExtensionsBool(
                                                              Preferences
                                                                  .extensionTypes
                                                                  .keys
                                                                  .toList()[index])
                                                      ? Colors.black
                                                      : Colors.grey.shade700),
                                              onPressed: () {
                                                if (Preferences
                                                        .extensionTypes.keys
                                                        .toList()[index] !=
                                                    "any") {
                                                  Preferences()
                                                          .setExtensionTypeAny =
                                                      false;
                                                  Preferences()
                                                      .setExtensionType = index;
                                                  Preferences()
                                                          .setCheckExtensionTypeExceptAny =
                                                      true;
                                                } else {
                                                  Preferences()
                                                          .setExtensionTypeAny =
                                                      true;
                                                  Preferences()
                                                          .setExtensionTypeExceptAny =
                                                      false;
                                                }
                                                getStorageItems();
                                              },
                                              child: Text(Preferences
                                                  .extensionTypes.keys
                                                  .toList()[index]),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Container(
                                      width: 4,
                                      color: Colors.grey[600],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text("List Sorting",
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      )),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                RadioListTile<String>(
                                  title: const Text('From A to Z'),
                                  value: "A_Z",
                                  groupValue: Preferences().getSortData,
                                  onChanged: (String? value) {
                                    Preferences().setSort = value!;
                                    getStorageItems();
                                  },
                                ),
                                RadioListTile<String>(
                                  title: const Text('From Z to A'),
                                  value: "Z_A",
                                  groupValue: Preferences().getSortData,
                                  onChanged: (String? value) {
                                    Preferences().setSort = value!;
                                    getStorageItems();
                                  },
                                ),
                                RadioListTile<String>(
                                  title: const Text('From first date'),
                                  value: "firstDate",
                                  groupValue: Preferences().getSortData,
                                  onChanged: (String? value) {
                                    Preferences().setSort = value!;
                                    getStorageItems();
                                  },
                                ),
                                RadioListTile<String>(
                                  title: const Text('From last date'),
                                  value: "lastDate",
                                  groupValue: Preferences().getSortData,
                                  onChanged: (String? value) {
                                    Preferences().setSort = value!;
                                    getStorageItems();
                                  },
                                ),
                                RadioListTile<String>(
                                  title: const Text(
                                      'From high to lower file size'),
                                  value: "sizeDescending",
                                  groupValue: Preferences().getSortData,
                                  onChanged: (String? value) {
                                    Preferences().setSort = value!;
                                    getStorageItems();
                                  },
                                ),
                                RadioListTile<String>(
                                  title: const Text(
                                      'From low to higher file size'),
                                  value: "sizeAscending",
                                  groupValue: Preferences().getSortData,
                                  onChanged: (String? value) {
                                    Preferences().setSort = value!;
                                    getStorageItems();
                                  },
                                ),
                              ],
                            ),
                            Container(
                              height: 4,
                              color: Colors.grey.shade800,
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
              ),
            ),
            Preferences().getViewStyle ? fileViewStyle() : listViewStyle(),
          ],
        ),
      ),
    );
  }

  // View Styles
  Widget listViewStyle() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: Global().items.length,
          itemBuilder: (context, index) => Card(
            child: ListTile(
              onTap: () async {
                if (Global().items[index].key.statSync().type ==
                    FileSystemEntityType.directory) {
                  Global().currentPath = Global().items[index].key.path;
                  isDefaultPath = Global().currentPath ==
                      (await filePickService.createNFolder()).path;
                  getStorageItems();
                } else if (Global().getFileInfo(
                        Global().items[index].value, "extension") ==
                    "mp4") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          VideoPlayerScreen(mediaFile: Global().items[index]),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return expandMediaFileDialog(index);
                    },
                  );
                }
              },
              onLongPress: () {
                if (Global().items[index].key.statSync().type ==
                    FileSystemEntityType.directory) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return exportOrDeleteMediaDialog(index);
                    },
                  ).then((value) => value ? getStorageItems() : false);
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return exportOrDeleteMediaDialog(index);
                    },
                  ).then((value) => value ? getStorageItems() : false);
                }
              },
              leading: Global().items[index].key.statSync().type !=
                      FileSystemEntityType.directory
                  ? Global().getFileInfo(
                              Global().items[index].value, "extension") !=
                          "mp4"
                      ? ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 60,
                            maxHeight: 60,
                          ),
                          child: AspectRatio(
                            aspectRatio: 4 / 3,
                            child: Image.file(
                              File(Global().items[index].key.path),
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                            ),
                          ),
                        )
                      : FutureBuilder(
                          future: Global()
                              .videoThumbnail(Global().items[index].key.path),
                          builder: (context, snapshot) {
                            return ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 60,
                                maxHeight: 60,
                              ),
                              child: AspectRatio(
                                aspectRatio: 4 / 3,
                                child: Stack(
                                  children: [
                                    Align(
                                        alignment: Alignment.center,
                                        child: AspectRatio(
                                          aspectRatio: 4 / 3,
                                          child: snapshot.hasData
                                              ? Image.memory(
                                                  snapshot.data! as Uint8List,
                                                  fit: BoxFit.cover,
                                                )
                                              : const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.green,
                                                  ),
                                                ),
                                        )),
                                    const Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Icon(
                                        Icons.video_collection,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })
                  : ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 60,
                        maxHeight: 60,
                      ),
                      child: const AspectRatio(
                          aspectRatio: 4 / 3,
                          child: Center(
                            child: Icon(
                              Icons.folder,
                              size: 35,
                            ),
                          )),
                    ),
              title: Text(
                Global().getFileInfo(Global().items[index].value, "name"),
                style: Theme.of(context).textTheme.headline1,
              ),
              subtitle: Global().items[index].key.statSync().type ==
                      FileSystemEntityType.file
                  ? Text(Global.getFileSizeFormat(
                      bytes: int.parse(Global()
                          .getFileInfo(Global().items[index].value, "size")),
                      decimals: 2))
                  : null,
              trailing: GestureDetector(
                onTap: () {
                  showDialog(
                          context: context,
                          builder: (context) => editMediaFileName(index))
                      .then((value) => value ? getStorageItems() : false);
                },
                child: const Padding(
                  padding: EdgeInsets.all(2),
                  child: Icon(Icons.edit),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget fileViewStyle() {
    return Expanded(
      child: GridView.builder(
        clipBehavior: Clip.hardEdge,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 4 / 3,
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
                  width: 0,
                ),
              ),
              // media element
              child: GestureDetector(
                onTap: () async {
                  if (Global().items[index].key.statSync().type ==
                      FileSystemEntityType.directory) {
                    Global().currentPath = Global().items[index].key.path;
                    isDefaultPath = Global().currentPath ==
                        (await filePickService.createNFolder()).path;
                    getStorageItems();
                  } else if (Global().getFileInfo(
                          Global().items[index].value, "extension") ==
                      "mp4") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VideoPlayerScreen(mediaFile: Global().items[index]),
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return expandMediaFileDialog(index);
                      },
                    );
                  }
                },
                onLongPress: () async {
                  if (Global().items[index].key.statSync().type ==
                      FileSystemEntityType.directory) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return exportOrDeleteMediaDialog(index);
                      },
                    ).then((value) => value ? getStorageItems() : false);
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return exportOrDeleteMediaDialog(index);
                      },
                    ).then((value) => value ? getStorageItems() : value);
                  }
                },
                child: Global().items[index].key.statSync().type !=
                        FileSystemEntityType.directory
                    ? Global().getFileInfo(
                                Global().items[index].value, "extension") !=
                            "mp4"
                        ? Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            children: [
                              AspectRatio(
                                aspectRatio: 4 / 3,
                                child: Image.file(
                                  File(Global().items[index].key.path),
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                ),
                              ),
                              Container(
                                color: Colors.black.withOpacity(0.4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 8,
                                      child: Text(
                                        Global().getFileInfo(
                                            Global().items[index].value,
                                            "name"),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      editMediaFileName(index))
                                              .then((value) => value
                                                  ? getStorageItems()
                                                  : false);
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(2),
                                          child: Icon(Icons.edit),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : FutureBuilder(
                            future: Global()
                                .videoThumbnail(Global().items[index].key.path),
                            builder: (context, snapshot) {
                              return Stack(
                                alignment: AlignmentDirectional.bottomCenter,
                                children: [
                                  AspectRatio(
                                    aspectRatio: 4 / 3,
                                    child: snapshot.hasData
                                        ? Image.memory(
                                            snapshot.data! as Uint8List,
                                            fit: BoxFit.cover,
                                          )
                                        : const Center(
                                            child: CircularProgressIndicator(
                                            color: Colors.green,
                                          )),
                                  ),
                                  const Positioned(
                                    right: 2,
                                    top: 2,
                                    child: Icon(Icons.video_collection),
                                  ),
                                  Container(
                                    color: Colors.black.withOpacity(0.4),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          flex: 8,
                                          child: Text(
                                            Global().getFileInfo(
                                                Global().items[index].value,
                                                "name"),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1,
                                          ),
                                        ),
                                        Flexible(
                                          flex: 2,
                                          child: GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      editMediaFileName(
                                                          index)).then(
                                                  (value) => value
                                                      ? getStorageItems()
                                                      : false);
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.all(2),
                                              child: Icon(Icons.edit),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            })
                    : Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          AspectRatio(
                            aspectRatio: 4 / 3,
                            child: Container(
                              color: Colors.transparent,
                              child: const Icon(
                                Icons.folder,
                                size: 50,
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.black.withOpacity(0.4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 8,
                                  child: Text(
                                    Global().getFileInfo(
                                        Global().items[index].value, "name"),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.headline1,
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
                                          (value) => value
                                              ? getStorageItems()
                                              : false);
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(2),
                                      child: Icon(Icons.edit),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            // media name and edit
          ],
        ),
      ),
    );
  }

  // Dialogs
  Widget expandMediaFileDialog(int index) {
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
                File(Global().items[index].key.path),
                fit: BoxFit.contain,
              )),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Wrap(
                  children: [
                    Text(
                      Global().getFileInfo(Global().items[index].value, "name"),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText2,
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
                      await filePickService.renameFileOrFolder(
                          Global().items[index].key,
                          Global().items[index].key.statSync().type ==
                                  FileSystemEntityType.file
                              ? "${textKeyController.text}.${Global().getFileInfo(Global().items[index].value, "extension")}"
                              : textKeyController.text);
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

  Widget addNewFolderDialog() {
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
              controller: folderNameController,
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
                    folderNameController.clear();
                    Navigator.of(context).pop(false);
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    bool isValid = false;
                    if (folderNameController.text.isNotEmpty) {
                      await filePickService.createFolderInGivenPath(
                        folderNameController.text,
                        Global().currentPath,
                        context,
                      );
                      isValid = true;
                    }
                    folderNameController.clear();
                    Navigator.of(context).pop(isValid);
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
                    await filePickService.getFilesWithFilter();
                    Navigator.of(context).pop(true);
                  },
                  child: const Text("Add Media"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    filePickService.getDir();
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

  Widget exportOrDeleteMediaDialog(int index) {
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
                if (Global().items[index].key.statSync().type ==
                    FileSystemEntityType.file)
                  ElevatedButton(
                    onPressed: () async {
                      if (!Preferences().getIsExportPathSelected) {
                        var selectedPath =
                            await Global().getDirectoryToExportMediaFile();
                        Preferences().setExportPath = selectedPath;
                        debugPrint(
                            "set export path worked, selected path: $selectedPath");
                      }
                      if (Preferences().getExportPath != "none") {
                        Preferences().setIsExportPathSelected = true;
                        await filePickService.moveFile(
                          File(Global().items[index].key.path),
                          (await filePickService.joinFilePaths(
                                  Preferences().getExportPath,
                                  Global()
                                      .items[index]
                                      .key
                                      .path
                                      .split("/")
                                      .last))
                              .path,
                        );
                        debugPrint("move the file to selected path worked");
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Export location is not selected!'),
                        ));
                      }
                      Navigator.of(context).pop(true);
                    },
                    child: const Text("Export"),
                  ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => deleteSelectedFileDialog(
                              Global().items[index].key.path,
                              index,
                            )).then((value) {
                      if (value) {
                        Navigator.of(context).pop(true);
                      }
                    });
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

  Widget deleteSelectedFileDialog(String path, int index) {
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
                    await filePickService.deleteMedia(
                        Global().items[index].key.statSync().type ==
                                FileSystemEntityType.file
                            ? File(path)
                            : Directory(path));
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
