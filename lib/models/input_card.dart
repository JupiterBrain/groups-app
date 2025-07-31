import 'package:flutter/material.dart';
import 'package:groups_v4/models/table.dart';
import 'package:groups_v4/utils.dart';

class InputCard extends StatelessWidget {
  final String titlePrefix;
  final Function() pasteAction;
  final Spreadsheet? table;
  final List<String> errors;

  InputCard(this.titlePrefix, this.pasteAction, this.table, this.errors,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${titlePrefix}daten',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                ElevatedButton(
                  onPressed: pasteAction,
                  child: const Text('Paste'),
                ),
              ],
            ),
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
