import 'package:flutter/material.dart';
import 'package:groups_v4/algorithm/classes.dart';
import 'package:groups_v4/algorithm/parser.dart';
import 'package:groups_v4/models/table.dart';
import 'package:groups_v4/utils.dart';

class OutputPage extends StatefulWidget {
  const OutputPage({super.key});

  @override
  State<OutputPage> createState() => _OutputPageState();
}

class _OutputPageState extends State<OutputPage> {
  late Groups groups;
  late Items items;
  late Items unassignable;

  late Spreadsheet outputTable;

  void extractAlgorithmOutput(BuildContext context) {
    var AlgorithmOutput(:groups, :items, :unassignable) =
        ModalRoute.of(context)!.settings.arguments as AlgorithmOutput;
    this.groups = groups;
    this.items = items;
    this.unassignable = unassignable;

    outputTable = assembleOutputTable(items);
  }

  @override
  Widget build(BuildContext context) {
    extractAlgorithmOutput(context);

    //TODO add other output tables
    return Scaffold(
      appBar: AppBar(title: const Text('Ausgabe')),
      body: SingleChildScrollView(
        child: Center(
          child: SpreadsheetTable(outputTable),
        ),
      ),
    );
  }
}
