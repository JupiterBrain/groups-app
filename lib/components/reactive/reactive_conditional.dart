import 'package:flutter/material.dart';
import 'package:groups_v4/components/reactive/reactive_wrapper.dart';
import 'package:groups_v4/utils.dart';

class RConditional extends StatelessWidget {
  final RV<bool> value;
  final Widget Function(BuildContext context) builder;

  const RConditional({required this.value, required this.builder, super.key});

  @override
  Widget build(BuildContext context) {
    return ReactiveWrapper(
      reactiveValues: [value],
      builder: (context) {
        if (~value) {
          return builder(context);
        } else {
          return const SizedBox.shrink(); //EmptyWidget();
        }
      },
    );
  }
}
