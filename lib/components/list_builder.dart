import 'package:flutter/material.dart';
import 'package:groups_v4/utils.dart';

class ListBuilder extends StatelessWidget {
  const ListBuilder({super.key, required this.list, required this.builder});

  final Strings list;
  final Widget Function(BuildContext context, String item) builder;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: (list).map((item) => builder(context, item)).toList(),
      ),
    );
  }
}
