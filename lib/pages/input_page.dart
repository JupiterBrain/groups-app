import 'package:flutter/material.dart';
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
  List<String> groupsErrors = [];
  List<String> itemsErrors = [];
  bool inputsValid = false;
  bool readyToStart = false;

  @override
  void dispose() {
    _defaultCapacityInputController.dispose();
    _nrOfChoicesInputController.dispose();
    super.dispose();
  }

  void validateInputs() {
    setState(() {
      inputsValid = true;
    });
  }

  void importGroupsFromClipboard() async {
    Spreadsheet groupsTable =
        Spreadsheet.ofClipboardString(await getClipboardData());
    groupsTable.prefixID();
    if (useDefaultCapacity) groupsTable.addGlobalCapacity(defaultCapacity);

    setState(() {
      this.groupsTable = groupsTable;
    });
  }

  void importItemsFromClipboard() async {
    Spreadsheet itemsTable =
        Spreadsheet.ofClipboardString(await getClipboardData());
    itemsTable.prefixID();

    setState(() {
      this.itemsTable = itemsTable;
    });
  }

  void updateState() {
    readyToStart = groupsTable != null && itemsTable != null;
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
              onPressed: () => Navigator.pushNamed(context, '/output'),
              label: const Text('Algorithmus starten'))
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
        controller: _nrOfChoicesInputController,
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
          controller: _defaultCapacityInputController,
        )
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
