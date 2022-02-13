import 'package:flutter/material.dart';
import 'package:hidden_hiding_app/screens/BirthdayReminder/birthday_reminder_screen.dart';
import 'package:hidden_hiding_app/screens/Calculator/calculator_screen.dart';
import 'package:hidden_hiding_app/screens/FlashLight/flashlight_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hidden Hide App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/BirthdayReminderScreen',
      routes: {
        '/CalculatorScreen': (context) => const CalculatorScreen(),
        '/FlashLightScreen': (context) => const FlashLightScreen(),
        '/BirthdayReminderScreen': (context) => const BirthdayReminderScreen(),
      },
    );
  }
}
