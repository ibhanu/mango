import 'package:flutter/services.dart';

/// Premium micro-haptics profiles for the Mango app
class AppHaptics {
  /// Subtle click for navigation or small actions
  static void light() {
    HapticFeedback.lightImpact();
  }

  /// Solid thud for toggles or favorite actions
  static void medium() {
    HapticFeedback.mediumImpact();
  }

  /// Heavy impact for critical or important actions
  static void heavy() {
    HapticFeedback.heavyImpact();
  }

  /// Success pattern for achievements or streaks
  static void success() {
    HapticFeedback.vibrate();
  }

  /// Selection click for scrolling or minor changes
  static void selection() {
    HapticFeedback.selectionClick();
  }
}
