import 'package:flutter/services.dart';
import 'package:groups_v4/algorithm/classes.dart';

typedef Strings = List<String>;
typedef TRows = List<Strings>;
typedef Groups = List<Group>;
typedef Items = List<Item>;

class Spreadsheet {
  Strings columns;
  TRows rows;

  Spreadsheet(this.columns, this.rows) {
    if (!isSpreadsheet()) throw "Spreadsheet condition not satisfied";
  }

  Spreadsheet.ofRows(TRows table) : this(table.first, table.sublist(1));
  Spreadsheet.ofCSVString(String table) : this.ofRows(csvToSpreadsheet(table));
  Spreadsheet.ofClipboardString(String table)
      : this.ofRows(clipboardToSpreadsheet(table));

  TRows get rowsWithTitles => [columns, ...rows];

  bool isSpreadsheet() {
    int x = columns.length;

    if (x <= 0) return false;

    for (var row in rows) {
      if (row.length != x) return false;
    }

    return true;
  }

  void prefixID() {
    columns.insert(0, "ID");
    for (int id = 0; id < rows.length; id++) {
      rows[id].insert(0, "${id + 1}");
    }
  }

  void addGlobalCapacity(int globalCapacity) {
    columns.add("Kapazität");
    for (var row in rows) {
      row.add("$globalCapacity");
    }
  }

  @override
  String toString() => rowsWithTitles.map((row) => row.join(',')).join('\n');

  //TODO update spreadsheet parser
  static TRows csvToSpreadsheet(String data) {
    return data
        .trim()
        .split('\n')
        .map((line) => line.split(',').map((e) => e.trim()).toList())
        .toList();
  }

  static TRows clipboardToSpreadsheet(String data) {
    return data
        .trim()
        .split('\n')
        .map((line) => line.split('\t').map((e) => e.trim()).toList())
        .toList();
  }
}

void prefixID(TRows table) {
  table.first.insert(0, "ID");
  final rows = table.sublist(1);
  for (int id = 1; id <= rows.length; id++) {
    rows[id].insert(0, "$id");
  }
}

void addGlobalCapacity(TRows groupsTable, int globalCapacity) {
  groupsTable.first.add('Kapazität');
  groupsTable.sublist(1).forEach((row) => row.add(globalCapacity.toString()));
}

String toSpreadsheetString(TRows data) {
  return data.map((row) => row.join(',')).join('\n');
}

Future<String> getClipboardData() async {
  ClipboardData? data = await Clipboard.getData('text/plain');
  if (data == null) return "";

  return data.text ?? "";
}

abstract interface class CSVSerializable {
  String get csv;
  String csvColumns();
}

class Box<T> {
  T value;
  Set<Function(T)> callbacks = {};

  Box(this.value);

  void addListener(Function(T) callback) => callbacks.add(callback);

  void removeListerner(Function(T) callback) => callbacks.remove(callback);

  set update(T value) {
    this.value = value;
  }
}

sealed class Result<R, E> {
  const Result();

  factory Result.ok(R value) => Ok(value);
  factory Result.error(E error) => Error(error);
}

final class Ok<R, E> extends Result<R, E> {
  final R value;

  const Ok(this.value);
}

final class Error<R, E> extends Result<R, E> {
  final E error;

  const Error(this.error);
}

extension Blank on String {
  bool get isBlank => trim().isEmpty;
}

extension Sum<T extends num> on Iterable<T> {
  T sum() => reduce((sum, curr) => sum + curr as T);
}
