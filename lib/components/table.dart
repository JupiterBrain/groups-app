import 'package:flutter/material.dart';
import 'package:groups_v4/utils.dart';

class SpreadsheetTable extends StatelessWidget {
  final Spreadsheet spreadsheet;

  const SpreadsheetTable(this.spreadsheet, {super.key});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: spreadsheet.columns
          .map((title) => DataColumn(label: Text(title)))
          .toList(),
      rows: spreadsheet.rows
          .map(
            (row) => DataRow(
              cells: row.map((cell) => DataCell(Text(cell))).toList(),
            ),
          )
          .toList(),
    );
  }
}
