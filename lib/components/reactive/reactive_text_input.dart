import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groups_app/utils.dart';

class RTextInput extends StatefulWidget {
  final Reactive<String> value;
  final String label;
  final String? Function(String)? validator;

  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const RTextInput({
    required this.value,
    required this.label,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    super.key,
  });

  @override
  State<RTextInput> createState() => _RTextInputState();
}

class _RTextInputState extends State<RTextInput> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _controller = .new(text: widget.value.value);
    _focusNode = .new();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _commitValue();
      }
    });

    widget.value.addListener(_externalUpdate);
  }

  void _externalUpdate(_) {
    if (_controller.text != ~widget.value) {
      _controller.text = ~widget.value;
    }
  }

  void _commitValue() {
    final newValue = _controller.text;
    if (~widget.value != newValue) {
      final validator = widget.validator;
      if (validator != null) {
        final errorText = validator(newValue);

        if (errorText != null) {
          _controller.text = errorText;
          return;
        }
      }
      widget.value << newValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    widget.value.removeListener(_externalUpdate);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => wrapTextField(
    TextField(
      controller: _controller,
      decoration: .new(labelText: widget.label),
      focusNode: _focusNode,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
    ),
  );
}
