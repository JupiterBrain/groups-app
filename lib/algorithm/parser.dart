import 'package:groups_v4/algorithm/classes.dart';
import 'package:groups_v4/utils.dart';

class Parser {
  bool allowDuplicates = false;
  bool allowEmpty = false;
  bool allowExcess = false;

  int nrOfChoices = 3;
  int defaultCapacity = -1;

  late TRows groupsTable;
  late TRows itemsTable;

  late List<String> groupParsingErrors = [];
  late List<String> itemParsingErrors = [];

  late Map<String, Group> groups;
  late List<Item> items = [];
}
