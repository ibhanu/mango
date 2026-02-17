import 'package:home_widget/home_widget.dart';
import 'package:mango/core/di/service_locator.dart';
import 'package:mango/models/category.dart';
import 'package:mango/repository/affirmation_repository.dart';
import 'package:mango/services/mascot_service.dart';
import 'package:mango/services/streak_service.dart';

/// Service to centralize Home Screen and Lock Screen widget updates
class WidgetService {
  final AffirmationRepository _repository = getIt<AffirmationRepository>();
  final MascotService _mascotService = getIt<MascotService>();
  final StreakService _streakService = getIt<StreakService>();

  /// Update all widgets with the latest data
  Future<void> updateAllWidgets() async {
    final affirmation = _repository.getRandomAffirmation();
    if (affirmation == null) return;

    final category = AppCategories.getById(affirmation.categoryId);

    // Save Classic Widget Data
    await HomeWidget.saveWidgetData<String>(
      'affirmation_text',
      affirmation.text,
    );
    await HomeWidget.saveWidgetData<String>(
      'category_text',
      category?.name ?? 'Mango',
    );
    await HomeWidget.saveWidgetData<int>(
      'daily_streak',
      _repository.dailyStreak,
    );
    await HomeWidget.saveWidgetData<String>(
      'mascot_asset',
      _mascotService.mascotAsset,
    );
    await HomeWidget.saveWidgetData<String>(
      'evolution_name',
      _mascotService.evolutionName,
    );

    // Save cycling affirmations
    final affirmations = _repository.getForSelectedCategories();
    final List<String> widgetAffirmations =
        affirmations.take(12).map((a) => a.text).toList();
    await HomeWidget.saveWidgetData<String>(
      'affirmations_list',
      widgetAffirmations.join('|||'),
    );

    // Save Streak Widget Data
    await HomeWidget.saveWidgetData<double>(
      'monthly_consistency',
      _streakService.monthlyConsistency,
    );

    final now = DateTime.now();
    String activity7Days = "";
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      activity7Days += _streakService.wasActiveOn(date) ? "1" : "0";
    }
    await HomeWidget.saveWidgetData<String>('activity_7days', activity7Days);

    // Trigger updates
    await HomeWidget.updateWidget(
      name: 'MangoWidgetProvider',
      iOSName: 'MangoWidget',
    );
    await HomeWidget.updateWidget(
      name: 'MangoWidgetRectProvider',
      iOSName: 'MangoWidget',
    );
    await HomeWidget.updateWidget(
      name: 'StreakWidgetProvider',
      iOSName: 'MangoWidget',
    );
  }

  /// Open the system widget gallery to help user add widgets
  static Future<bool> openWidgetGallery() async {
    // Note: HomeWidget doesn't have a direct "open gallery" method for iOS,
    // but some apps use specific URL schemes or just show instructions.
    // For now, we return false to trigger the fallback instructions in the UI,
    // as iOS doesn't officially allow opening the widget gallery programmatically.
    return false;
  }
}
