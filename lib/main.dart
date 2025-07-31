import 'package:flutter/material.dart';
import 'package:groups_v4/pages/input_page.dart';
import 'package:groups_v4/pages/output_page.dart';

//package:window_manager

//minGroupSize
//balanceGroupSizes

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Groups',
      theme: ThemeData(primaryColor: Colors.blue, brightness: Brightness.light),
      home: const InputPage(),
      routes: {
        '/input': (context) => const InputPage(),
        '/output': (context) => const OutputPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
