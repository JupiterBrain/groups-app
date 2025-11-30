import 'package:flutter/material.dart';
import 'package:groups_app/components/biaxial_scroll_view.dart';
import 'package:groups_app/utils.dart';

class SpreadsheetTable extends StatelessWidget {
  final Spreadsheet spreadsheet;

  const SpreadsheetTable(this.spreadsheet, {super.key});

  @override
  Widget build(BuildContext context) => BiaxialScrollView(
    child: Table(
      //TODO update table with external package
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      defaultColumnWidth: const IntrinsicColumnWidth(),
      border: TableBorder.all(color: Colors.grey, width: 1),
      children: [
        TableRow(
          children: spreadsheet.columns
              .map((title) => MyTableHeader(title))
              .toList(),
        ),
        ...(spreadsheet.rows
            .map(
              (row) => TableRow(
                children: row.map((cell) => MyTableCell(cell)).toList(),
              ),
            )
            .toList()),
      ],
    ),
  );
}

class MyTableHeader extends StatelessWidget {
  final String text;

  const MyTableHeader(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(4),
    child: Text(text, style: const TextStyle(fontWeight: .bold)),
  );
}

class MyTableCell extends StatelessWidget {
  final String text;

  const MyTableCell(this.text, {super.key});

  @override
  Widget build(BuildContext context) =>
      Container(padding: const EdgeInsets.all(4), child: Text(text));
}
