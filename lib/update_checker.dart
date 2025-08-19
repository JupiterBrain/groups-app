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
      Uri.parse(
          'https://api.github.com/repos/JupiterBrain/groups_v4/releases/latest'),
      headers: {'Accept': 'application/vnd.github+json'},
    );

    if (response.statusCode != 200) return;

    final json = jsonDecode(response.body);
    debugPrint(json);
    final latestVersion = json['tag_name']?.toString();

    if (latestVersion == null) return;

    if (latestVersion.compareTo(localVersion) >= 0) return;

    showUpdateDialog(key, localVersion, latestVersion, json['html_url']);
  } catch (e) {
    return;
  }
}

void showUpdateDialog(
  GlobalKey<ScaffoldMessengerState> key,
  String localVersion,
  String latestVersion,
  String url,
) {
  key.currentState!.showSnackBar(
    SnackBar(
      showCloseIcon: true,
      duration: const Duration(seconds: 45),
      action: SnackBarAction(
        label: 'Jetzt installieren',
        onPressed: () async {
          final uri = Uri.parse(url);
          if (!await canLaunchUrl(uri)) return;
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        },
      ),
      content: RichText(
        text: TextSpan(text: 'Es ist eine neue Version verfügbar ', children: [
          TextSpan(
            text: "$localVersion -> $latestVersion",
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ]),
      ),
    ),
  );
}
