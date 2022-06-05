import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_hiding_app/screens/BirthdayReminder/birthdaylist.dart';
import 'package:intl/intl.dart';

import 'models/notes.dart';

class BirthdayList extends StatefulWidget {
  const BirthdayList({Key? key}) : super(key: key);

  @override
  State<BirthdayList> createState() => _BirthdayListState();
}

class _BirthdayListState extends State<BirthdayList> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController birthdayDate = TextEditingController();
  DateTime selectedDate = DateTime.now();
  BirthdayListVar birthdayList = BirthdayListVar();

  bool isEdit = false;
  static int id = 1;
  @override
  Widget build(BuildContext context) {
    double? screenHeight = MediaQuery.of(context).size.height;
    double? screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.orange[50],
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 25,
              ),
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(45),
              bottomRight: Radius.circular(45),
            ),
          ),
          backgroundColor: Colors.brown[600],
          title: Text(
            'Birthday List',
            style: GoogleFonts.aldrich(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SizedBox(
          height: screenHeight,
          child: ListView.builder(
            itemCount: birthdayList.list.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                width: screenWidth,
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 40,
                          width: 160,
                          decoration: BoxDecoration(
                            color: Colors.amber[50],
                            border: Border.all(
                              color: Colors.brown[600]!,
                              width: 4,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 40,
                                width: 15,
                                decoration: BoxDecoration(
                                  color: Colors.brown[600],
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    bottomLeft: Radius.circular(30),
                                  ),
                                ),
                              ),
                              Text(
                                DateFormat.yMd().format(
                                    birthdayList.list[index].birthdayDate!),
                                style: GoogleFonts.aldrich(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                height: 40,
                                width: 15,
                                decoration: BoxDecoration(
                                  color: Colors.brown[600]!,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    bottomRight: Radius.circular(30),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 10,
                          width: 10,
                          color: Colors.brown[600],
                        ),
                        SizedBox(
                          width: 306,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.amber[50],
                              border: Border.all(
                                color: Colors.brown[600]!,
                                width: 4,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      'Name: ${birthdayList.list[index].title!}',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.aldrich(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        'Description:',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.aldrich(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        birthdayList.list[index].description!,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.aldrich(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                birthdayList.list
                                                    .removeAt(index);
                                              });
                                            },
                                            child: Container(
                                              width: 145,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: Colors.brown[600]!,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(5),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Delete",
                                                  style: GoogleFonts.alata(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
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
                                            child: Container(
                                              width: 145,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: Colors.brown[600]!,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(5),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Edit",
                                                  style: GoogleFonts.alata(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'AddNote',
          backgroundColor: Colors.brown[600],
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
      firstDate: DateTime(DateTime.now().year - 1000),
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
            colorScheme: ColorScheme.light(
              primary: Colors.brown[600]!, // header background color
              onPrimary: Colors.white, // header text color
              background: Colors.orange[50]!,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.brown[800], // button text color
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
      backgroundColor: Colors.amber[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
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
              decoration: BoxDecoration(
                  color: Colors.brown[600]!,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
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
                              BorderSide(color: Colors.brown[600]!, width: 5.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(45),
                          borderSide:
                              BorderSide(color: Colors.brown[400]!, width: 5.0),
                        ),
                        hintText: isEdit == true
                            ? DateFormat.yMd()
                                .format(birthdayList.list[index!].birthdayDate!)
                            : DateFormat.yMd().format(selectedDate)),
                    style: GoogleFonts.alata(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    controller: birthdayDate,
                    readOnly: true,
                  ),
                ),
                ElevatedButton(
                    style: TextButton.styleFrom(
                      fixedSize: const Size.fromWidth(100),
                      backgroundColor: Colors.brown[600],
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
                style: GoogleFonts.alata(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                controller: title,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(45),
                      borderSide:
                          BorderSide(color: Colors.brown[600]!, width: 5.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(45),
                      borderSide:
                          BorderSide(color: Colors.brown[400]!, width: 5.0),
                    ),
                    hintText: isEdit == true
                        ? birthdayList.list[index!].title
                        : 'Enter a name here'),
                onSubmitted: (_) {
                  // print(title.text);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                style: GoogleFonts.alata(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                controller: description,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(45),
                      borderSide:
                          BorderSide(color: Colors.brown[600]!, width: 5.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(45),
                      borderSide:
                          BorderSide(color: Colors.brown[400]!, width: 5.0),
                    ),
                    hintText: isEdit == true
                        ? birthdayList.list[index!].description
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
                    decoration: BoxDecoration(
                      color: Colors.brown[600]!,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
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
                        birthdayList.list[index!].title = title.text;
                      }
                      if (description.text != '') {
                        birthdayList.list[index!].description =
                            description.text;
                      }
                      if (birthdayDate.text != '') {
                        birthdayList.list[index!].birthdayDate = selectedDate;
                      }
                    } else {
                      birthdayList.list.add(
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
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 145,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.brown[600]!,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(10),
                        )),
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
