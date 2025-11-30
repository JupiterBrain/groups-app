import 'package:flutter/services.dart';
import 'package:groups_app/utils/result.dart';

Future<String> getClipboardData() async {
  ClipboardData? data = await Clipboard.getData('text/plain');
  if (data == null) return "";

  return data.text ?? "";
}

Future<Result<Null, Null>> setClipboardDataPlainText(String text) async {
  try {
    await Clipboard.setData(ClipboardData(text: text));
    return Result.ok(null);
  } on Exception {
    return Result.error(null);
  }
}
