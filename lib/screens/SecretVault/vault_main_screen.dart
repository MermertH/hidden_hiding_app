import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hidden_hiding_app/screens/SecretVault/models/storage_item.dart';
import 'package:hidden_hiding_app/screens/SecretVault/services/file_picker.dart';
import 'package:hidden_hiding_app/screens/SecretVault/services/storage_service.dart';
import 'package:path_provider/path_provider.dart';

class VaultMainScreen extends StatefulWidget {
  const VaultMainScreen({Key? key}) : super(key: key);

  @override
  State<VaultMainScreen> createState() => _VaultMainScreenState();
}

class _VaultMainScreenState extends State<VaultMainScreen> {
  var textKeyController = TextEditingController();
  var storageService = StorageService();
  var filePickService = FilePickerService();
  List<StorageItem> items = [];

  void getStorageItems() async {
    items = await storageService.readAllSecureData();
    items
        .sort((a, b) => a.value.toLowerCase().compareTo(b.value.toLowerCase()));
    print(items.length);
    for (var element in items) {
      print(element.key);
    }
    setState(() {});
  }

  @override
  void initState() {
    getStorageItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hidden Vault"),
        centerTitle: true,
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
                itemCount: items.length,
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
                              return Dialog(
                                insetPadding: const EdgeInsets.all(0),
                                elevation: 0,
                                child: Stack(
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: Image.file(
                                            File(items[index].key),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Wrap(
                                            children: [
                                              Text(
                                                items[index].value,
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2,
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: GestureDetector(
                                        onTap: () =>
                                            Navigator.of(context).pop(),
                                        child: const CircleAvatar(
                                          backgroundColor: Colors.grey,
                                          child: Icon(
                                            Icons.close,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: ClipRRect(
                            clipBehavior: Clip.hardEdge,
                            child: Image.file(
                              File(items[index].key),
                              fit: BoxFit.cover,
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
                              items[index].value,
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
                                  builder: (context) => Dialog(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Edit File Name",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 15,
                                                vertical: 8,
                                              ),
                                              child: TextField(
                                                textAlign: TextAlign.center,
                                                controller: textKeyController,
                                                decoration: InputDecoration(
                                                  border:
                                                      const OutlineInputBorder(),
                                                  hintText: items[index].value,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 6),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      textKeyController.clear();
                                                      Navigator.of(context)
                                                          .pop(false);
                                                    },
                                                    child: const Text("Cancel"),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      await storageService
                                                          .writeSecureData(
                                                        StorageItem(
                                                            items[index].key,
                                                            "${textKeyController.text}.${items[index].value.split(".").last}"),
                                                      );
                                                      textKeyController.clear();
                                                      Navigator.of(context)
                                                          .pop(true);
                                                    },
                                                    child: const Text("Submit"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )).then(
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
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                      "Please select a method to pick a file:"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          await filePickService.getSingleFile();
                                          Navigator.of(context).pop(true);
                                        },
                                        child: const Text("Single File"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          await filePickService.getDir();

                                          Navigator.of(context).pop(true);
                                        },
                                        child:
                                            const Text("Get Directory Folders"),
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
                          ),
                        ).then((value) => value ? getStorageItems() : value);
                      },
                      child: const Text("Add File"),
                    ),
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
}
