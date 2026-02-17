import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mango/core/di/service_locator.dart';
import 'package:mango/core/widgets/mango_time_picker.dart';
import 'package:mango/repository/affirmation_repository.dart';
import 'package:mango/repository/notification_service.dart';
import 'package:mango/services/streak_service.dart';
import 'package:share_plus/share_plus.dart';

/// Controller for settings screen
class SettingsController extends GetxController {
  final AffirmationRepository _repository = getIt<AffirmationRepository>();
  final NotificationService _notificationService = getIt<NotificationService>();
  final StreakService _streakService = getIt<StreakService>();

  // Notification settings
  TimeOfDay notificationTime = const TimeOfDay(hour: 9, minute: 0);
  bool notificationsEnabled = true;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  void _loadSettings() {
    final prefs = _repository.userPreferences;
    notificationTime = prefs.notificationTime;
    notificationsEnabled = prefs.notificationsEnabled;
  }

  /// Toggle notifications
  Future<void> toggleNotifications(bool enabled) async {
    notificationsEnabled = enabled;
    await _repository.setNotificationsEnabled(enabled);

    if (enabled) {
      final prefs = _repository.userPreferences;
      await _notificationService.scheduleDailyNotifications(
        startTime: notificationTime,
        frequency: prefs.notificationFrequency,
      );
    } else {
      await _notificationService.cancelAllNotifications();
    }
    update();
  }

  /// Set notification time
  Future<void> setNotificationTime(BuildContext context) async {
    final picked = await MangoTimePicker.show(
      context,
      initialTime: notificationTime,
    );

    if (picked != null) {
      notificationTime = picked;
      await _repository.setNotificationTime(picked);

      if (notificationsEnabled) {
        final prefs = _repository.userPreferences;
        await _notificationService.scheduleDailyNotifications(
          startTime: picked,
          frequency: prefs.notificationFrequency,
        );
      }
      update();
    }
  }

  /// Get daily streak
  int get dailyStreak => _repository.dailyStreak;

  /// Get total favorites count
  int get favoritesCount => _repository.getFavorites().length;

  /// Get total affirmations count
  int get totalAffirmations => _repository.allAffirmations.length;

  Future<void> shareStreak() async {
    await Share.share(
      'I have a $dailyStreak-day affirmation streak on Mango! 🥭\nNurturing my mind, one step at a time.',
    );
  }

  /// Get boolean list of activity for the last 7 days (today included)
  List<bool> getLast7DaysActivity() {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final date = now.subtract(Duration(days: 6 - i));
      return _streakService.wasActiveOn(date);
    });
  }

  /// Get the consistency percentage
  double get consistency => _streakService.monthlyConsistency;
}
