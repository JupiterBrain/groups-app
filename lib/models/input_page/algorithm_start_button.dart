import 'package:flutter/material.dart';
import 'package:groups_v4/components/reactive/reactive_conditional.dart';
import 'package:groups_v4/controller.dart';

class AlgorithmStartButton extends StatelessWidget {
  const AlgorithmStartButton({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return RConditional(
      value: viewController.readyToStart,
      builder: (context) => FloatingActionButton.extended(
        onPressed: () => viewController.startAlgorithm(context),
        label: const Row(
          children: [
            Text('Zuordnen'),
            SizedBox(width: 8),
            Icon(
              Icons.groups_2,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}
