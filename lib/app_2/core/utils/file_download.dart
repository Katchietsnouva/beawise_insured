import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Conditional import: real browser download on web, throwing stub elsewhere.
import 'package:insured/app_2/core/utils/web_download_stub.dart'
    if (dart.library.html) 'package:insured/app_2/core/utils/web_download.dart';

/// Saves [bytes] to the user's device across platforms.
///
/// - Web: triggers a browser download of [fileName].
/// - Mobile/Desktop: opens a native "save file" dialog pre-filled with
///   [fileName] and writes the bytes there.
///
/// Returns `true` if the file was saved (or the download was triggered on web),
/// `false` if the user cancelled the save dialog.
Future<bool> saveBytesToDevice({
  required List<int> bytes,
  required String fileName,
  String mimeType = 'application/octet-stream',
}) async {
  if (kIsWeb) {
    await downloadBytesWeb(bytes, fileName, mimeType: mimeType);
    return true;
  }

  final path = await FilePicker.platform.saveFile(
    dialogTitle: 'Save $fileName',
    fileName: fileName,
    bytes: Uint8List.fromList(bytes),
  );
  return path != null;
}
