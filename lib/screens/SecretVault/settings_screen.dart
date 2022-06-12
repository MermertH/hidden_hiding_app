import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<Map<String, dynamic>> buttons = [
    {
      "tag": "language",
      "leading": const Icon(Icons.language),
      "title": const Text("Change Language"),
      "trailing": const SizedBox(),
    },
    {
      "tag": "security",
      "leading": const Icon(Icons.security),
      "title": const Text("Change secret pin and trigger combination"),
      "trailing": const SizedBox(),
    },
    {
      "tag": "export",
      "leading": const Icon(Icons.import_export),
      "title": const Text("Change export location"),
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
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: buttons.length,
              shrinkWrap: true,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  onTap: () {},
                  leading: buttons[index]["leading"],
                  title: buttons[index]["title"],
                  trailing: buttons[index]["trailing"],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
