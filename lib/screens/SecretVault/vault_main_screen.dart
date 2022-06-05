import 'package:flutter/material.dart';
import 'package:hidden_hiding_app/screens/SecretVault/models/storage_item.dart';
import 'package:hidden_hiding_app/screens/SecretVault/services/storage_service.dart';

class VaultMainScreen extends StatefulWidget {
  const VaultMainScreen({Key? key}) : super(key: key);

  @override
  State<VaultMainScreen> createState() => _VaultMainScreenState();
}

class _VaultMainScreenState extends State<VaultMainScreen> {
  var textKeyController = TextEditingController();
  var textValueController = TextEditingController();
  var storageService = StorageService();
  List<StorageItem> items = [];

  void getStorageItems() async {
    items = await storageService.readAllSecureData();
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  leading: const Icon(Icons.security),
                  title: Text(items[index].key),
                  subtitle: Text(items[index].value),
                  trailing: const Icon(Icons.security),
                ),
              ),
            ),
          ),
          Container(
            color: Colors.grey,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Please fill the blanks:"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: textKeyController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "write the key here...",
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: textValueController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "write the value here...",
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        textKeyController.clear();
                                        textValueController.clear();
                                        Navigator.of(context).pop(false);
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        await storageService.writeSecureData(
                                          StorageItem(
                                            textKeyController.text,
                                            textValueController.text,
                                          ),
                                        );
                                        textKeyController.clear();
                                        textValueController.clear();
                                        Navigator.of(context).pop(true);
                                      },
                                      child: const Text("Submit"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).then((value) => value ? getStorageItems() : null);
                    },
                    child: const Text("Add"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await storageService.deleteAllSecureData();
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
    );
  }
}
