import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hidden_hiding_app/controller/secret_vault_controller.dart';
import 'package:hidden_hiding_app/preferences.dart';
import 'package:hidden_hiding_app/screens/SecretVault/settings_screen.dart';
import 'package:hidden_hiding_app/screens/SecretVault/vault_main_screen.dart';
import 'package:hidden_hiding_app/screens/WordGame/game_screen.dart';
import 'package:hidden_hiding_app/themes/dark.dart';

import 'controller/game_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences().init();
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }
  Get.put(GameController());
  Get.put(SecretVaultController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'World Bender',
      debugShowCheckedModeBanner: false,
      theme: DarkTheme.get,
      initialRoute: '/GameScreen',
      getPages: [
        GetPage(
          name: '/VaultMainScreen',
          page: () => const VaultMainScreen(),
        ),
        GetPage(
          name: '/SettingsScreen',
          page: () => const SettingsScreen(),
        ),
        GetPage(
          name: '/GameScreen',
          page: () => const GameScreen(),
        ),
      ],
    );
  }
}
