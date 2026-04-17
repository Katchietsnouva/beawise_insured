import 'dart:html' as html;
import 'dart:convert';

/// Downloads JSON directly in browser (only works on Web)
Future<void> downloadJsonWeb(String jsonString, String fileName) async {
  final bytes = utf8.encode(jsonString);
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);

  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', fileName)
    ..click();

  html.Url.revokeObjectUrl(url);
}
