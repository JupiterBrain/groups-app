import 'package:flutter/material.dart';
import 'package:groups_app/components/reactive/reactive_checkbox_list_tile.dart';
import 'package:groups_app/controller.dart';

class AlgorithmExtendedOptionsCard extends StatelessWidget {
  const AlgorithmExtendedOptionsCard({super.key});

  @override
  Widget build(BuildContext context) => Card(
    child: ExpansionTile(
      title: Text(
        'Erweiterte Optionen',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      children: [
        RCheckboxListTile(
          value: viewController.allowDuplicates,
          title: 'Doppelte Wahlen erlauben',
        ),
        RCheckboxListTile(
          value: viewController.allowEmpty,
          title: 'Leere Wahlen erlauben',
        ),
        RCheckboxListTile(
          value: viewController.allowExcess,
          title: 'Elementüberschuss erlauben',
        ),
        RCheckboxListTile(
          value: viewController.randomRemaining,
          title: 'Unzuweisbare zufällig zuweisen',
        ),
      ],
    ),
  );
}
