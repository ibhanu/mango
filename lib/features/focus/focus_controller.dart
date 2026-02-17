import 'package:get/get.dart';
import 'package:mango/core/di/service_locator.dart';
import 'package:mango/models/category.dart';
import 'package:mango/repository/affirmation_repository.dart';
import 'package:mango/services/widget_service.dart';

/// Controller for the Focus screen (what to focus on)
class FocusController extends GetxController {
  final AffirmationRepository _repository = getIt<AffirmationRepository>();
  final WidgetService _widgetService = getIt<WidgetService>();

  // All available categories/focus areas grouped by section
  List<CategorySection> get sections => AppCategories.sections;

  // Currently selected category IDs
  List<String> selectedCategories = [];

  // Whether the user is in "Make your own mix" mode
  bool isMixMode = false;

  @override
  void onInit() {
    super.onInit();
    _loadPreferences();
  }

  void _loadPreferences() {
    selectedCategories = List.from(
      _repository.userPreferences.selectedCategoryIds,
    );
    update();
  }

  bool isSelected(String categoryId) {
    return selectedCategories.contains(categoryId);
  }

  /// Toggle enter/exit mix mode
  void toggleMixMode() {
    isMixMode = !isMixMode;
    if (!isMixMode) {
      // When exiting (Save), ensure we have at least one selection
      if (selectedCategories.isEmpty) {
        selectedCategories = [AppCategories.all.first.id];
      }
      _savePreferences();
    }
    update();
  }

  Future<void> toggleCategory(String categoryId) async {
    if (selectedCategories.contains(categoryId)) {
      // In mix mode, we allow deselecting everything temporarily
      // but we'll enforce at least one selection on save.
      if (isMixMode || selectedCategories.length > 1) {
        selectedCategories.remove(categoryId);
      }
    } else {
      selectedCategories.add(categoryId);
    }

    if (!isMixMode) {
      await _savePreferences();
    }
    update();
  }

  Future<void> _savePreferences() async {
    await _repository.setSelectedCategories(selectedCategories);
    _widgetService.updateAllWidgets();
  }

  Future<void> selectAll() async {
    selectedCategories = AppCategories.all.map((c) => c.id).toList();
    if (!isMixMode) {
      await _savePreferences();
    }
    update();
  }

  Future<void> clearAll() async {
    selectedCategories.clear();
    update();
  }
}
