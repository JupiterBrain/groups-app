import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:groups_app/algorithm/classes.dart';

typedef Strings = List<String>;
typedef TRows = List<Strings>;
typedef Groups = List<Group>;
typedef Items = List<Item>;

extension Blank on String {
  bool get isBlank => trim().isEmpty;
}

extension Sum<T extends num> on Iterable<T> {
  T sum() => fold(0 as T, (sum, curr) => sum + curr as T);
}

extension FirstWhereOrNull<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (var element in this) {
      if (test(element)) return element;
    }

    return null;
  }
}

// Workaround for https://github.com/flutter/flutter/issues/153560
// This only affects Linux desktop builds and the wrapper should be removed when the issue is fixed.
Widget wrapTextField(TextField field) {
  return !kIsWeb && Platform.isLinux ? ExcludeSemantics(child: field) : field;
}

///  Reactives

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
