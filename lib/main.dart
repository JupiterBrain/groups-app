import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:groups_app/update_checker.dart';
import 'package:groups_app/pages/input_page.dart';
import 'package:groups_app/pages/output_page.dart';
import 'package:groups_app/pages/tutorial_dialog.dart';

//https://docs.flutter.dev/platform-integration/windows/building#supporting-windows-ui-guidelines
//https://docs.flutter.dev/platform-integration/windows/building#msix-packaging
//https://github.com/fastforgedev/fastforge

//annotate all instances of immutable datastructures
//minGroupSize
//balanceGroupSizes

//TODO about dialog

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    minimumSize: Size(450, 250),
    center: true,
    title: "Groups",
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  windowManager.addListener(MyWindowListener());

  runApp(const MyApp());

  checkForUpdate(scaffoldMessengerKey);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Groups',
      theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent)),
      home: ScaffoldMessenger(
        key: scaffoldMessengerKey,
        child: const InputPage(),
      ),
      routes: {
        '/input': (context) => const InputPage(),
        '/output': (context) => const OutputPage(),
        '/tutorial': (context) => const TutorialDialog(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyWindowListener with WindowListener {
  @override
  void onWindowClose() {
    exit(0);
  }
}
