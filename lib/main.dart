import 'package:flutter/material.dart';
import 'package:hidden_hiding_app/preferences.dart';
import 'package:hidden_hiding_app/screens/SecretVault/settings_screen.dart';
import 'package:hidden_hiding_app/screens/SecretVault/vault_main_screen.dart';
import 'package:hidden_hiding_app/themes/dark.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences().init();
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
      theme: DarkTheme.get,
      initialRoute: '/VaultMainScreen',
      routes: {
        '/VaultMainScreen': (context) => const VaultMainScreen(),
        '/SettingsScreen': (context) => const SettingsScreen(),
      },
    );
  }
}
