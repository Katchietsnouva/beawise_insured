// lib/app_2/core/utils/text_scale_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TextScaleLevel { smaller, small, defaultLevel, large, larger }

class TextScaleProvider with ChangeNotifier {
  TextScaleLevel _currentLevel = TextScaleLevel.defaultLevel;
  TextScaleLevel get currentLevel => _currentLevel;

  TextScaleProvider() {
    _loadTextScale();
  }

  double get textScaleFactor {
    switch (_currentLevel) {
      case TextScaleLevel.smaller:
        return 0.7;
      case TextScaleLevel.small:
        return 0.85;
      case TextScaleLevel.defaultLevel:
        return 1.0;
      case TextScaleLevel.large:
        return 1.15;
      case TextScaleLevel.larger:
        return 1.3;
    }
  }

  void setLevel(TextScaleLevel level) async {
    _currentLevel = level;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('text_scale_level', level.name);
  }

  void _loadTextScale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLevelName =
        prefs.getString('text_scale_level') ?? TextScaleLevel.defaultLevel.name;
    _currentLevel = TextScaleLevel.values.firstWhere(
      (e) => e.name == savedLevelName,
    );
    notifyListeners();
  }
}

TextScaleLevel textScaleLevelFromString(String value) {
  switch (value) {
    case 'Smaller':
      return TextScaleLevel.smaller;
    case 'Small':
      return TextScaleLevel.small;
    case 'Default':
      return TextScaleLevel.defaultLevel;
    case 'Large':
      return TextScaleLevel.large;
    case 'Larger':
      return TextScaleLevel.larger;
    default:
      return TextScaleLevel.defaultLevel;
  }
}

final textScaleProvider = ChangeNotifierProvider<TextScaleProvider>((ref) {
  return TextScaleProvider();
});
