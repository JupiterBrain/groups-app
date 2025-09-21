import 'package:flutter/material.dart';
import 'package:groups_app/components/reactive/reactive_wrapper.dart';
import 'package:groups_app/components/table.dart';
import 'package:groups_app/utils.dart';

class RTable extends StatelessWidget {
  final RV<Spreadsheet?> table;

  const RTable({super.key, required this.table});

  @override
  Widget build(BuildContext context) {
    if (~table != null) {
      return SingleChildScrollView(
        child: Center(
          child: ReactiveWrapper(
            reactiveValues: [table],
            builder: (context) => SpreadsheetTable((~table)!),
          ),
        ),
      );
    } else {
      return const SizedBox.expand();
    }
  }
}
