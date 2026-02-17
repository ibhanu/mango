import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:mango/core/di/service_locator.dart';
import 'package:mango/models/affirmation.dart';
import 'package:mango/models/category.dart';
import 'package:mango/models/user_preferences.dart';
import 'package:mango/repository/affirmation_repository.dart';
import 'package:mango/services/streak_service.dart';
import 'package:mango/services/widget_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:share_plus/share_plus.dart';

/// Controller for home screen
class HomeController extends GetxController {
  final AffirmationRepository _repository = getIt<AffirmationRepository>();
  final StreakService _streakService = getIt<StreakService>();
  final WidgetService _widgetService = getIt<WidgetService>();

  // PageController for the Mango Stack PageView
  late PageController pageController;

  // Stream for parallax sensors
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  double parallaxX = 0;
  double parallaxY = 0;

  // Current affirmation list for selected categories
  List<Affirmation> affirmations = [];

  // Current index in the affirmation list
  int currentIndex = 0;

  // Bottom nav index
  int navIndex = 0;

  // Loading state
  bool isLoading = true;

  // Key for capturing the shareable widget
  final GlobalKey boundaryKey = GlobalKey();

  // Sharing state
  bool isSharing = false;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(viewportFraction: 1.0);
    _loadAffirmations();
    _initParallax();
    _markActivity();
  }

  void _markActivity() async {
    await _streakService.markTodayAsActive();
    _updateWidget();
    update();
  }

  @override
  void onClose() {
    pageController.dispose();
    _accelerometerSubscription?.cancel();
    super.onClose();
  }

  void _initParallax() {
    _accelerometerSubscription = accelerometerEventStream(
      samplingPeriod: SensorInterval.gameInterval,
    ).listen((event) {
      if (navIndex == 0) {
        parallaxX = event.x * 2.5; // Sensitivity
        parallaxY = event.y * 2.5;
        update(['parallax']);
      }
    });
  }

  /// Load affirmations based on selected categories
  void _loadAffirmations() {
    affirmations = _repository.getForSelectedCategories();
    affirmations.shuffle(); // Randomize order
    isLoading = false;
  }

  /// Get current affirmation
  Affirmation? get currentAffirmation {
    if (affirmations.isEmpty) return null;
    return affirmations[currentIndex];
  }

  /// Get category for current affirmation
  AffirmationCategory? get currentCategory {
    final affirmation = currentAffirmation;
    if (affirmation == null) return null;
    return AppCategories.getById(affirmation.categoryId);
  }

  /// Get user's daily streak
  int get dailyStreak => _repository.dailyStreak;

  /// Go to next affirmation
  void nextAffirmation() {
    if (currentIndex < affirmations.length - 1) {
      currentIndex++;
      pageController.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
      );
    } else {
      // Loop back to start with reshuffled list
      affirmations.shuffle();
      currentIndex = 0;
      pageController.jumpToPage(0);
    }
    _updateWidget();
    update();
  }

  /// Go to previous affirmation
  void previousAffirmation() {
    if (currentIndex > 0) {
      currentIndex--;
      pageController.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
      );
      _updateWidget();
      update();
    }
  }

  /// Handle PageView page changes
  void onPageChanged(int index) {
    currentIndex = index;
    _updateWidget();
    update();
  }

  /// Toggle favorite status
  Future<void> toggleFavorite() async {
    final affirmation = currentAffirmation;
    if (affirmation == null) return;

    await _repository.toggleFavorite(affirmation.id);

    // Local state is updated because the repository modifies the underlying object
    // but we can explicitly set it to ensure consistency if needed,
    // or just trigger an update.
    update();
  }

  /// Share current affirmation as a branded image
  Future<void> shareAffirmation({Rect? sharePositionOrigin}) async {
    final affirmation = currentAffirmation;
    if (affirmation == null || isSharing) return;

    try {
      isSharing = true;
      update();

      // Give it a frame to ensure the RepaintBoundary is ready
      await Future.delayed(const Duration(milliseconds: 50));

      final RenderRepaintBoundary? boundary =
          boundaryKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;

      if (boundary == null) {
        isSharing = false;
        update();
        return;
      }

      // Capture image
      final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        isSharing = false;
        update();
        return;
      }

      final Uint8List pngBytes = byteData.buffer.asUint8List();

      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final file =
          await File(
            '${tempDir.path}/affirmation_${affirmation.id}.png',
          ).create();
      await file.writeAsBytes(pngBytes);

      final category = currentCategory;
      final categoryName = category?.name ?? 'Affirmation';

      // Share
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: '$categoryName Affirmation',
        text: '"${affirmation.text}"\n\n~ via Mango 🥭',
        sharePositionOrigin: sharePositionOrigin,
      );
    } catch (e) {
      debugPrint('Error sharing affirmation: $e');
    } finally {
      isSharing = false;
      update();
    }
  }

  /// Refresh affirmations list
  void refreshAffirmations() {
    _loadAffirmations();
    _updateWidget();
    update();
  }

  /// Get current user preferences
  UserPreferences get userPreferences => _repository.userPreferences;

  /// Update Home & Lock Screen Widgets
  void _updateWidget() {
    _widgetService.updateAllWidgets();
  }

  /// Handle bottom navigation
  void onNavTap(int index) {
    navIndex = index;
    update();
  }
}
