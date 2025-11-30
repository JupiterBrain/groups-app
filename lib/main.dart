import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:groups_app/update_checker.dart';
import 'package:groups_app/pages/input_page.dart';
import 'package:groups_app/pages/output_page.dart';

//FIXME still doesn't work with newest flutter version (on linux mint) (Accessing text field results in program crash)
// Fixed by disabling the virtual keyboard (accessibility settings)

//https://docs.flutter.dev/platform-integration/windows/building#supporting-windows-ui-guidelines

//annotate all instances of immutable datastructures
//TODO algorithm iterations/improve algorithm
//minGroupSize
//balanceGroupSizes

// package:two_dimensional_scrollables

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
  Widget build(BuildContext context) => MaterialApp(
    title: 'Groups',
    theme: .new(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
    ),
    home: ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: const InputPage(),
    ),
    routes: {
      '/input': (context) => const InputPage(),
      '/output': (context) => const OutputPage(),
    },
    debugShowCheckedModeBanner: false,
  );
}

class MyWindowListener with WindowListener {
  @override
  void onWindowClose() {
    exit(0);
  }
}
