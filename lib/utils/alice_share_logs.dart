import 'dart:io';

import 'package:alice_lightweight/helper/alice_save_helper.dart';
import 'package:alice_lightweight/model/alice_http_call.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<File> get _localFile async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  return File('$path/network_logs.txt');
}

Future<File> saveLogs(List<AliceHttpCall> logs) async {
  final callStrings = await Future.wait(
      logs.map((log) async => await AliceSaveHelper.buildCallLog(log)));

  final String logsString = callStrings.fold('', (value, log) {
    if (value.isEmpty) {
      return log;
    }
    return "$value\n\n\n$log";
  });
  final file = await _localFile;

  return file.writeAsString(logsString);
}

void shareFile(File file) {
  final path = file.path;
  Share.shareFiles([path], subject: "Alice logs");
}
