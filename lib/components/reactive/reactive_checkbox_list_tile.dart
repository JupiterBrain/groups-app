import 'package:flutter/material.dart';
import 'package:groups_app/components/reactive/reactive_wrapper.dart';
import 'package:groups_app/utils.dart';

class RCheckboxListTile extends StatelessWidget {
  final RV<bool> value;
  final String title;

  const RCheckboxListTile(
      {required this.value, required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return ReactiveWrapper(
      reactiveValues: [value],
      builder: (context) {
        return CheckboxListTile(
          title: Text(title),
          value: value.value,
          onChanged: (newValue) => value.value = newValue!,
        );
      },
    );
  }
}
