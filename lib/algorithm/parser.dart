import 'package:groups_v4/algorithm/classes.dart';
import 'package:groups_v4/utils.dart';

Result<(Groups, Items), (Strings, Strings)> parse(
  int nrOfChoices,
  TRows groupsTable,
  TRows itemsTable, {
  int? defaultCapacity,
  bool allowDuplicates = false,
  bool allowEmpty = false,
  bool allowExcess = false,
}) {
  int? Function(String) capacityProvider = defaultCapacity == null
      ? (field) => int.tryParse(field)
      : (_) => defaultCapacity;

  var (groups, groupsErrors) = parseGroups(groupsTable, capacityProvider);
  var (items, itemsErrors) = parseItems(nrOfChoices, itemsTable, groups,
      allowDuplicates: allowDuplicates, allowEmpty: allowEmpty);

  var totalCapacity = groups.values
      .map(
        (group) => group.capacity,
      )
      .sum();

  if (totalCapacity < items.length && !allowExcess) {
    groupsErrors.insert(0, "Not enough capacity");
  }

  if (groupsErrors.isNotEmpty || itemsErrors.isNotEmpty) {
    return Result.error((groupsErrors, itemsErrors));
  } else {
    return Result.ok((groups.values.toList(), items));
  }
}

(Map<String, Group>, Strings) parseGroups(
  TRows groupsTable,
  int? Function(String) capacityProvider,
) {
  Strings groupsErrors = [];
  Map<String, Group> groups = {};

  void error(String error) {
    groupsErrors.add(error);
  }

  void parseGroup(Strings row, int id) {
    var hadError = false;

    if (row.length < 2) {
      return error("Error in row $id: A group must have columns for at least "
          "an identifier and a capacity.");
    }

    var identifier = row[0];

    if (groups.containsKey(identifier)) {
      error("Error in row $id: A groups identifier must be unique.");
      hadError = true;
    }

    var capacity = capacityProvider(row.last);
    if (capacity == null) {
      return error("Error in row $id: '${row.last}' is not a valid integer.");
    }

    var description = row.sublist(1, row.length - 1);

    if (!hadError) {
      groups[identifier] = Group(id, identifier, description, capacity);
    }
  }

  for (int i = 0; i < groupsTable.length; i++) {
    var row = groupsTable[i];
    parseGroup(row, i + 1);
  }

  return (groups, groupsErrors);
}

(Items, Strings) parseItems(
    int nrOfChoices, TRows itemsTable, Map<String, Group> groups,
    {bool allowDuplicates = false, bool allowEmpty = false}) {
  Strings itemsErrors = [];
  Items items = [];

  void error(String error) {
    itemsErrors.add(error);
  }

  void parseItem(Strings row, int id) {
    var hadError = false;

    if (row.length < nrOfChoices) {
      return error(
          "Error in row $id: Element must have columns for all choices.");
    }

    var description = row.sublist(0, row.length - nrOfChoices);

    Groups choices = [];

    for (int k = 0; k < nrOfChoices; k++) {
      var identifier = row[row.length - nrOfChoices + k];

      if (identifier.isBlank) {
        if (allowEmpty && k > 0) {
          choices.add(choices[k - 1]);
        } else {
          error("Error in row $id: choice ${k + 1} is empty.");
          hadError = true;
        }
      }

      var group = groups[identifier];

      if (group == null) {
        error("Error in row $id: group '$identifier' does not exist.");
        hadError = true;
        continue;
      }
      if (choices.contains(group) && !allowDuplicates) {
        error("Error in line $id: choice ${k + 1} is a duplicate.");
        hadError = true;
      }

      choices.add(group);
    }

    if (!hadError) items.add(Item(id, description, choices));
  }

  for (int i = 0; i < itemsTable.length; i++) {
    var row = itemsTable[i];
    parseItem(row, i + 1);
  }

  //Randomize order
  items.shuffle();

  return (items, itemsErrors);
}

Spreadsheet assembleAssignmentTable(Items items, Strings itemsOutputHeadline) {
  return Spreadsheet.of(
    itemsOutputHeadline,
    (List<Item>.from(items)..sort()).map((e) => e.row).toList(),
  )!;
}

Spreadsheet assembleGroupOverwiewTable(
    Groups groups, Strings groupsOutputHeadline) {
  return Spreadsheet.of(
    groupsOutputHeadline,
    groups.map((e) => e.row).toList(),
  )!;
}

Spreadsheet assembleDiagnosticsTable(
    Groups groups, Items items, int nrOfChoices) {
  var absolute = List.filled(nrOfChoices + 2, 0);

  for (var item in items) {
    absolute[item.assignedToIdx + 2]++;
  }

  var relative = absolute.map((e) => (e / items.length * 100).round()).toList();

  TRows table = [];

  if (absolute[1] != 0) {
    table.add(["Unzugewiesen", "${absolute[1]}", "${relative[1]}"]);
  }

  if (absolute[0] != 0) {
    table.add(["Zufällig", "${absolute[0]}", "${relative[0]}"]);
  }

  for (var i = 2; i < absolute.length; i++) {
    table.add(["${i - 1}", "${absolute[i]}", "${relative[i]}"]);
  }

  table.add(["Summe", "${items.length}", "100"]);

  return Spreadsheet.of(["Wahl", "Absolut", "%"], table)!;
}
}
