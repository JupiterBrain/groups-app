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

  var groupsInput = RV<Spreadsheet?>(null);
  var itemsInput = RV<Spreadsheet?>(null);
  var groupsTable = RV<Spreadsheet?>(null);
  var itemsTable = RV<Spreadsheet?>(null);

  var groupsErrors = <String>[].rv;
  var itemsErrors = <String>[].rv;

  var groups = RV<Groups?>(null);
  var items = RV<Items?>(null);

  var readyToStart = false.rv;

  var unassignable = RV<Items?>(null);

  var outputPageTab = 0.rv;

  var groupOverviewTable = RV<Spreadsheet?>(null);
  var assignmentTable = RV<Spreadsheet?>(null);
  var analysisTable = RV<Spreadsheet?>(null);

  void importGroupsFromClipboard() async {
    var groupsInput = Spreadsheet.ofClipboardString(await getClipboardData());

    if (groupsInput == null || groupsInput.isEmpty) {
      return;
    }

    this.groupsInput << groupsInput;
  }

  void importItemsFromClipboard() async {
    var itemsInput = Spreadsheet.ofClipboardString(await getClipboardData());

    if (itemsInput == null || itemsInput.isEmpty) {
      return;
    }

    this.itemsInput << itemsInput;
  }

  void parseInput() {
    if (~groupsInput == null || ~itemsInput == null) return;

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

    var _ = algorithm.performAlgorithm((~items)!);
    assignmentTable << parser.assembleOutputTable((~items)!);
    groupOverviewTable << parser.assembleGroupOverwiewTable((~groups)!);

    readyToStart << false;

    Navigator.pushNamed(context, '/output');
  }

  ViewController() {
    RV.listen([
      groupsInput,
      itemsInput,
      nrOfChoices,
      useDefaultCapacity,
      defaultCapacity,
      allowDuplicates,
      allowEmpty,
      allowExcess
    ], parseInput);

    RV.listen([
      groupsInput,
      useDefaultCapacity,
      defaultCapacity,
    ], () {
      if (~groupsInput == null) return;

      var groupsTable = Spreadsheet.from((~groupsInput)!)..prefixID();

      if (~useDefaultCapacity) groupsTable.addGlobalCapacity(~defaultCapacity);

      this.groupsTable << groupsTable;
    });

    RV.listen([itemsInput], () {
      if (~itemsInput == null) return;
      itemsTable << Spreadsheet.from((~itemsInput)!..prefixID());
    });
  }
}
