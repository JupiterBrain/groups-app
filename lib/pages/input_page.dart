import 'package:flutter/material.dart';
import 'package:groups_v4/components/reactive/reactive_wrapper.dart';
import 'package:groups_v4/controller.dart';
import 'package:groups_v4/models/input_page/algorithm_extended_options_card.dart';
import 'package:groups_v4/models/input_page/algorithm_parameters_pane.dart';
import 'package:groups_v4/models/input_page/algorithm_start_button.dart';
import 'package:groups_v4/models/input_page/groups_input_card.dart';
import 'package:groups_v4/components/reactive/reactive_conditional.dart';
import 'package:groups_v4/models/input_page/items_input_card.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eingabe'),
        actions: [
          ReactiveWrapper(
            reactiveValues: [viewController.assignmentTable],
            builder: (context) {
              if (~viewController.assignmentTable != null) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilledButton(
                    child: const Row(
                      children: [
                        Text("Zur Ausgabe"),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/output');
                    },
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AlgorithmParametersPane(),
                SizedBox(height: 16),
                AlgorithmExtendedOptionsCard(),
                SizedBox(height: 64),
                GroupsInputCard(),
                SizedBox(height: 16),
                ItemsInputCard(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: RConditional(
        value: viewController.readyToStart,
        builder: (context) => AlgorithmStartButton(context: context),
      ),
    );
  }
}
