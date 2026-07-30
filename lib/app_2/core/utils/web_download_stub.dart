/// Empty stub – never called on mobile/desktop
Future<void> downloadJsonWeb(String jsonString, String fileName) async {
  throw UnsupportedError('Web download only');
}

/// Empty stub – never called on mobile/desktop
Future<void> downloadBytesWeb(
  List<int> bytes,
  String fileName, {
  String mimeType = 'application/octet-stream',
}) async {
  throw UnsupportedError('Web download only');
}
