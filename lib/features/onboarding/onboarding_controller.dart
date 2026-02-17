import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mango/core/di/service_locator.dart';
import 'package:mango/core/routes/app_routes.dart';
import 'package:mango/models/category.dart';
import 'package:mango/repository/affirmation_repository.dart';
import 'package:mango/repository/notification_service.dart';
import 'package:mango/services/widget_service.dart';

/// Controller for onboarding flow
class OnboardingController extends GetxController {
  final AffirmationRepository _repository = getIt<AffirmationRepository>();
  final NotificationService _notificationService = getIt<NotificationService>();
  final WidgetService _widgetService = getIt<WidgetService>();

  int currentPage = 0;
  final PageController pageController = PageController();

  // 1. Welcome (Index 0)

  // 2. Personal Info (Index 1)
  String userName = '';

  // 3. Pursuit (Index 2)
  String occupation = '';

  // 4. Partnership (Index 3)
  String relationshipStatus = '';

  // 5. Category selection (Index 4)
  List<String> selectedCategories = [];

  // 6. Notification frequency & time (Index 5)
  TimeOfDay notificationTime = const TimeOfDay(hour: 9, minute: 0);
  int notificationFrequency = 3; // Default 3 times a day
  bool notificationsEnabled = true;

  // 7. Commitment (Index 6)
  bool isCommitted = false;

  // All available categories
  List<AffirmationCategory> get categories => AppCategories.all;

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  /// Toggle category selection
  void toggleCategory(String categoryId) {
    if (selectedCategories.contains(categoryId)) {
      selectedCategories.remove(categoryId);
    } else {
      selectedCategories.add(categoryId);
    }
    update();
  }

  /// Check if category is selected
  bool isCategorySelected(String categoryId) {
    return selectedCategories.contains(categoryId);
  }

  /// Set user name
  void setUserName(String name) {
    userName = name;
    update();
  }

  /// Set occupation and auto-advance
  void setOccupation(String value) {
    occupation = value;
    update();
    _autoAdvance();
  }

  /// Set relationship and auto-advance
  void setRelationship(String value) {
    relationshipStatus = value;
    update();
    _autoAdvance();
  }

  /// Set notification frequency and auto-advance
  void setFrequency(int value) {
    notificationFrequency = value;
    update();
    _autoAdvance();
  }

  /// Set commitment
  void setCommitted(bool value) {
    isCommitted = value;
    update();
  }

  /// Set notification time
  Future<void> pickNotificationTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: notificationTime,
    );

    if (picked != null) {
      notificationTime = picked;
      update();
    }
  }

  /// Update notification time directly
  void updateNotificationTime(TimeOfDay time) {
    notificationTime = time;
    update();
  }

  /// Set notifications enabled
  Future<void> setNotificationsEnabled(bool value) async {
    notificationsEnabled = value;
    if (value) {
      await _notificationService.requestPermissions();
    }
    update();
  }

  /// Handle page change
  void onPageChanged(int index) {
    currentPage = index;
    update();
  }

  /// Auto-advance helper
  void _autoAdvance() {
    Future.delayed(const Duration(milliseconds: 400), () {
      nextPage();
    });
  }

  /// Go to next page
  void nextPage() {
    if (currentPage < 6) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  /// Go to previous page
  void previousPage() {
    if (currentPage > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  /// Complete onboarding
  Future<void> completeOnboarding() async {
    // Save everything
    await _repository.setPersonalization(
      name: userName,
      occupation: occupation,
      relationship: relationshipStatus,
      frequency: notificationFrequency,
      committed: isCommitted,
    );

    final categoriesToSave =
        selectedCategories.isEmpty
            ? categories.map((c) => c.id).toList()
            : selectedCategories.toList();

    await _repository.setSelectedCategories(categoriesToSave);
    await _repository.setNotificationsEnabled(notificationsEnabled);
    await _repository.setNotificationTime(notificationTime);

    if (notificationsEnabled) {
      await _notificationService.scheduleDailyNotifications(
        startTime: notificationTime,
        frequency: notificationFrequency,
      );
    }

    await _repository.completeOnboarding();
    _widgetService.updateAllWidgets();
    Get.offAllNamed(AppRoutes.home);
  }

  /// Skip onboarding
  Future<void> skipOnboarding() async {
    await _repository.setSelectedCategories(
      categories.map((c) => c.id).toList(),
    );
    await _repository.completeOnboarding();
    _widgetService.updateAllWidgets();
    Get.offAllNamed(AppRoutes.home);
  }
}
