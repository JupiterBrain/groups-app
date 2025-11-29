import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groups_app/utils.dart';

class RIntField extends StatefulWidget {
  final RV<int> value;
  final int? min;
  final int? max;
  final String label;

  const RIntField({
    super.key,
    required this.value,
    this.min,
    this.max,
    required this.label,
  });

  @override
  State<RIntField> createState() => _RIntFieldState();
}

class _RIntFieldState extends State<RIntField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.value.toString());
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) _tryCommit();
    });

    widget.value.addListener(_externalUpdate);
  }

  void _externalUpdate(_) {
    final ext = widget.value.value.toString();
    if (_controller.text != ext) {
      _controller.text = ext;
    }
  }

  void _tryCommit() {
    final input = _controller.text.trim();
    final parsed = int.tryParse(input);

    if (parsed == null) return _showError("Nur ganze Zahlen erlaubt");

    var min = widget.min;
    if (min != null && parsed < min) return _showError("Minimum: $min");

    var max = widget.max;
    if (max != null && parsed > max) return _showError("Maximum: $max");

    // valid
    setState(() => _errorText = null);
    widget.value.value = parsed;
  }

  void _showError(String msg) {
    setState(() {
      _controller.text = "${~widget.value}";
      _errorText = msg;
    });
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
    return wrapTextField(
      TextField(
        controller: _controller,
        focusNode: _focusNode,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[-]?\d*')),
        ],
        decoration: InputDecoration(
          labelText: widget.label,
          errorText: _errorText,
        ),
      ),
    );
  }
}
