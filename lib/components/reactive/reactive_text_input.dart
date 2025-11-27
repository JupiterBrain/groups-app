import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groups_app/utils.dart';

class RTextInput extends StatefulWidget {
  final RV<String> value;
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

    _controller = TextEditingController(text: widget.value.value);
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _commitValue();
      }
    });

    widget.value.addListener(_externalUpdate);
  }

  void _externalUpdate(_) {
    if (_controller.text != widget.value.value) {
      _controller.text = widget.value.value;
    }
  }

  void _commitValue() {
    final newValue = _controller.text;
    if (widget.value.value != newValue) {
      if (widget.validator != null) {
        final errorText = widget.validator!(newValue);

        if (errorText != null) {
          _controller.text = errorText;
          return;
        }
      }
      widget.value.value = newValue;
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
  Widget build(BuildContext context) {
    return wrapTextField(TextField(
      controller: _controller,
      decoration: InputDecoration(labelText: widget.label),
      focusNode: _focusNode,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
    ));
  }
}
