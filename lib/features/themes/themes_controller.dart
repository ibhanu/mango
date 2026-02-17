import 'package:get/get.dart';
import 'package:mango/core/di/service_locator.dart';
import 'package:mango/models/app_theme_model.dart';
import 'package:mango/repository/theme_repository.dart';

/// Controller for the Themes screen
class ThemesController extends GetxController {
  final ThemeRepository _themeRepo = getIt<ThemeRepository>();

  /// All available categories for filtering
  final List<ThemeCategory> categories = ThemeCategory.values;

  /// Currently selected filter category
  ThemeCategory selectedCategory = ThemeCategory.all;

  /// Filtered themes based on selected category
  List<AppThemeData> get filteredThemes {
    return _themeRepo.getThemesByCategory(selectedCategory);
  }

  /// Get themes for "Theme Mixes" horizontal scroll (featured themes)
  List<AppThemeData> get themeMixes {
    // Return one theme from each category as featured
    final featured = <AppThemeData>[];
    for (final cat in [
      ThemeCategory.nature,
      ThemeCategory.ocean,
      ThemeCategory.cosmic,
      ThemeCategory.gradient,
    ]) {
      final themes = _themeRepo.getThemesByCategory(cat);
      if (themes.isNotEmpty) {
        featured.add(themes.first);
      }
    }
    return featured;
  }

  /// Currently selected/applied theme ID
  String get selectedThemeId => _themeRepo.getSelectedTheme().id;

  /// Get the currently applied theme
  AppThemeData get currentTheme => _themeRepo.getSelectedTheme();

  /// Custom themes created by user
  List<AppThemeData> get customThemes => _themeRepo.getCustomThemes();

  /// Select a category filter
  void selectCategory(ThemeCategory category) {
    selectedCategory = category;
    update();
  }

  /// Apply a theme
  Future<void> selectTheme(String themeId) async {
    await _themeRepo.setSelectedTheme(themeId);
    update();
  }

  /// Toggle favorite for a theme
  Future<void> toggleFavorite(String themeId) async {
    await _themeRepo.toggleFavorite(themeId);
    update();
  }

  /// Check if a theme is favorited
  bool isFavorite(String themeId) {
    return _themeRepo.isFavorite(themeId);
  }

  /// Save a custom theme
  Future<void> saveCustomTheme(AppThemeData theme) async {
    await _themeRepo.saveCustomTheme(theme);
    update();
  }

  /// Delete a custom theme
  Future<void> deleteCustomTheme(String themeId) async {
    await _themeRepo.deleteCustomTheme(themeId);

    // If the deleted theme was selected, reset to default
    if (selectedThemeId == themeId) {
      await selectTheme('minimal_dark');
    }
    update();
  }

  /// Get all themes including custom ones
  List<AppThemeData> get allThemes => _themeRepo.getAllThemes();
}
