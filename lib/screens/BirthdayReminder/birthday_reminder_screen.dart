import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_hiding_app/screens/BirthdayReminder/birthdaylist.dart';
import 'package:intl/intl.dart';

class BirthdayReminderScreen extends StatefulWidget {
  const BirthdayReminderScreen({Key? key}) : super(key: key);

  @override
  _BirthdayReminderScreenState createState() => _BirthdayReminderScreenState();
}

class _BirthdayReminderScreenState extends State<BirthdayReminderScreen> {
  BirthdayListVar birthdayList = BirthdayListVar();
  @override
  Widget build(BuildContext context) {
    double? screenHeight = MediaQuery.of(context).size.height;
    double? screenWidth = MediaQuery.of(context).size.width;
    // double appBarheight = MediaQuery.of(context).padding.top + kToolbarHeight;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.orange[50],
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(45),
              bottomRight: Radius.circular(45),
            ),
          ),
          backgroundColor: Colors.brown[600],
          title: Text(
            'Birthday Reminder',
            style: GoogleFonts.aldrich(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          height: screenHeight,
          child: ListView.builder(
            itemCount: birthdayList.list.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                width: screenWidth,
                child: Column(
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 210),
                          width: double.maxFinite,
                          height: 60,
                          color: Colors.orange[300],
                        ),
                        Image.asset(
                          'assets/birthday_reminder/images/cake.png',
                          scale: 2,
                        ),
                        Positioned(
                          top: 30,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 175),
                                child: Image.asset(
                                  'assets/birthday_reminder/images/candle.png',
                                  scale: 6,
                                ),
                              ),
                              Image.asset(
                                'assets/birthday_reminder/images/candle.png',
                                scale: 6,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 7,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 181),
                                child: Image.asset(
                                  'assets/birthday_reminder/images/candle_flame.gif',
                                  scale: 12,
                                ),
                              ),
                              Image.asset(
                                'assets/birthday_reminder/images/candle_flame.gif',
                                scale: 12,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 120,
                          child: Container(
                            height: 70,
                            width: 170,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              border: Border.all(
                                color: Colors.amber[100]!,
                                width: 4,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: FittedBox(
                                      child: Text(
                                        DateFormat.yMd().format(birthdayList
                                            .list[index].birthdayDate!),
                                        style: GoogleFonts.aldrich(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  FittedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        birthdayList.list[index].title!,
                                        style: GoogleFonts.aldrich(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'NoteList',
              backgroundColor: Colors.brown[600],
              onPressed: () {
                Navigator.of(context)
                    .pushNamed('/BirthdayListScreen')
                    .then((_) {
                  setState(() {});
                });
              },
              child: const Icon(Icons.list_alt),
            ),
          ],
        ),
      ),
    );
  }
}
