import 'package:flutter/material.dart';
import 'package:groups_v4/pages/input_page.dart';
import 'package:groups_v4/pages/output_page.dart';
import 'package:groups_v4/pages/tutorial_dialog.dart';

//https://docs.flutter.dev/platform-integration/windows/building#supporting-windows-ui-guidelines
//https://docs.flutter.dev/platform-integration/windows/building#msix-packaging

//add proper tutorials
//annotate all instances of immutable datastructures
//minGroupSize
//balanceGroupSizes

//TODO add auto uptade checker
//TODO add basic info dialogs () => showDialog()
//TODO about dialog

void main() {
  runApp(const MyApp());
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
      home: const InputPage(),
      routes: {
        '/input': (context) => const InputPage(),
        '/output': (context) => const OutputPage(),
        '/tutorial': (context) => const TutorialDialog(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
