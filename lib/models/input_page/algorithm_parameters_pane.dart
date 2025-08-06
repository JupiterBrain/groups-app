import 'package:flutter/material.dart';
import 'package:groups_v4/components/reactive/reactive_checkbox_list_tile.dart';
import 'package:groups_v4/components/reactive/reactive_conditional.dart';
import 'package:groups_v4/components/reactive/reactive_int_field.dart';
import 'package:groups_v4/controller.dart';

class AlgorithmParametersPane extends StatelessWidget {
  const AlgorithmParametersPane({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Optionen', style: Theme.of(context).textTheme.titleMedium),
        RIntField(
          value: viewController.nrOfChoices,
          label: 'Anzahl an Wahlen',
          min: 2,
          max: 15,
        ),
        RCheckboxListTile(
          value: viewController.useDefaultCapacity,
          title: 'Globale Gruppenkapazität verwenden',
        ),
        RConditional(
          value: viewController.useDefaultCapacity,
          builder: (context) => RIntField(
            value: viewController.defaultCapacity,
            label: 'Globale Gruppenkapazität',
            min: 2,
          ),
        ),
      ],
    );
  }
}
