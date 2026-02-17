import 'package:mango/core/constants/app_constants.dart';
import 'package:mango/core/di/service_locator.dart';
import 'package:mango/repository/affirmation_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service to handle advanced streak tracking and activity history
class StreakService {
  final SharedPreferences _prefs = getIt<SharedPreferences>();
  final AffirmationRepository _repository = getIt<AffirmationRepository>();

  /// Load activity history (list of ISO date strings)
  List<String> get activityHistory {
    return _prefs.getStringList(AppConstants.keyActivityHistory) ?? [];
  }

  /// Mark today as active
  Future<void> markTodayAsActive() async {
    final now = DateTime.now();
    final todayStr = DateTime(now.year, now.month, now.day).toIso8601String();

    final history = activityHistory;
    if (!history.contains(todayStr)) {
      history.add(todayStr);
      await _prefs.setStringList(AppConstants.keyActivityHistory, history);

      // Also update the repository streak logic
      await _repository.updateStreak();
    }
  }

  /// Get active dates for the last 30 days
  List<DateTime> getRecentActivity() {
    final history = activityHistory;
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));

    return history
        .map((s) => DateTime.parse(s))
        .where((d) => d.isAfter(thirtyDaysAgo))
        .toList();
  }

  /// Check if a specific date was active
  bool wasActiveOn(DateTime date) {
    final dateStr = DateTime(date.year, date.month, date.day).toIso8601String();
    return activityHistory.contains(dateStr);
  }

  /// Calculate the percentage of active days in the last month
  double get monthlyConsistency {
    final recent = getRecentActivity();
    return (recent.length / 30).clamp(0.0, 1.0);
  }
}
