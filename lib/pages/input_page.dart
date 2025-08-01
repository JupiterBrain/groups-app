import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groups_v4/models/input_card.dart';
import 'package:groups_v4/utils.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final TextEditingController _defaultCapacityInputController =
      TextEditingController(text: '15');
  final TextEditingController _nrOfChoicesInputController =
      TextEditingController(text: '3');

  int nrOfChoices = 2;
  bool useDefaultCapacity = false;
  int defaultCapacity = 15;
  bool expandRuleset = false;
  bool allowDuplicates = false;
  bool allowEmpty = false;
  bool allowExcess = false;
  bool randomRemaining = false;

  Spreadsheet? groupsTable;
  Spreadsheet? itemsTable;
  Strings groupsErrors = [];
  Strings itemsErrors = [];
  bool readyToStart = false;
  bool readyToValidate = false;

  @override
  void dispose() {
    _defaultCapacityInputController.dispose();
    _nrOfChoicesInputController.dispose();
    super.dispose();
  }

  void importGroupsFromClipboard() async {
    Spreadsheet groupsTable =
        Spreadsheet.ofClipboardString(await getClipboardData());

    if (groupsTable.rows.isEmpty) return;

    groupsTable.prefixID();
    if (useDefaultCapacity) groupsTable.addGlobalCapacity(defaultCapacity);

    setState(() {
      this.groupsTable = groupsTable;
    });
  }

  void importItemsFromClipboard() async {
    Spreadsheet itemsTable =
        Spreadsheet.ofClipboardString(await getClipboardData());

    if (itemsTable.rows.isEmpty) return;

    itemsTable.prefixID();

    setState(() {
      this.itemsTable = itemsTable;
    });
  }

  /* void validateInputs() {
    parse()
  } */

  void startAlgorithm() {
    Navigator.pushNamed(context, '/output', arguments: ());
  }

  void updateState() {
    readyToStart = groupsTable != null &&
        itemsTable != null &&
        groupsErrors.isEmpty &&
        itemsErrors.isEmpty;
    readyToValidate =
        !readyToStart && groupsTable != null && itemsTable != null;
  }

  @override
  Widget build(BuildContext context) {
    updateState();

    return Scaffold(
      appBar: AppBar(title: const Text('Eingabe')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...buildOptions(),
                const SizedBox(height: 16),
                buildExtendedOptionsCard(),
                const SizedBox(height: 64),
                buildGroupsInputCard(),
                const SizedBox(height: 16),
                buildItemsInputCard(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: readyToStart
          ? FloatingActionButton.extended(
              onPressed: () => startAlgorithm(),
              label: const Row(
                children: [
                  Text('Zuordnen'),
                  SizedBox(width: 8),
                  Icon(
                    Icons.groups_2,
                    size: 28,
                  ),
                ],
              ))
          : readyToValidate
              ? FloatingActionButton.extended(
                  onPressed: () => {} /*validateInputs()*/,
                  label: const Row(children: [
                    Text('Eingaben prüfen'),
                    SizedBox(width: 8),
                    Icon(Icons.checklist),
                  ]),
                )
              : null,
    );
  }

  List<Widget> buildOptions() {
    return [
      Text('Optionen', style: Theme.of(context).textTheme.titleMedium),
      TextField(
        decoration: const InputDecoration(
          labelText: 'Anzahl an Wahlen',
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(2),
          FilteringTextInputFormatter.digitsOnly
        ],
        controller: _nrOfChoicesInputController,
        onSubmitted: (value) {
          int x = int.tryParse(value) ?? 3;

          setState(() {
            if (x < 2) {
              x = 2;
              _nrOfChoicesInputController.text = '2';
            } else if (x > 15) {
              x = 15;
              _nrOfChoicesInputController.text = '15';
            }

            nrOfChoices = x;
          });
        },
      ),
      CheckboxListTile(
        title: const Text('Globale Gruppenkapazität verwenden'),
        value: useDefaultCapacity,
        onChanged: (val) => setState(() => useDefaultCapacity = val!),
      ),
      if (useDefaultCapacity)
        TextField(
          decoration: const InputDecoration(
            labelText: 'Globale Gruppenkapazität',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            LengthLimitingTextInputFormatter(2),
            FilteringTextInputFormatter.digitsOnly
          ],
          controller: _defaultCapacityInputController,
          onSubmitted: (value) {
            int x = int.tryParse(value) ?? 3;

            setState(() {
              if (x < 2) {
                x = 2;
                _defaultCapacityInputController.text = '2';
              }

              defaultCapacity = x;
            });
          },
        ),
    ];
  }

  Widget buildExtendedOptionsCard() {
    return Card(
      child: ExpansionTile(
        title: Text('Erweiterte Optionen',
            style: Theme.of(context).textTheme.titleSmall),
        children: [
          CheckboxListTile(
            title: const Text('Doppelte Wahlen erlauben'),
            value: allowDuplicates,
            onChanged: (val) => setState(() => allowDuplicates = val!),
          ),
          CheckboxListTile(
            title: const Text('Leere Wahlen erlauben'),
            value: allowEmpty,
            onChanged: (val) => setState(() => allowEmpty = val!),
          ),
          CheckboxListTile(
            title: const Text('Elementüberschuss erlauben'),
            value: allowExcess,
            onChanged: (val) => setState(() => allowExcess = val!),
          ),
          CheckboxListTile(
            title: const Text('Unzuweisbare zufällig zuweisen'),
            value: randomRemaining,
            onChanged: (val) => setState(() => randomRemaining = val!),
          ),
        ],
      ),
    );
  }

  Widget buildGroupsInputCard() {
    return InputCard(
      "Gruppen",
      importGroupsFromClipboard,
      groupsTable,
      groupsErrors,
    );
  }

  Widget buildItemsInputCard() {
    return InputCard(
      "Element",
      importItemsFromClipboard,
      itemsTable,
      itemsErrors,
    );
  }
}
