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
            'unter https://JupiterBrain.github.io/groups-app oder '
            'https://github.com/JupiterBrain/groups-app',
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
