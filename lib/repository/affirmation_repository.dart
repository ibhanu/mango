import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter/services.dart';
import 'package:mango/core/constants/app_constants.dart';
import 'package:mango/models/affirmation.dart';
import 'package:mango/models/user_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Repository for managing affirmation data and user preferences
class AffirmationRepository {
  final SharedPreferences _prefs;
  List<Affirmation> _affirmations = [];
  UserPreferences _userPreferences = UserPreferences();

  AffirmationRepository(this._prefs);

  /// Initialize the repository by loading data
  Future<void> init() async {
    await _loadAffirmations();
    await _loadUserPreferences();
  }

  // ============ Affirmation Methods ============

  /// Load affirmations from JSON asset
  Future<void> _loadAffirmations() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/affirmations.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> affirmationList =
          jsonData['affirmations'] as List<dynamic>;

      _affirmations =
          affirmationList
              .map((json) => Affirmation.fromJson(json as Map<String, dynamic>))
              .toList();

      // Load favorites state
      await _loadFavorites();
    } catch (e) {
      log('Error loading affirmations: $e');
      _affirmations = [];
    }
  }

  /// Get all affirmations
  List<Affirmation> get allAffirmations => _affirmations;

  /// Get affirmations by category
  List<Affirmation> getByCategory(String categoryId) {
    return _affirmations.where((a) => a.categoryId == categoryId).toList();
  }

  /// Get affirmations for selected categories
  List<Affirmation> getForSelectedCategories() {
    if (_userPreferences.selectedCategoryIds.isEmpty) {
      return _affirmations;
    }
    return _affirmations
        .where(
          (a) => _userPreferences.selectedCategoryIds.contains(a.categoryId),
        )
        .toList();
  }

  /// Get a random daily affirmation
  Affirmation? getRandomAffirmation() {
    final selected = getForSelectedCategories();
    if (selected.isEmpty) return null;
    selected.shuffle();
    return selected.first;
  }

  /// Get favorite affirmations
  List<Affirmation> getFavorites() {
    return _affirmations.where((a) => a.isFavorite).toList();
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(String affirmationId) async {
    final index = _affirmations.indexWhere((a) => a.id == affirmationId);
    if (index != -1) {
      _affirmations[index].isFavorite = !_affirmations[index].isFavorite;
      await _saveFavorites();
    }
  }

  /// Load favorites from storage
  Future<void> _loadFavorites() async {
    final favoriteIds =
        _prefs.getStringList(AppConstants.keyFavoriteAffirmations) ?? [];
    for (var affirmation in _affirmations) {
      affirmation.isFavorite = favoriteIds.contains(affirmation.id);
    }
  }

  /// Save favorites to storage
  Future<void> _saveFavorites() async {
    final favoriteIds =
        _affirmations.where((a) => a.isFavorite).map((a) => a.id).toList();
    await _prefs.setStringList(
      AppConstants.keyFavoriteAffirmations,
      favoriteIds,
    );
  }

  // ============ User Preferences Methods ============

  /// Load user preferences from storage
  Future<void> _loadUserPreferences() async {
    final isFirstLaunch = _prefs.getBool(AppConstants.keyIsFirstLaunch) ?? true;
    final userName = _prefs.getString(AppConstants.keyUserName) ?? '';
    final occupation = _prefs.getString(AppConstants.keyUserOccupation) ?? '';
    final relationshipStatus =
        _prefs.getString(AppConstants.keyUserRelationship) ?? '';
    final notificationFrequency =
        _prefs.getInt(AppConstants.keyNotificationFrequency) ?? 1;
    final isCommitted = _prefs.getBool(AppConstants.keyIsCommitted) ?? false;

    final selectedCategories =
        _prefs.getStringList(AppConstants.keySelectedCategories) ?? [];
    final notificationHour =
        _prefs.getInt('${AppConstants.keyNotificationTime}_hour') ?? 9;
    final notificationMinute =
        _prefs.getInt('${AppConstants.keyNotificationTime}_minute') ?? 0;
    final notificationsEnabled =
        _prefs.getBool(AppConstants.keyNotificationsEnabled) ?? true;
    final favoriteIds =
        _prefs.getStringList(AppConstants.keyFavoriteAffirmations) ?? [];
    final dailyStreak = _prefs.getInt(AppConstants.keyDailyStreak) ?? 0;
    final lastActiveDateStr = _prefs.getString(AppConstants.keyLastActiveDate);

    _userPreferences = UserPreferences(
      isFirstLaunch: isFirstLaunch,
      userName: userName,
      occupation: occupation,
      relationshipStatus: relationshipStatus,
      notificationFrequency: notificationFrequency,
      isCommitted: isCommitted,
      selectedCategoryIds: selectedCategories,
      notificationTime: TimeOfDay(
        hour: notificationHour,
        minute: notificationMinute,
      ),
      notificationsEnabled: notificationsEnabled,
      favoriteAffirmationIds: favoriteIds,
      dailyStreak: dailyStreak,
      lastActiveDate:
          lastActiveDateStr != null ? DateTime.parse(lastActiveDateStr) : null,
    );
  }

  /// Get current user preferences
  UserPreferences get userPreferences => _userPreferences;

  /// Check if first launch
  bool get isFirstLaunch => _userPreferences.isFirstLaunch;

  /// Complete onboarding
  Future<void> completeOnboarding() async {
    _userPreferences = _userPreferences.copyWith(isFirstLaunch: false);
    await _prefs.setBool(AppConstants.keyIsFirstLaunch, false);
  }

  /// Update personalization info
  Future<void> setPersonalization({
    String? name,
    String? occupation,
    String? relationship,
    int? frequency,
    bool? committed,
  }) async {
    _userPreferences = _userPreferences.copyWith(
      userName: name,
      occupation: occupation,
      relationshipStatus: relationship,
      notificationFrequency: frequency,
      isCommitted: committed,
    );

    if (name != null) await _prefs.setString(AppConstants.keyUserName, name);
    if (occupation != null) {
      await _prefs.setString(AppConstants.keyUserOccupation, occupation);
    }
    if (relationship != null) {
      await _prefs.setString(AppConstants.keyUserRelationship, relationship);
    }
    if (frequency != null) {
      await _prefs.setInt(AppConstants.keyNotificationFrequency, frequency);
    }
    if (committed != null) {
      await _prefs.setBool(AppConstants.keyIsCommitted, committed);
    }
  }

  /// Update selected categories
  Future<void> setSelectedCategories(List<String> categoryIds) async {
    _userPreferences = _userPreferences.copyWith(
      selectedCategoryIds: categoryIds,
    );
    await _prefs.setStringList(AppConstants.keySelectedCategories, categoryIds);
  }

  /// Update notification time
  Future<void> setNotificationTime(TimeOfDay time) async {
    _userPreferences = _userPreferences.copyWith(notificationTime: time);
    await _prefs.setInt('${AppConstants.keyNotificationTime}_hour', time.hour);
    await _prefs.setInt(
      '${AppConstants.keyNotificationTime}_minute',
      time.minute,
    );
  }

  /// Enable/disable notifications
  Future<void> setNotificationsEnabled(bool enabled) async {
    _userPreferences = _userPreferences.copyWith(notificationsEnabled: enabled);
    await _prefs.setBool(AppConstants.keyNotificationsEnabled, enabled);
  }

  /// Update daily streak
  Future<void> updateStreak() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastActive = _userPreferences.lastActiveDate;

    int newStreak = _userPreferences.dailyStreak;

    if (lastActive == null) {
      newStreak = 1;
    } else {
      final lastActiveDay = DateTime(
        lastActive.year,
        lastActive.month,
        lastActive.day,
      );
      final difference = today.difference(lastActiveDay).inDays;

      if (difference == 1) {
        // Consecutive day
        newStreak = _userPreferences.dailyStreak + 1;
      } else if (difference > 1) {
        // Streak broken
        newStreak = 1;
      }
      // If difference == 0, keep the same streak (same day)
    }

    _userPreferences = _userPreferences.copyWith(
      dailyStreak: newStreak,
      lastActiveDate: now,
    );
    await _prefs.setInt(AppConstants.keyDailyStreak, newStreak);
    await _prefs.setString(
      AppConstants.keyLastActiveDate,
      now.toIso8601String(),
    );
  }

  /// Get current streak
  int get dailyStreak => _userPreferences.dailyStreak;
}
