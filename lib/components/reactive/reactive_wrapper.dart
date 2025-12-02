import 'package:flutter/material.dart';
import 'package:groups_app/utils.dart';

class ReactiveWrapper extends StatefulWidget {
  final List<Reactive> reactiveValues;
  final Widget? Function(BuildContext context) builder;

  const ReactiveWrapper({
    required this.reactiveValues,
    required this.builder,
    super.key,
  });

  @override
  State<ReactiveWrapper> createState() => _ReactiveWrapperState();
}

class _ReactiveWrapperState extends State<ReactiveWrapper> {
  @override
  void initState() {
    super.initState();

    for (final rv in widget.reactiveValues) {
      rv >>> _onChange;
    }
  }

  void _onChange(_) {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    for (final rv in widget.reactiveValues) {
      rv.removeListener(_onChange);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context) ?? const SizedBox.shrink();
}
