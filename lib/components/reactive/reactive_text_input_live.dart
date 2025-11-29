import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groups_app/components/reactive/reactive_wrapper.dart';
import 'package:groups_app/utils.dart';

class RTextInputLive extends StatelessWidget {
  final RV<String> value;
  final String label;
  late final TextEditingController _controller;

  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  RTextInputLive({
    required this.value,
    required this.label,
    this.keyboardType,
    this.inputFormatters,
    super.key,
  }) {
    _controller = .new(text: value.value);
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveWrapper(
      reactiveValues: [value],
      builder: (context) {
        return wrapTextField(
          TextField(
            decoration: .new(labelText: label),
            controller: _controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            onChanged: (newValue) => value.value = newValue,
          ),
        );
      },
    );
  }
}
