import 'package:groups_v4/algorithm/classes.dart';
import 'package:groups_v4/utils.dart';

Result<(List<Group>, List<Item>), (List<String>, List<String>)> parse(
  int nrOfChoices,
  TRows groupsTable,
  TRows itemsTable, {
  bool allowDuplicates = false,
  bool allowEmpty = false,
  bool allowExcess = false,
}) {
  var (groups, groupsErrors) = parseGroups(groupsTable);
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

(Map<String, Group>, List<String>) parseGroups(TRows groupsTable) {
  List<String> groupsErrors = [];
  Map<String, Group> groups = {};

  void error(String error) {
    groupsErrors.add(error);
  }

  void parseGroup(List<String> row, int id) {
    if (row.length < 2) {
      return error("Error in row $id: A group must have columns for at least "
          "an identifier and a capacity.");
    }

    var identifier = row.first;

    if (groups.containsKey(identifier)) {
      return error("Error in row $id: A groups identifier must be unique.");
    }

    var capacity = int.tryParse(row.last);
    if (capacity == null) {
      return error("Error in row $id: '${row.last}' is not a valid integer.");
    }

    var description = row.sublist(2, row.length - 1);

    groups[identifier] = Group(id, identifier, description, capacity);
  }

  for (int i = 0; i < groupsTable.length; i++) {
    var row = groupsTable[i];
    parseGroup(row, i + 1);
  }

  return (groups, groupsErrors);
}

(List<Item>, List<String>) parseItems(
    int nrOfChoices, TRows itemsTable, Map<String, Group> groups,
    {bool allowDuplicates = false, bool allowEmpty = false}) {
  List<String> itemsErrors = [];
  List<Item> items = [];

  void error(String error) {
    itemsErrors.add(error);
  }

  void parseItem(List<String> row, int id) {
    if (row.length < 1 + nrOfChoices) {
      return error(
          "Error in row $id: Element must have columns for all choices.");
    }

    var description = row.sublist(1, row.length - nrOfChoices);

    var choices = <Group>[];

    for (int k = 0; k < nrOfChoices; k++) {
      var identifier = row[row.length - nrOfChoices + k];

      if (identifier.isBlank) {
        if (allowEmpty && k > 0) {
          choices.add(choices[k - 1]);
          continue;
        } else {
          return error("Error in row $id: choice ${k + 1} is empty.");
        }
      }

      var group = groups[identifier];

      if (group == null) {
        return error("Error in row $id: group '$identifier' does not exist.");
      }
      if (choices.contains(group) && !allowDuplicates) {
        return error("Error in line $id: choice ${k + 1} is a duplicate.");
      }

      choices.add(group);
    }

    items.add(Item(id, description, choices));
  }

  for (int i = 0; i < itemsTable.length; i++) {
    var row = itemsTable[i];
    parseItem(row, i + 1);
  }

  //Randomize order
  items.shuffle();

  return (items, itemsErrors);
}
