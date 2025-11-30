import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

Future<void> checkForUpdate(GlobalKey<ScaffoldMessengerState> key) async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    final packageInfo = await PackageInfo.fromPlatform();

    final localVersion = packageInfo.version;

    final response = await http.get(
      .parse(
        'https://api.github.com/repos/JupiterBrain/groups-app/releases/latest',
      ),
      headers: {'Accept': 'application/vnd.github+json'},
    );

    if (response.statusCode != 200) {
      key.currentState!.showSnackBar(
        const SnackBar(
          showCloseIcon: true,
          duration: Duration(seconds: 15),
          content: Text("Updateüberprüfung fehlgeschlagen."),
        ),
      );
      return;
    }

    final json = jsonDecode(response.body);

    final latestVersion = json['tag_name']?.toString().substring(1);

    if (latestVersion == null) return;

    if (latestVersion.compareTo(localVersion) > 0) {
      showUpdateDialog(key, localVersion, latestVersion);
      return;
    }

    key.currentState!.showSnackBar(
      const SnackBar(
        showCloseIcon: true,
        duration: Duration(seconds: 15),
        content: Text("Dies ist die neueste verfügbare Version"),
      ),
    );
  } catch (e) {
    return;
  }
}

void showUpdateDialog(
  GlobalKey<ScaffoldMessengerState> key,
  String localVersion,
  String latestVersion,
) {
  key.currentState!.showSnackBar(
    SnackBar(
      showCloseIcon: true,
      duration: const Duration(seconds: 45),
      action: SnackBarAction(
        label: 'Jetzt installieren',
        onPressed: () async {
          final uri = Uri.parse(
            "https://JupiterBrain.github.io/groups-app/update",
          );
          if (!await canLaunchUrl(uri)) return;
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        },
      ),
      content: RichText(
        text: TextSpan(
          text: 'Es ist eine neue Version verfügbar ',
          children: [
            TextSpan(
              text: "$localVersion -> $latestVersion",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ),
  );
}
