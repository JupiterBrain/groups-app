import 'package:flutter/material.dart';
import 'package:groups_v4/utils.dart';

class ReactiveWrapper extends StatefulWidget {
  final List<RV<dynamic>> reactiveValues;
  final Widget Function(BuildContext context) builder;

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

    for (var rv in widget.reactiveValues) {
      rv.addListener(_onChange);
    }
  }

  void _onChange(_) {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    for (var rv in widget.reactiveValues) {
      rv.addListener(_onChange);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
