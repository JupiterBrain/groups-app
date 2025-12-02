import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:groups_app/algorithm/algorithm.dart' as algorithm;
import 'package:groups_app/algorithm/parser.dart' as parser;
import 'package:groups_app/utils.dart';
import 'package:groups_app/utils/clipboard.dart';
import 'package:groups_app/utils/result.dart';
import 'package:groups_app/utils/spreadsheet.dart';

final viewController = ViewController();

class ViewController {
  final nrOfChoices = Reactive(3);
  final useDefaultCapacity = Reactive(false);
  final defaultCapacity = Reactive(3);

  final allowDuplicates = Reactive(false);
  final allowEmpty = Reactive(false);
  final allowExcess = Reactive(false);
  final randomRemaining = Reactive(false);

  var outputPageTab = 0;

  final groupsInput = Reactive<Spreadsheet?>(null);
  void importGroupsFromClipboard() async {
    var groupsInput = Spreadsheet.ofClipboardString(await getClipboardData());

    if (groupsInput == null || groupsInput.isEmpty) {
      return;
    }

    this.groupsInput << groupsInput;
  }

  final itemsInput = Reactive<Spreadsheet?>(null);
  void importItemsFromClipboard() async {
    var itemsInput = Spreadsheet.ofClipboardString(await getClipboardData());

    if (itemsInput == null || itemsInput.isEmpty) {
      return;
    }

    this.itemsInput << itemsInput;
  }

  final groups = Reactive<Groups?>(null);
  final items = Reactive<Items?>(null);
  final groupsErrors = Reactive<Strings>([]);
  final itemsErrors = Reactive<Strings>([]);
  final readyToStart = Reactive(false);

  void parseInput() {
    var groupsInputLocal = ~groupsInput;
    var itemsInputLocal = ~itemsInput;

    if (groupsInputLocal == null || itemsInputLocal == null) return;

    var result = parser.parse(
      ~nrOfChoices,
      groupsInputLocal.rows,
      itemsInputLocal.rows,
      defaultCapacity: ~useDefaultCapacity ? ~defaultCapacity : null,
      allowDuplicates: ~allowDuplicates,
      allowEmpty: ~allowEmpty,
      allowExcess: ~allowExcess,
    );

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

  final unassignable = Reactive<Items?>(null);
  final groupOverviewTable = Reactive<Spreadsheet?>(null);
  final assignmentTable = Reactive<Spreadsheet?>(null);
  final analysisTable = Reactive<Spreadsheet?>(null);
  void startAlgorithm(BuildContext context) {
    var groupsLocal = ~groups;
    var itemsLocal = ~items;
    var groupsOutputHeadlineLocal = ~groupsOutputHeadline;
    var itemsOutputHeadlineLocal = ~itemsOutputHeadline;

    if (!~readyToStart ||
        groupsLocal == null ||
        itemsLocal == null ||
        groupsOutputHeadlineLocal == null ||
        itemsOutputHeadlineLocal == null) {
      return;
    }

    var unassignable = algorithm.performAlgorithm(itemsLocal);

    if (~randomRemaining) algorithm.randomRemaining(groupsLocal, unassignable);

    assignmentTable <<
        parser.assembleAssignmentTable(itemsLocal, itemsOutputHeadlineLocal);
    groupOverviewTable <<
        parser.assembleGroupOverwiewTable(
          groupsLocal,
          groupsOutputHeadlineLocal,
        );
    analysisTable <<
        parser.assembleDiagnosticsTable(groupsLocal, itemsLocal, ~nrOfChoices);

    readyToStart << false;

    Navigator.pushNamed(context, '/output');
  }

  void copyCurrentResultTableToClipboard() async {
    var spreadsheet = switch (outputPageTab) {
      0 => ~groupOverviewTable,
      1 => ~assignmentTable,
      2 => ~analysisTable,
      _ => null,
    };

    if (spreadsheet == null) return;

    var clipboardString = spreadsheet.clipboardString;

    var result = await setClipboardDataPlainText(clipboardString);

    //TODO Add Feedback?
    switch (result) {
      case Ok(value: null):
      case Error(error: null):
    }
  }

  ViewController() {
    effect([
      groupsInput,
      itemsInput,
      nrOfChoices,
      useDefaultCapacity,
      defaultCapacity,
      allowDuplicates,
      allowEmpty,
      allowExcess,
    ], parseInput);
  }

  late final groupsTable = Reactive.from(
    [groupsInput, useDefaultCapacity, defaultCapacity],
    () {
      var groupsInputLocal = ~groupsInput;

      if (groupsInputLocal == null) return null;

      var groupsTable = Spreadsheet.from(groupsInputLocal)..prefixID();

      if (~useDefaultCapacity) groupsTable.addGlobalCapacity(~defaultCapacity);

      return groupsTable;
    },
  );

  late final itemsTable = Reactive.from([itemsInput], () {
    var itemsInputLocal = ~itemsInput;

    if (itemsInputLocal == null) return null;

    return Spreadsheet.from(itemsInputLocal)..prefixID();
  });

  late final groupsInputHeadline = Reactive.from([
    groupsInput,
  ], () => (~groupsInput)?.columns);

  late final itemsInputHeadline = Reactive.from([
    itemsInput,
  ], () => (~itemsInput)?.columns);

  late final groupsOutputHeadline = Reactive.from(
    [groupsInputHeadline, useDefaultCapacity],
    () {
      var groupsInputHeadlineLocal = ~groupsInputHeadline;

      if (groupsInputHeadlineLocal == null) return null;

      if ((~useDefaultCapacity)) {
        return ["ID", ...groupsInputHeadlineLocal, "Größe", "Kapazität"];
      } else {
        return [
          "ID",
          ...groupsInputHeadlineLocal.sublist(
            0,
            groupsInputHeadlineLocal.length - 1,
          ),
          "Größe",
          groupsInputHeadlineLocal.last,
        ];
      }
    },
  );

  late final itemsOutputHeadline = Reactive.from(
    [itemsInputHeadline, nrOfChoices],
    () {
      var itemsInputHeadlineLocal = ~itemsInputHeadline;

      if (itemsInputHeadlineLocal == null) return null;

      return [
        "ID",
        ...(~itemsInputHeadline)!.sublist(
          0,
          itemsInputHeadlineLocal.length - ~nrOfChoices,
        ),
        "k",
        "Gruppe",
        ...(~itemsInputHeadline)!.sublist(
          itemsInputHeadlineLocal.length - ~nrOfChoices,
        ),
      ];
    },
  );
}
