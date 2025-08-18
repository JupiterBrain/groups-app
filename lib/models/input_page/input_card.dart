import 'package:flutter/material.dart';
import 'package:groups_v4/components/biaxial_scroll_view.dart';
import 'package:groups_v4/components/error_container.dart';
import 'package:groups_v4/components/list_builder.dart';
import 'package:groups_v4/components/reactive/reactive_wrapper.dart';
import 'package:groups_v4/components/table.dart';
import 'package:groups_v4/components/warning_container.dart';
import 'package:groups_v4/utils.dart';

class InputCard extends StatelessWidget {
  final String titlePrefix;
  final Function() pasteAction;
  final RV<Spreadsheet?> table;
  final RV<Strings> errors;
  final String formatInfo;

  const InputCard({
    required this.titlePrefix,
    required this.pasteAction,
    required this.table,
    required this.errors,
    required this.formatInfo,
    super.key,
  });

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
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 8,
              children: [
                Text(
                  '${titlePrefix}daten',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                FittedBox(
                  child: Row(
                    children: [
                      FilledButton(
                        onPressed: pasteAction,
                        child: const Row(
                          children: [
                            Icon(Icons.paste),
                            SizedBox(width: 8),
                            Text('Einfügen'),
                          ],
                        ),
                      ),
                      //TODO tutorial/info
                      IconButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/tutorial'),
                        icon: const Icon(Icons.info),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ReactiveWrapper(
              reactiveValues: [table],
              builder: (context) {
                if (~table == null) {
                  return WarningContainer(
                    children: [
                      Text(
                          'Bitte ${titlePrefix}daten mit Überschriften aus Tabelle einfügen.'),
                      Text(
                        formatInfo,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            ReactiveWrapper(
              reactiveValues: [errors],
              builder: (context) {
                if ((~errors).isNotEmpty) {
                  return ErrorContainer(
                    child: SingleChildScrollView(
                      child: ListBuilder(
                        list: ~errors,
                        builder: (context, item) => Text(
                          item,
                          style: TextStyle(color: Colors.red.shade900),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            ReactiveWrapper(
              reactiveValues: [table],
              builder: (context) {
                if (~table != null) {
                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 400),
                      child: BiaxialScrollView(
                        child: SpreadsheetTable((~table)!),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
