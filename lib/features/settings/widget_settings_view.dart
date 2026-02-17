import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mango/core/theme/app_colors.dart';
import 'package:mango/core/theme/app_typography.dart';
import 'package:mango/features/home/home_controller.dart';
import 'package:mango/services/widget_service.dart';

class WidgetSettingsView extends StatelessWidget {
  final bool isLockScreen;

  const WidgetSettingsView({super.key, this.isLockScreen = false});

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          isLockScreen ? 'Lock Screen' : 'Home Screen',
          style: AppTypography.titleLarge,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isLockScreen ? 'Lock Screen Widget' : 'Home Screen Widget',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _WidgetPreviewCard(
              title: homeCtrl.currentAffirmation?.text ?? 'Affirmation text',
              category: homeCtrl.currentCategory?.name ?? 'Mango',
              isLockScreen: isLockScreen,
            ),
            const SizedBox(height: 48),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    size: 32,
                    color: AppColors.accent,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'How to add widgets',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isLockScreen
                        ? '1. Long press on your Lock Screen\n2. Tap "Customize" and select Lock Screen\n3. Tap on the widget area\n4. Search for "Mango" and add it!'
                        : '1. Long press on your Home Screen\n2. Tap the plus (+) icon or "Widgets"\n3. Search for "Mango"\n4. Choose your favorite widget style!',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Add Widget Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                onPressed: () async {
                  final opened = await WidgetService.openWidgetGallery();
                  if (!opened) {
                    Get.snackbar(
                      'Widget Gallery',
                      'Please add Mango widgets from your Home Screen or Lock Screen.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.surface,
                      colorText: Colors.white,
                    );
                  }
                },
                icon: const Icon(Icons.add_rounded),
                label: Text(
                  isLockScreen
                      ? 'Add Lock Screen Widget'
                      : 'Add Home Screen Widget',
                  style: AppTypography.labelLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WidgetPreviewCard extends StatelessWidget {
  final String title;
  final String category;
  final bool isLockScreen;

  const _WidgetPreviewCard({
    required this.title,
    required this.category,
    required this.isLockScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: CachedNetworkImageProvider(
            'https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?q=80&w=1000&auto=format&fit=crop',
          ),
          fit: BoxFit.cover,
          opacity: 0.5,
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white12),
      ),
      child: Center(
        child:
            isLockScreen
                ? _LockScreenPreview(text: title)
                : _HomeScreenPreview(text: title, category: category),
      ),
    );
  }
}

class _HomeScreenPreview extends StatelessWidget {
  final String text;
  final String category;

  const _HomeScreenPreview({required this.text, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A1F1D),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontStyle: FontStyle.italic,
              fontFamily: 'serif',
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            category.toUpperCase(),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 8,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _LockScreenPreview extends StatelessWidget {
  final String text;

  const _LockScreenPreview({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          const Icon(Icons.spa_rounded, color: Colors.white70, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
