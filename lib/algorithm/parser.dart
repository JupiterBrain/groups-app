import 'package:groups_v4/algorithm/classes.dart';
import 'package:groups_v4/utils.dart';

//TODO parse from user input spreadsheet, not from prefixed spreadsheet

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

    var identifier = row[1];

    if (groups.containsKey(identifier)) {
      error("Error in row $id: A groups identifier must be unique.");
      hadError = true;
    }

    var capacity = capacityProvider(row.last);
    if (capacity == null) {
      return error("Error in row $id: '${row.last}' is not a valid integer.");
    }

    var description = row.sublist(2, row.length - 1);

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

    if (row.length < 1 + nrOfChoices) {
      return error(
          "Error in row $id: Element must have columns for all choices.");
    }

    var description = row.sublist(1, row.length - nrOfChoices);

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

Spreadsheet assembleOutputTable(Items items) {
  //TODO add propper sorting/filters
  return Spreadsheet(items.first.csvColumns().split(','),
      items.toSet().toList().map((e) => e.csv.split(',')).toList());
}
