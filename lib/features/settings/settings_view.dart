import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mango/core/constants/app_constants.dart';
import 'package:mango/core/routes/app_routes.dart';
import 'package:mango/core/theme/app_colors.dart';
import 'package:mango/core/theme/app_typography.dart';
import 'package:mango/core/utils/haptics.dart';
import 'package:mango/features/home/home_controller.dart';
import 'package:mango/features/settings/settings_controller.dart';
import 'package:mango/features/settings/widget_settings_view.dart';

/// Settings screen (Profile)
class SettingsView extends StatelessWidget {
  final bool isEmbedded;

  const SettingsView({super.key, this.isEmbedded = false});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      init: SettingsController(),
      builder: (ctrl) {
        Widget content = SingleChildScrollView(
          padding: EdgeInsets.only(
            top: isEmbedded ? 0 : MediaQuery.of(context).padding.top,
            bottom: 120, // Extra space for bottom bar
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingL,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 28),
                      onPressed: () {
                        AppHaptics.light();
                        if (isEmbedded) {
                          Get.find<HomeController>().onNavTap(0);
                        } else {
                          Get.back();
                        }
                      },
                    ),
                    Text('Profile', style: AppTypography.displaySmall),
                    IconButton(
                      icon: const Icon(Icons.settings_outlined, size: 28),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // Unlock All Card
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingL,
                ),
                child: GestureDetector(
                  onTap: () {
                    AppHaptics.medium();
                    Get.snackbar(
                      'Mango Premium',
                      'Premium features coming soon!',
                      backgroundColor: AppColors.surface,
                      colorText: AppColors.textPrimary,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Unlock all',
                                style: AppTypography.titleLarge.copyWith(
                                  color: AppColors.background,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Access all categories, affirmations, themes, and remove ads!',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.background.withValues(
                                    alpha: 0.7,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.diamond_outlined,
                          size: 48,
                          color: AppColors.background,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Streak Card
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingL,
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.accent,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${ctrl.dailyStreak}',
                                style: AppTypography.headlineLarge,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your streak',
                                  style: AppTypography.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Keep it up!',
                                  style: AppTypography.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.ios_share_rounded),
                            onPressed: ctrl.shareStreak,
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_vert_rounded),
                            onPressed: () {
                              Get.snackbar(
                                'Streak Info',
                                'Complete a session every day to keep your streak!',
                                backgroundColor: AppColors.surface,
                                colorText: AppColors.textPrimary,
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: () {
                          final activity = ctrl.getLast7DaysActivity();
                          final now = DateTime.now();
                          final dayNames = [
                            'Mo',
                            'Tu',
                            'We',
                            'Th',
                            'Fr',
                            'Sa',
                            'Su',
                          ];

                          return List.generate(7, (i) {
                            final date = now.subtract(Duration(days: 6 - i));
                            final dayLabel = dayNames[date.weekday - 1];
                            final isActive = activity[i];

                            return Column(
                              children: [
                                Text(
                                  dayLabel,
                                  style: AppTypography.labelSmall.copyWith(
                                    color:
                                        isActive
                                            ? AppColors.textPrimary
                                            : AppColors.textSecondary
                                                .withValues(alpha: 0.5),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color:
                                        isActive
                                            ? AppColors.accentSoft
                                            : AppColors.surfaceVariant,
                                    shape: BoxShape.circle,
                                    border:
                                        isActive
                                            ? Border.all(
                                              color: AppColors.accent,
                                              width: 1,
                                            )
                                            : null,
                                  ),
                                  child:
                                      isActive
                                          ? const Icon(
                                            Icons.check_rounded,
                                            size: 16,
                                            color: AppColors.accent,
                                          )
                                          : null,
                                ),
                              ],
                            );
                          });
                        }(),
                      ),
                      const SizedBox(height: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Monthly Consistency',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                '${(ctrl.consistency * 100).toInt()}%',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: ctrl.consistency,
                              backgroundColor: AppColors.surfaceVariant,
                              valueColor: const AlwaysStoppedAnimation(
                                AppColors.accent,
                              ),
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Customize Section
              _SectionTitle(title: 'Customize the app'),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingL,
                ),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.2,
                  children: [
                    _FeatureTile(
                      icon: Icons.app_registration_rounded,
                      title: 'App icon',
                      onTap:
                          () => Get.snackbar(
                            'App Icon',
                            'Customize your app icon in the next update!',
                            backgroundColor: AppColors.surface,
                            colorText: AppColors.textPrimary,
                          ),
                    ),
                    _FeatureTile(
                      icon: Icons.notifications_none_rounded,
                      title: 'Reminders',
                      onTap: () => ctrl.setNotificationTime(context),
                    ),
                    _FeatureTile(
                      icon: Icons.widgets_outlined,
                      title: 'Home Screen widgets',
                      onTap:
                          () => Get.to(
                            () => const WidgetSettingsView(isLockScreen: false),
                          ),
                    ),
                    _FeatureTile(
                      icon: Icons.lock_outline_rounded,
                      title: 'Lock Screen widgets',
                      onTap:
                          () => Get.to(
                            () => const WidgetSettingsView(isLockScreen: true),
                          ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Content Section
              _SectionTitle(title: 'My content'),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingL,
                ),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 2.2,
                  children: [
                    _ContentTile(
                      icon: Icons.favorite_border_rounded,
                      title: 'Favorites',
                      onTap: () => Get.toNamed(AppRoutes.favorites),
                    ),
                    _ContentTile(
                      icon: Icons.bookmark_border_rounded,
                      title: 'Collections',
                      onTap:
                          () => Get.snackbar(
                            'Collections',
                            'Organize affirmations into collections soon!',
                            backgroundColor: AppColors.surface,
                            colorText: AppColors.textPrimary,
                          ),
                    ),
                    _ContentTile(
                      icon: Icons.edit_note_rounded,
                      title: 'My affirmations',
                      onTap:
                          () => Get.snackbar(
                            'My Content',
                            'Create your own affirmations soon!',
                            backgroundColor: AppColors.surface,
                            colorText: AppColors.textPrimary,
                          ),
                    ),
                    _ContentTile(
                      icon: Icons.history_rounded,
                      title: 'History',
                      onTap:
                          () => Get.snackbar(
                            'History',
                            'View your reading history soon!',
                            backgroundColor: AppColors.surface,
                            colorText: AppColors.textPrimary,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

        if (isEmbedded) {
          return SafeArea(child: content);
        }

        return Scaffold(backgroundColor: AppColors.background, body: content);
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 16),
      child: Text(
        title,
        style: AppTypography.headlineSmall.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const _FeatureTile({required this.icon, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              size: 32,
              color: AppColors.accent.withValues(alpha: 0.6),
            ),
            Text(title, style: AppTypography.titleSmall),
          ],
        ),
      ),
    );
  }
}

class _ContentTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const _ContentTile({required this.icon, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(child: Text(title, style: AppTypography.titleSmall)),
            Icon(
              icon,
              size: 24,
              color: AppColors.accent.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }
}
