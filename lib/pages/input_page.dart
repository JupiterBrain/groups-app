import 'package:flutter/material.dart';
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
  final TextEditingController _defaultCapacityInputController =
      TextEditingController(text: '15');
  final TextEditingController _nrOfChoicesInputController =
      TextEditingController(text: '3');

  @override
  void dispose() {
    _defaultCapacityInputController.dispose();
    _nrOfChoicesInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eingabe'),
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
