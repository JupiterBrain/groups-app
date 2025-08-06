import 'package:flutter/material.dart';
import 'package:groups_v4/components/reactive/reactive_wrapper.dart';
import 'package:groups_v4/controller.dart';
import 'package:groups_v4/components/table.dart';

class OutputPage extends StatefulWidget {
  const OutputPage({super.key});

  @override
  State<OutputPage> createState() => _OutputPageState();
}

class _OutputPageState extends State<OutputPage> {
  @override
  Widget build(BuildContext context) {
    //TODO add other output tables
    return Scaffold(
      appBar: AppBar(title: const Text('Ausgabe')),
      body: SingleChildScrollView(
        child: Center(
          child: ReactiveWrapper(
            reactiveValues: [viewController.outputTable],
            builder: (context) =>
                SpreadsheetTable((~viewController.outputTable)!),
          ),
        ),
      ),
    );
  }
}
