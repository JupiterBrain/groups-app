import 'package:flutter/material.dart';

class TutorialDialog extends StatelessWidget {
  const TutorialDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutorial'),
      ),
      body: const Column(
        children: [
          Text(
            'Das integrierte Tutorial befindet sich derzeit noch in '
            'Entwicklung, bitte konsultieren Sie die offizielle Dokumentation  '
            'unter JupiterBrain.github.io/groups_v4 oder '
            'github.com/JupiterBrain/groups_v4',
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
