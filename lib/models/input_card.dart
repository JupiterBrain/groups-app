import 'package:flutter/material.dart';
import 'package:groups_v4/models/table.dart';
import 'package:groups_v4/utils.dart';

class InputCard extends StatelessWidget {
  final String titlePrefix;
  final Function() pasteAction;
  final Spreadsheet? table;
  final Strings errors;
  final String formatInfo;

  const InputCard(this.titlePrefix, this.pasteAction, this.table, this.errors,
      this.formatInfo,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: 20,
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              alignment: WrapAlignment.spaceBetween,
              runSpacing: 8,
              children: [
                Text(
                  '${titlePrefix}daten',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                FittedBox(
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: pasteAction,
                        child: const Row(
                          children: [
                            Icon(Icons.paste),
                            SizedBox(width: 8),
                            Text('Einfügen'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (table == null)
              Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Column(
                    children: [
                      Text(
                          'Bitte ${titlePrefix}daten mit Überschriften aus Tabelle einfügen.'),
                      Text(
                        formatInfo,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  )),
            for (String error in errors)
              Text(
                error,
                style: const TextStyle(color: Colors.red),
              ),
            if (table != null)
              Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 400),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Center(child: SpreadsheetTable(table!)),
                      ),
                    )),
              ),
          ],
        ),
      ),
    );
  }
}
