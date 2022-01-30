import 'package:flutter/material.dart';
import 'models/notes.dart';

class BirthdayReminderScreen extends StatefulWidget {
  const BirthdayReminderScreen({Key? key}) : super(key: key);

  @override
  _BirthdayReminderScreenState createState() => _BirthdayReminderScreenState();
}

class _BirthdayReminderScreenState extends State<BirthdayReminderScreen> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  List<Notes> list = [];
  bool isEdit = false;
  static int id = 1;

  @override
  Widget build(BuildContext context) {
    double? screenHeight = MediaQuery.of(context).size.height;
    double? screenWidth = MediaQuery.of(context).size.width;
    double appBarheight = MediaQuery.of(context).padding.top + kToolbarHeight;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('CakeNote Keeper'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                width: double.maxFinite,
                height: screenHeight - appBarheight,
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      width: screenWidth,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    list.removeAt(index);
                                  });
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.delete),
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isEdit = true;
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      noteDialog(index: index),
                                );
                              });
                            },
                            child: Card(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  topLeft: Radius.circular(30),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: screenWidth,
                                    decoration: const BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(30),
                                        topLeft: Radius.circular(30),
                                      ),
                                    ),
                                    child: Center(
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            top: 5, bottom: 5),
                                        child: Text(
                                          list[index].title!,
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                      width: screenWidth,
                                      margin: const EdgeInsets.only(
                                          left: 3, right: 3, bottom: 3),
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            top: 5, bottom: 5),
                                        child: Text(
                                          list[index].userNote!,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      )),
                                ],
                              ),
                              elevation: 5,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isEdit = false;
            showDialog(
              context: context,
              builder: (BuildContext context) => noteDialog(),
            );
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget noteDialog({int? index}) {
    return AlertDialog(
      title: Text(isEdit == true ? "Edit CakeNote" : "Add New CakeNote"),
      content: SizedBox(
        height: 100,
        width: 100,
        child: Column(
          children: [
            TextField(
              controller: title,
              decoration: InputDecoration(
                  hintText: isEdit == true
                      ? list[index!].title
                      : 'Enter your CakeNote title here'),
              onSubmitted: (_) {
                print(title.text);
              },
            ),
            TextField(
              controller: description,
              decoration: InputDecoration(
                  hintText: isEdit == true
                      ? list[index!].userNote
                      : 'Enter your CakeNote here'),
              onSubmitted: (_) {
                print(description.text);
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        TextButton(
          child: const Text("Close"),
          onPressed: () {
            title.clear();
            description.clear();
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Submit'),
          onPressed: () {
            if (isEdit == true) {
              if (title.text != '') {
                list[index!].title = title.text;
              }
              if (description.text != '') {
                list[index!].userNote = description.text;
              }
            } else {
              list.add(Notes(
                  title: title.text, userNote: description.text, noteId: id));
              id++;
            }
            title.clear();
            description.clear();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
