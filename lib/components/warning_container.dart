import 'package:flutter/material.dart';

class WarningContainer extends StatelessWidget {
  const WarningContainer({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        border: Border.all(color: Colors.amber, width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}
