import 'package:flutter/material.dart';

class BiaxialScrollView extends StatelessWidget {
  final Widget child;

  const BiaxialScrollView({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: child,
      ),
    );
  }
}
