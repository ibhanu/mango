import 'package:flutter/material.dart';

/// Mango App Color Palette
/// Revamped theme inspired by reference images
abstract class AppColors {
  // ============ Background Colors ============
  /// Primary deep navy background
  static const Color background = Color(0xFF030A1F);

  /// Surface color for cards and containers
  static const Color surface = Color(0xFF0A1432);

  /// Variant surface for elevated elements
  static const Color surfaceVariant = Color(0xFF121E45);

  /// Lighter surface for borders and dividers
  static const Color surfaceBright = Color(0xFF1B2958);

  // ============ Accent Colors (Mango Theme) ============
  /// Primary mango accent
  static const Color accent = Color(0xFFFFA726);

  /// Light yellow for highlights
  static const Color accentLight = Color(0xFFFFD54F);

  /// Dark orange for pressed states
  static const Color accentDark = Color(0xFFF57C00);

  /// Mango with opacity for backgrounds
  static const Color accentSoft = Color(0x33FFA726);

  // ============ Text Colors ============
  /// Primary text color (White)
  static const Color textPrimary = Color(0xFFFFFFFF);

  /// Secondary text color (Soft mango/cream)
  static const Color textSecondary = Color(0xFFFFCC80);

  /// Tertiary text color (Dimmed navy/blue)
  static const Color textTertiary = Color(0xFF7B8AB8);

  /// Disabled text color
  static const Color textDisabled = Color(0xFF3F4E7A);

  // ============ Semantic Colors ============
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFB74D);
  static const Color error = Color(0xFFEF5350);
  static const Color info = Color(0xFF42A5F5);

  // ============ Legacy/Mango Colors (kept for compatibility or specific accents) ============
  static const Color mango = Color(0xFFFFA726);
  static const Color mangoGradient1 = Color(0xFFFFA726);
  static const Color mangoGradient2 = Color(0xFFFB8C00);

  // ============ Gradient Definitions ============
  /// Subtle background gradient
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0A1432), Color(0xFF030A1F)],
  );

  /// Card gradient for elevated surfaces
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF121E45), Color(0xFF0A1432)],
  );

  /// Accent gradient
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentLight, accent, accentDark],
  );
}
