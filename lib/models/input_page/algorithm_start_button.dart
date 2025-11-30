import 'package:flutter/material.dart';
import 'package:groups_app/components/reactive/reactive_conditional.dart';
import 'package:groups_app/controller.dart';

class AlgorithmStartButton extends StatelessWidget {
  const AlgorithmStartButton({super.key});

  @override
  Widget build(BuildContext context) => RConditional(
    value: viewController.readyToStart,
    builder: (context) => FloatingActionButton.extended(
      onPressed: () => viewController.startAlgorithm(context),
      label: const Row(
        children: [
          Text('Zuordnen'),
          SizedBox(width: 8),
          Icon(Icons.groups_2, size: 28),
        ],
      ),
    ),
  );
}
