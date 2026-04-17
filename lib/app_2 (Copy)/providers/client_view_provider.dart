// lib/app_2/providers/client_view_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' show StateProvider;

enum ClientViewMode { list, grid }

final clientViewModeProvider = StateProvider<ClientViewMode>((ref) {
  return ClientViewMode.list;
});
