import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:mango/core/routes/app_routes.dart';
import 'package:mango/core/theme/app_colors.dart';
import 'package:mango/core/theme/app_typography.dart';
import 'package:mango/core/utils/haptics.dart';
import 'package:mango/features/home/home_controller.dart';
import 'package:mango/features/themes/themes_controller.dart';
import 'package:mango/models/app_theme_model.dart';

/// Screen to select visual themes/backgrounds
class ThemesView extends StatelessWidget {
  final bool isEmbedded;

  const ThemesView({super.key, this.isEmbedded = false});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemesController>(
      init: ThemesController(),
      builder: (ctrl) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
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
                              padding: EdgeInsets.zero,
                              alignment: Alignment.centerLeft,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Themes',
                          style: AppTypography.displaySmall.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Choose a mindful background for your affirmations',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Category filter chips
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              // Create button
                              GestureDetector(
                                onTap: () {
                                  AppHaptics.medium();
                                  Get.toNamed(AppRoutes.createTheme);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(color: AppColors.accent),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.add_rounded,
                                        size: 18,
                                        color: AppColors.accent,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Create',
                                        style: AppTypography.labelLarge
                                            .copyWith(
                                              color: AppColors.accent,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Category chips
                              ...ctrl.categories
                                  .where((c) => c != ThemeCategory.myThemes)
                                  .map((category) {
                                    final isSelected =
                                        ctrl.selectedCategory == category;
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: GestureDetector(
                                        onTap: () {
                                          AppHaptics.selection();
                                          ctrl.selectCategory(category);
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 200,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                isSelected
                                                    ? AppColors.textPrimary
                                                    : Colors.white.withValues(
                                                      alpha: 0.1,
                                                    ),
                                            borderRadius: BorderRadius.circular(
                                              24,
                                            ),
                                          ),
                                          child: Text(
                                            category.label,
                                            style: AppTypography.labelLarge
                                                .copyWith(
                                                  color:
                                                      isSelected
                                                          ? AppColors.background
                                                          : AppColors
                                                              .textPrimary,
                                                  fontWeight:
                                                      isSelected
                                                          ? FontWeight.w700
                                                          : FontWeight.w500,
                                                ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Theme Mixes Section (featured)
                if (ctrl.selectedCategory == ThemeCategory.all) ...[
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          child: Text(
                            'Featured',
                            style: AppTypography.headlineSmall,
                          ),
                        ),
                        SizedBox(
                          height: 120,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            scrollDirection: Axis.horizontal,
                            itemCount: ctrl.themeMixes.length,
                            separatorBuilder:
                                (_, __) => const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final theme = ctrl.themeMixes[index];
                              return _ThemeMixTile(
                                theme: theme,
                                onTap:
                                    () =>
                                        _showThemePreview(context, theme, ctrl),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                ],

                // My Themes Section (if has custom themes)
                if (ctrl.customThemes.isNotEmpty &&
                    ctrl.selectedCategory == ThemeCategory.all) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24, bottom: 16),
                      child: Text(
                        'My Themes',
                        style: AppTypography.headlineSmall,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 160,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        scrollDirection: Axis.horizontal,
                        itemCount: ctrl.customThemes.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final theme = ctrl.customThemes[index];
                          final isSelected = ctrl.selectedThemeId == theme.id;
                          return _CustomThemeTile(
                            theme: theme,
                            isSelected: isSelected,
                            onTap: () {
                              AppHaptics.medium();
                              _showThemePreview(context, theme, ctrl);
                            },
                            onLongPress: () {
                              AppHaptics.heavy();
                              _showDeleteDialog(context, theme, ctrl);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                ],

                // Theme Grid
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24, bottom: 16),
                    child: Text(
                      ctrl.selectedCategory == ThemeCategory.all
                          ? 'All Themes'
                          : ctrl.selectedCategory.label,
                      style: AppTypography.headlineSmall,
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final theme = ctrl.filteredThemes[index];
                      final isSelected = ctrl.selectedThemeId == theme.id;

                      return _ThemeGridTile(
                        theme: theme,
                        isSelected: isSelected,
                        onTap: () {
                          AppHaptics.medium();
                          _showThemePreview(context, theme, ctrl);
                        },
                        onFavorite: () {
                          AppHaptics.light();
                          ctrl.toggleFavorite(theme.id);
                        },
                      ).animate().fadeIn(delay: (index * 50).ms);
                    }, childCount: ctrl.filteredThemes.length),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showThemePreview(
    BuildContext context,
    AppThemeData theme,
    ThemesController ctrl,
  ) {
    Get.toNamed(AppRoutes.themePreview, arguments: theme);
  }

  void _showDeleteDialog(
    BuildContext context,
    AppThemeData theme,
    ThemesController ctrl,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.surface,
            title: Text('Delete Theme?', style: AppTypography.titleLarge),
            content: Text(
              'Are you sure you want to delete "${theme.name}"?',
              style: AppTypography.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  ctrl.deleteCustomTheme(theme.id);
                  Navigator.pop(context);
                },
                child: Text('Delete', style: TextStyle(color: AppColors.error)),
              ),
            ],
          ),
    );
  }
}

/// Featured theme mix tile
class _ThemeMixTile extends StatelessWidget {
  final AppThemeData theme;
  final VoidCallback onTap;

  const _ThemeMixTile({required this.theme, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: theme.solidColor,
          gradient: theme.gradient,
          image:
              theme.imageUrl != null
                  ? DecorationImage(
                    image:
                        theme.isLocalImage
                            ? FileImage(File(theme.imageUrl!)) as ImageProvider
                            : CachedNetworkImageProvider(theme.imageUrl!),
                    fit: BoxFit.cover,
                  )
                  : null,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: (theme.overlayColor ?? Colors.black).withValues(
              alpha: theme.overlayOpacity,
            ),
          ),
          child: Center(
            child: Text(
              theme.name,
              style: AppTypography.titleMedium.copyWith(
                color: theme.textColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom theme tile with delete option
class _CustomThemeTile extends StatelessWidget {
  final AppThemeData theme;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _CustomThemeTile({
    required this.theme,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: theme.solidColor,
          gradient: theme.gradient,
          image:
              theme.imageUrl != null
                  ? DecorationImage(
                    image:
                        theme.isLocalImage
                            ? FileImage(File(theme.imageUrl!)) as ImageProvider
                            : CachedNetworkImageProvider(theme.imageUrl!),
                    fit: BoxFit.cover,
                  )
                  : null,
          border:
              isSelected ? Border.all(color: AppColors.accent, width: 3) : null,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: (theme.overlayColor ?? Colors.black).withValues(
              alpha: theme.overlayOpacity,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  theme.name,
                  style: AppTypography.labelLarge.copyWith(
                    color: theme.textColor,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Theme grid tile
class _ThemeGridTile extends StatelessWidget {
  final AppThemeData theme;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const _ThemeGridTile({
    required this.theme,
    required this.isSelected,
    required this.onTap,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: theme.solidColor,
          gradient: theme.gradient,
          image:
              theme.imageUrl != null
                  ? DecorationImage(
                    image:
                        theme.isLocalImage
                            ? FileImage(File(theme.imageUrl!)) as ImageProvider
                            : CachedNetworkImageProvider(theme.imageUrl!),
                    fit: BoxFit.cover,
                  )
                  : null,
          border:
              isSelected ? Border.all(color: AppColors.accent, width: 3) : null,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                (theme.overlayColor ?? Colors.black).withValues(
                  alpha: theme.overlayOpacity + 0.2,
                ),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Favorite button
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onFavorite,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      theme.isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 18,
                      color: theme.isFavorite ? AppColors.error : Colors.white,
                    ),
                  ),
                ),
              ),

              // Selected indicator
              if (isSelected)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 16,
                      color: AppColors.background,
                    ),
                  ),
                ),

              // Theme name
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      theme.name,
                      style: AppTypography.titleSmall.copyWith(
                        color: theme.textColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      theme.category.label,
                      style: AppTypography.labelSmall.copyWith(
                        color: theme.textColor.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
