import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:groups_v4/update_checker.dart';
import 'package:groups_v4/pages/input_page.dart';
import 'package:groups_v4/pages/output_page.dart';
import 'package:groups_v4/pages/tutorial_dialog.dart';

//https://docs.flutter.dev/platform-integration/windows/building#supporting-windows-ui-guidelines
//https://docs.flutter.dev/platform-integration/windows/building#msix-packaging
//https://github.com/fastforgedev/fastforge

//dart:package msix
//dart:package flutter_to_debian

//add proper tutorials
//annotate all instances of immutable datastructures
//minGroupSize
//balanceGroupSizes

//TODO about dialog

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() {
  runApp(const MyApp());

  doWhenWindowReady(() {
    const initialSize = Size(450, 250);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.title = "Groups";
    appWindow.show();
  });

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
