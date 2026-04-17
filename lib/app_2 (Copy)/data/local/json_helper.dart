import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class JsonHelper {
  static Future<File> get _localFile async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/data.json');
  }

  static Future<Map<String, dynamic>> loadData() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        return jsonDecode(contents);
      } else {
        // Copy from assets
        final assetData = await rootBundle.loadString('assets/data/data.json');
        await file.writeAsString(assetData);
        return jsonDecode(assetData);
      }
    } catch (e) {
      return {'clients': [], 'quotes': []};
    }
  }

  static Future<void> saveData(Map<String, dynamic> data) async {
    final file = await _localFile;
    await file.writeAsString(jsonEncode(data));
  }
}
