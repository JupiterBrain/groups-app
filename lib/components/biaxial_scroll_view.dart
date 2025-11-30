import 'package:flutter/material.dart';

//TODO update BiaxialScrollView

class BiaxialScrollView extends StatelessWidget {
  final Widget child;

  const BiaxialScrollView({super.key, required this.child});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: .vertical,
    child: SingleChildScrollView(scrollDirection: .horizontal, child: child),
  );
}
