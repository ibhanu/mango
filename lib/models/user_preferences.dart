import 'package:flutter/material.dart';

/// User preferences model
class UserPreferences {
  final bool isFirstLaunch;
  final String userName;
  final String occupation;
  final String relationshipStatus;
  final int notificationFrequency;
  final bool isCommitted;
  final List<String> selectedCategoryIds;
  final TimeOfDay notificationTime;
  final bool notificationsEnabled;
  final List<String> favoriteAffirmationIds;
  final int dailyStreak;
  final DateTime? lastActiveDate;

  UserPreferences({
    this.isFirstLaunch = true,
    this.userName = '',
    this.occupation = '',
    this.relationshipStatus = '',
    this.notificationFrequency = 1,
    this.isCommitted = false,
    this.selectedCategoryIds = const [],
    this.notificationTime = const TimeOfDay(hour: 9, minute: 0),
    this.notificationsEnabled = true,
    this.favoriteAffirmationIds = const [],
    this.dailyStreak = 0,
    this.lastActiveDate,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      isFirstLaunch: json['isFirstLaunch'] as bool? ?? true,
      userName: json['userName'] as String? ?? '',
      occupation: json['occupation'] as String? ?? '',
      relationshipStatus: json['relationshipStatus'] as String? ?? '',
      notificationFrequency: json['notificationFrequency'] as int? ?? 1,
      isCommitted: json['isCommitted'] as bool? ?? false,
      selectedCategoryIds:
          (json['selectedCategoryIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      notificationTime: TimeOfDay(
        hour: json['notificationHour'] as int? ?? 9,
        minute: json['notificationMinute'] as int? ?? 0,
      ),
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      favoriteAffirmationIds:
          (json['favoriteAffirmationIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      dailyStreak: json['dailyStreak'] as int? ?? 0,
      lastActiveDate:
          json['lastActiveDate'] != null
              ? DateTime.parse(json['lastActiveDate'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isFirstLaunch': isFirstLaunch,
      'userName': userName,
      'occupation': occupation,
      'relationshipStatus': relationshipStatus,
      'notificationFrequency': notificationFrequency,
      'isCommitted': isCommitted,
      'selectedCategoryIds': selectedCategoryIds,
      'notificationHour': notificationTime.hour,
      'notificationMinute': notificationTime.minute,
      'notificationsEnabled': notificationsEnabled,
      'favoriteAffirmationIds': favoriteAffirmationIds,
      'dailyStreak': dailyStreak,
      'lastActiveDate': lastActiveDate?.toIso8601String(),
    };
  }

  UserPreferences copyWith({
    bool? isFirstLaunch,
    String? userName,
    String? occupation,
    String? relationshipStatus,
    int? notificationFrequency,
    bool? isCommitted,
    List<String>? selectedCategoryIds,
    TimeOfDay? notificationTime,
    bool? notificationsEnabled,
    List<String>? favoriteAffirmationIds,
    int? dailyStreak,
    DateTime? lastActiveDate,
  }) {
    return UserPreferences(
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
      userName: userName ?? this.userName,
      occupation: occupation ?? this.occupation,
      relationshipStatus: relationshipStatus ?? this.relationshipStatus,
      notificationFrequency:
          notificationFrequency ?? this.notificationFrequency,
      isCommitted: isCommitted ?? this.isCommitted,
      selectedCategoryIds: selectedCategoryIds ?? this.selectedCategoryIds,
      notificationTime: notificationTime ?? this.notificationTime,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      favoriteAffirmationIds:
          favoriteAffirmationIds ?? this.favoriteAffirmationIds,
      dailyStreak: dailyStreak ?? this.dailyStreak,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
    );
  }
}
