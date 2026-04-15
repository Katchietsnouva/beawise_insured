import 'package:flutter/services.dart';

/// Helper class for consistent haptic feedback across the app.
/// Uses light/medium impacts for most UI interactions.
///
/// Usage examples:
///   HapticHelper.light();          // quick subtle tap
///   HapticHelper.medium();         // button press feel
///   HapticHelper.heavy();          // important confirmation
///   HapticHelper.vibrate();        // strong vibration (careful with overuse)
class HapticHelper {
  HapticHelper._(); // private constructor → static only

  /// Light haptic – best for page swipes, small taps, dot indicators
  static void light() {
    HapticFeedback.lightImpact();
  }

  /// Medium haptic – good default for most buttons & continue actions
  static void medium() {
    HapticFeedback.mediumImpact();
  }

  /// Heavy haptic – use for final "Get Started", big confirmations
  static void heavy() {
    HapticFeedback.heavyImpact();
  }

  /// Strong vibration – reserved for errors, success milestones, or very intentional actions
  static void vibrate() {
    HapticFeedback.vibrate();
  }

  /// Selection/click feel – subtle, good for list items or toggles
  static void selection() {
    HapticFeedback.selectionClick();
  }
}
