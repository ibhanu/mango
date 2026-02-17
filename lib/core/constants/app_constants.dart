/// App-wide constant values
abstract class AppConstants {
  // App Info
  static const String appName = 'Mango';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String keyIsFirstLaunch = 'is_first_launch';
  static const String keyUserName = 'user_name';
  static const String keyUserOccupation = 'user_occupation';
  static const String keyUserRelationship = 'user_relationship';
  static const String keyNotificationFrequency = 'notification_frequency';
  static const String keyIsCommitted = 'is_committed';
  static const String keySelectedCategories = 'selected_categories';
  static const String keyNotificationTime = 'notification_time';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keyFavoriteAffirmations = 'favorite_affirmations';
  static const String keyDailyStreak = 'daily_streak';
  static const String keyLastActiveDate = 'last_active_date';
  static const String keyActivityHistory = 'activity_history';
  static const String keyCurrentAffirmationIndex = 'current_affirmation_index';

  // Notification
  static const int notificationId = 1;
  static const String notificationChannelId = 'mango_daily_affirmation';
  static const String notificationChannelName = 'Daily Affirmations';
  static const String notificationChannelDesc = 'Daily affirmation reminders';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 350);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Padding & Spacing
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;

  // Border Radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusRound = 100.0;
}
