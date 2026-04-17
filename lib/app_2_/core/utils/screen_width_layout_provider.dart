// lib/logic/layout_provider.dart   ← NEW FILE
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

enum ScreenWidthBreakpoint {
  compact, // < 900px
  medium, // < 1200px
  expanded, // ≥ 1200px (or higher)
}

class ScreenWidthLayoutProvider extends ChangeNotifier {
  ScreenWidthBreakpoint _breakpoint =
      ScreenWidthBreakpoint.medium; // default: 1200px

  ScreenWidthBreakpoint get breakpoint => _breakpoint;

  void setBreakpoint(ScreenWidthBreakpoint value) {
    if (_breakpoint != value) {
      _breakpoint = value;
      notifyListeners();
    }
  }

  // User-friendly names
  String get label {
    switch (_breakpoint) {
      case ScreenWidthBreakpoint.compact:
        return 'Compact (below 900px)';
      case ScreenWidthBreakpoint.medium:
        return 'Medium (below 1200px)';
      case ScreenWidthBreakpoint.expanded:
        return 'Expanded (1200px and above)';
    }
  }

  // The actual pixel value the app uses
  double get pixelValue {
    switch (_breakpoint) {
      case ScreenWidthBreakpoint.compact:
        return 900;
      case ScreenWidthBreakpoint.medium:
        return 1200;
      case ScreenWidthBreakpoint.expanded:
        return 1400; // or double.infinity if you want "never mobile"
    }
  }
}

final screenWidthLayoutProvider =
    ChangeNotifierProvider<ScreenWidthLayoutProvider>((ref) {
      return ScreenWidthLayoutProvider();
    });
