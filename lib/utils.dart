import 'package:flutter/services.dart';
import 'package:groups_v4/algorithm/classes.dart';

typedef Strings = List<String>;
typedef TRows = List<Strings>;
typedef Groups = List<Group>;
typedef Items = List<Item>;

class Spreadsheet {
  Strings columns;
  TRows rows;

  Spreadsheet._internal(this.columns, this.rows);
  Spreadsheet.from(Spreadsheet other)
      : this._internal(
          List<String>.from(other.columns),
          other.rows.map((Strings row) => List<String>.from(row)).toList(),
        );

  static Spreadsheet? of(Strings columns, TRows rows) {
    if (!isSpreadsheet(columns, rows)) {
      return null;
    }

    return Spreadsheet._internal(columns, rows);
  }

  static Spreadsheet? ofRows(TRows table) => of(table.first, table.sublist(1));
  static Spreadsheet? ofCSVString(String table) =>
      ofRows(csvToSpreadsheet(table));
  static Spreadsheet? ofClipboardString(String table) =>
      ofRows(clipboardToSpreadsheet(table));

  TRows get rowsWithTitles => [columns, ...rows];

  static bool isSpreadsheet(Strings columns, TRows rows) {
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

  bool get isEmpty => rows.isEmpty;
  bool get isNotEmpty => rows.isNotEmpty;

  String get csv => rowsWithTitles.map((row) => row.join(',')).join('\n');
  String get clipboardString =>
      rowsWithTitles.map((row) => row.join('\t')).join('\n');

  @override
  String toString() => csv;

  static TRows csvToSpreadsheet(String data) {
    const String fieldDeliminator = ',';

    TRows table = [];
    Strings row = [];
    String field = '';
    bool escaped = false;

    for (var idx = 0; idx < data.length; idx++) {
      switch (data[idx]) {
        case fieldDeliminator:
          {
            if (!escaped) {
              row.add(field);
              field = '';
            } else {
              field += fieldDeliminator;
            }
          }
        case '\n':
          {
            if (!escaped) {
              field = field.trim();
              row.add(field);
              field = '';
              table.add(row);
              row = [];
            } else {
              field += '\n';
            }
          }
        case '"':
          {
            if (!escaped) {
              escaped = true;
            } else {
              switch (data[idx + 1]) {
                case fieldDeliminator:
                case '\n':
                  {
                    escaped = false;
                  }
                case '"':
                  {
                    field += '"';
                    idx++;
                  }
                case _:
                  {
                    return [];
                  }
              }
            }
          }
        case var char:
          {
            field += char;
          }
      }
    }

    return table;
  }

  /* return data
        .trim()
        .split('\n')
        .map((line) => line.split(',').map((e) => e.trim()).toList())
        .toList(); */

  static TRows clipboardToSpreadsheet(String data) {
    const String fieldDeliminator = ',';

    TRows table = [];
    Strings row = [];
    String field = '';
    bool escaped = false;

    for (var idx = 0; idx < data.length; idx++) {
      switch (data[idx]) {
        case fieldDeliminator:
          {
            if (!escaped) {
              row.add(field);
              field = '';
            } else {
              field += fieldDeliminator;
            }
          }
        case '\n':
          {
            if (!escaped) {
              field = field.trim();
              row.add(field);
              field = '';
              table.add(row);
              row = [];
            } else {
              field += '\n';
            }
          }
        case '"':
          {
            if (!escaped) {
              escaped = true;
            } else {
              switch (data[idx + 1]) {
                case fieldDeliminator:
                case '\n':
                  {
                    escaped = false;
                  }
                case '"':
                  {
                    field += '"';
                    idx++;
                  }
                case _:
                  {
                    return [];
                  }
              }
            }
          }
        case var char:
          {
            field += char;
          }
      }
    }

    return table;
  }

  /* return data
        .trim()
        .split('\n')
        .map((line) => line.split('\t').map((e) => e.trim()).toList())
        .toList(); */
}

void prefixID(TRows table) {
  table.first.insert(0, "ID");
  final rows = table.sublist(1);
  for (int id = 1; id <= rows.length; id++) {
    rows[id].insert(0, "$id");
  }
}

void addGlobalCapacity(TRows groupsTable, int globalCapacity) {
  groupsTable
    ..first.add('Kapazität')
    ..sublist(1).forEach((row) => row.add(globalCapacity.toString()));
}

String toSpreadsheetString(TRows data) {
  return data.map((row) => row.join(',')).join('\n');
}

Future<String> getClipboardData() async {
  ClipboardData? data = await Clipboard.getData('text/plain');
  if (data == null) return "";

  return data.text ?? "";
}

Future<Result<Null, Null>> setClipboardDataPlainText(String text) async {
  try {
    await Clipboard.setData(ClipboardData(text: text));
    return Result.ok(null);
  } on Exception {
    return Result.error(null);
  }
}

abstract interface class CSVSerializable {
  String get csv;
  String csvColumns();
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

// overridable <= >= ~ - - + < > >>> >> ~/

class RV<T> {
  T _value;
  final Set<Function(T)> _callbacks = {};

  RV(this._value);

  void notify() {
    for (var callback in _callbacks) {
      callback(_value);
    }
  }

  T get value => _value;

  T operator ~() => value;

  set value(T newValue) {
    _value = newValue;
    notify();
  }

  void operator <<(T newValue) => value = newValue;

  void update(T newValue) => value = newValue;

  void mutate(Function(T) mutation) {
    mutation(_value);
    notify();
  }

  T addListener(Function(T) callback) {
    _callbacks.add(callback);
    return value;
  }

  T operator >>>(Function(T) callback) => addListener(callback);

  void removeListener(Function(T) callback) => _callbacks.remove(callback);

  void operator ~/(Function(T) callback) => removeListener(callback);

  static void listen(List<RV> values, void Function() callback) {
    for (var value in values) {
      value >>> ((_) => callback());
    }
  }
}

extension MakeReactive<T> on T {
  RV<T> get rv => RV(this);
}
