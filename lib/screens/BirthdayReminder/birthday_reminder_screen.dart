import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'models/notes.dart';

class BirthdayReminderScreen extends StatefulWidget {
  const BirthdayReminderScreen({Key? key}) : super(key: key);

  @override
  _BirthdayReminderScreenState createState() => _BirthdayReminderScreenState();
}

class _BirthdayReminderScreenState extends State<BirthdayReminderScreen> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController birthdayDate = TextEditingController();
  DateTime selectedDate = DateTime.now();
  List<Notes> list = [];
  bool isEdit = false;
  static int id = 1;

  @override
  Widget build(BuildContext context) {
    double? screenHeight = MediaQuery.of(context).size.height;
    double? screenWidth = MediaQuery.of(context).size.width;
    // double appBarheight = MediaQuery.of(context).padding.top + kToolbarHeight;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Container(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Birthday Reminder",
                    style: GoogleFonts.aldrich(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(45),
                    bottomRight: Radius.circular(45),
                  )),
            ),
            ListView.builder(
              shrinkWrap: true,
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
                              builder: (context) => noteDialog(index: index),
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
                                  margin:
                                      const EdgeInsets.only(top: 5, bottom: 5),
                                  child: Text(
                                    list[index].description!,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
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
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
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
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 1),
      helpText: 'Select birthday date',
      errorFormatText: 'Invalid date!',
      errorInvalidText: 'Invalid date range!',
      fieldLabelText: 'Birthday date',
      fieldHintText: 'Month/Day/Year',
      initialEntryMode: DatePickerEntryMode.input,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black, // header background color
              onPrimary: Colors.white, // header text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.black, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        birthdayDate.text = DateFormat.yMd().format(picked);
      });
    }
  }

  Widget noteDialog({int? index}) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(45),
      ),
      child: SizedBox(
        height: 400,
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: double.maxFinite,
              height: 60,
              decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45),
                    topRight: Radius.circular(45),
                  )),
              child: Center(
                child: Text(
                  isEdit == true ? "Edit Birthday" : "Add New Birthday",
                  style: GoogleFonts.aldrich(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 130,
                  child: TextField(
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(45),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 5.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(45),
                          borderSide:
                              BorderSide(color: Colors.grey[700]!, width: 5.0),
                        ),
                        hintText: isEdit == true
                            ? list[index!].title
                            : DateFormat.yMd().format(selectedDate)),
                    style: GoogleFonts.alata(),
                    textAlign: TextAlign.center,
                    controller: birthdayDate,
                    readOnly: true,
                  ),
                ),
                ElevatedButton(
                    style: TextButton.styleFrom(
                      fixedSize: const Size.fromWidth(100),
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () => _selectDate(context),
                    child: Text(
                      'Date',
                      style: GoogleFonts.aldrich(),
                    ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                style: GoogleFonts.alata(),
                textAlign: TextAlign.center,
                controller: title,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(45),
                      borderSide:
                          const BorderSide(color: Colors.black, width: 5.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(45),
                      borderSide:
                          BorderSide(color: Colors.grey[700]!, width: 5.0),
                    ),
                    hintText: isEdit == true
                        ? list[index!].title
                        : 'Enter your title here'),
                onSubmitted: (_) {
                  // print(title.text);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                style: GoogleFonts.alata(),
                textAlign: TextAlign.center,
                controller: description,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(45),
                      borderSide:
                          const BorderSide(color: Colors.black, width: 5.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(45),
                      borderSide:
                          BorderSide(color: Colors.grey[700]!, width: 5.0),
                    ),
                    hintText: isEdit == true
                        ? list[index!].description
                        : 'Enter your description here'),
                onSubmitted: (_) {
                  // print(description.text);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    title.clear();
                    description.clear();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 145,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(45),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Close",
                        style: GoogleFonts.alata(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (isEdit == true) {
                      if (title.text != '') {
                        list[index!].title = title.text;
                      }
                      if (description.text != '') {
                        list[index!].description = description.text;
                      }
                      if (birthdayDate.text != '') {
                        list[index!].birthdayDate = selectedDate;
                      }
                    } else {
                      list.add(
                        Notes(
                          title: title.text,
                          description: description.text,
                          birthdayDate: selectedDate,
                          noteId: id,
                        ),
                      );
                      id++;
                    }
                    title.clear();
                    description.clear();
                    birthdayDate.clear();
                    selectedDate = DateTime.now();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 145,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(45),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Submit',
                        style: GoogleFonts.alata(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
