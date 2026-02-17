import 'dart:convert';

import 'package:mango/models/app_theme_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Repository for managing theme selection and custom themes
class ThemeRepository {
  final SharedPreferences _prefs;

  static const String _keySelectedTheme = 'selected_theme_id';
  static const String _keyCustomThemes = 'custom_themes';
  static const String _keyFavoriteThemes = 'favorite_theme_ids';

  ThemeRepository(this._prefs);

  /// Get the currently selected theme
  AppThemeData getSelectedTheme() {
    final themeId = _prefs.getString(_keySelectedTheme);

    if (themeId == null) {
      // Return default dark theme
      return DefaultThemes.getById('minimal_dark') ?? DefaultThemes.all.first;
    }

    // First check default themes
    final defaultTheme = DefaultThemes.getById(themeId);
    if (defaultTheme != null) {
      return defaultTheme.copyWith(isFavorite: isFavorite(themeId));
    }

    // Then check custom themes
    final customThemes = getCustomThemes();
    try {
      return customThemes.firstWhere((t) => t.id == themeId);
    } catch (_) {
      return DefaultThemes.all.first;
    }
  }

  /// Set the selected theme
  Future<void> setSelectedTheme(String themeId) async {
    await _prefs.setString(_keySelectedTheme, themeId);
  }

  /// Get all custom user-created themes
  List<AppThemeData> getCustomThemes() {
    final jsonList = _prefs.getStringList(_keyCustomThemes) ?? [];
    return jsonList.map((json) {
      final Map<String, dynamic> data = jsonDecode(json);
      return AppThemeData.fromJson(data);
    }).toList();
  }

  /// Save a custom theme
  Future<void> saveCustomTheme(AppThemeData theme) async {
    final customThemes = getCustomThemes();

    // Check if theme already exists (update) or is new (add)
    final existingIndex = customThemes.indexWhere((t) => t.id == theme.id);
    if (existingIndex >= 0) {
      customThemes[existingIndex] = theme;
    } else {
      customThemes.add(theme);
    }

    await _saveCustomThemes(customThemes);
  }

  /// Delete a custom theme
  Future<void> deleteCustomTheme(String themeId) async {
    final customThemes = getCustomThemes();
    customThemes.removeWhere((t) => t.id == themeId);
    await _saveCustomThemes(customThemes);
  }

  Future<void> _saveCustomThemes(List<AppThemeData> themes) async {
    final jsonList = themes.map((t) => jsonEncode(t.toJson())).toList();
    await _prefs.setStringList(_keyCustomThemes, jsonList);
  }

  /// Check if a theme is favorited
  bool isFavorite(String themeId) {
    final favorites = _prefs.getStringList(_keyFavoriteThemes) ?? [];
    return favorites.contains(themeId);
  }

  /// Toggle favorite status for a theme
  Future<void> toggleFavorite(String themeId) async {
    final favorites = _prefs.getStringList(_keyFavoriteThemes) ?? [];

    if (favorites.contains(themeId)) {
      favorites.remove(themeId);
    } else {
      favorites.add(themeId);
    }

    await _prefs.setStringList(_keyFavoriteThemes, favorites);
  }

  /// Get all favorite theme IDs
  List<String> getFavoriteThemeIds() {
    return _prefs.getStringList(_keyFavoriteThemes) ?? [];
  }

  /// Get all themes (default + custom) with favorite status applied
  List<AppThemeData> getAllThemes() {
    final favorites = getFavoriteThemeIds();

    // Apply favorite status to default themes
    final defaultThemes =
        DefaultThemes.all.map((t) {
          return t.copyWith(isFavorite: favorites.contains(t.id));
        }).toList();

    // Get custom themes (already have favorite status)
    final customThemes = getCustomThemes();

    return [...defaultThemes, ...customThemes];
  }

  /// Get themes filtered by category
  List<AppThemeData> getThemesByCategory(ThemeCategory category) {
    final allThemes = getAllThemes();

    if (category == ThemeCategory.all) {
      return allThemes.where((t) => !t.isCustom).toList();
    }

    if (category == ThemeCategory.myThemes) {
      return allThemes.where((t) => t.isCustom).toList();
    }

    return allThemes
        .where((t) => t.category == category && !t.isCustom)
        .toList();
  }
}
