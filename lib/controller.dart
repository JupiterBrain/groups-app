import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:groups_v4/algorithm/algorithm.dart' as algorithm;
import 'package:groups_v4/algorithm/parser.dart' as parser;
import 'package:groups_v4/utils.dart';

var viewController = ViewController();

class ViewController {
  var nrOfChoices = 3.rv;
  var useDefaultCapacity = false.rv;
  var defaultCapacity = 15.rv;

  var allowDuplicates = false.rv;
  var allowEmpty = false.rv;
  var allowExcess = false.rv;
  //TODO implement random remaining
  var randomRemaining = false.rv;
  //TODO null initializer is not reassignable to Spreadsheet
  var groupsTable = RV<Spreadsheet?>(null);
  var itemsTable = RV<Spreadsheet?>(null);
  var groupsErrors = <String>[].rv;
  var itemsErrors = <String>[].rv;

  var groups = RV<Groups?>(null);
  var items = RV<Items?>(null);

  var readyToStart = false.rv;

  var unassignable = RV<Items?>(null);

  var outputTable = RV<Spreadsheet?>(null);

  void importGroupsFromClipboard() async {
    Spreadsheet groupsTable =
        Spreadsheet.ofClipboardString(await getClipboardData());

    if (groupsTable.rows.isEmpty) return;

    groupsTable.prefixID();
    //TODO add ~useDefaultCapacity to reactive dependencies
    if (~useDefaultCapacity) groupsTable.addGlobalCapacity(~defaultCapacity);
    this.groupsTable << groupsTable;
  }

  void importItemsFromClipboard() async {
    Spreadsheet itemsTable =
        Spreadsheet.ofClipboardString(await getClipboardData());

    if (itemsTable.rows.isEmpty) return;

    itemsTable.prefixID();
    this.itemsTable << itemsTable;
  }

  void parseInput() {
    if (~groupsTable == null || ~itemsTable == null) return;

    var result = parser.parse(
        ~nrOfChoices, (~groupsInput)!.rows, (~itemsInput)!.rows,
        defaultCapacity: ~useDefaultCapacity ? ~defaultCapacity : null,
        allowDuplicates: ~allowDuplicates,
        allowEmpty: ~allowEmpty,
        allowExcess: ~allowExcess);

    switch (result) {
      case Ok(value: (var groups, var items)):
        this.groups << groups;
        this.items << items;
        groupsErrors << [];
        itemsErrors << [];
        readyToStart << true;
      case Error(error: (var groupsErrors, var itemsErrors)):
        groups << null;
        items << null;
        this.groupsErrors << groupsErrors;
        this.itemsErrors << itemsErrors;
        readyToStart << false;
    }
  }

  void startAlgorithm(BuildContext context) {
    if (!~readyToStart) return;

    unassignable << algorithm.performAlgorithm((~items)!).toList();
    outputTable << parser.assembleOutputTable((~items)!);

    Navigator.pushNamed(context, '/output');
  }

  ViewController() {
    RV.listen([
      groupsTable,
      itemsTable,
      nrOfChoices,
      allowDuplicates,
      allowEmpty,
      allowExcess
    ], parseInput);
  }
}
