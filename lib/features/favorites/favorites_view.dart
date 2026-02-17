import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:mango/core/theme/app_colors.dart';
import 'package:mango/core/theme/app_typography.dart';
import 'package:mango/features/favorites/favorites_controller.dart';

/// Favorites list screen
class FavoritesView extends StatelessWidget {
  final bool isEmbedded;

  const FavoritesView({super.key, this.isEmbedded = false});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FavoritesController>(
      init: FavoritesController(),
      builder: (ctrl) {
        Widget content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.only(
                top: isEmbedded ? 0 : MediaQuery.of(context).padding.top,
                left: 24,
                right: 24,
                bottom: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isEmbedded) ...[
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, size: 28),
                      onPressed: () => Get.back(),
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                    ),
                    const SizedBox(height: 16),
                  ],
                  Text('Favorites', style: AppTypography.displaySmall),
                  const SizedBox(height: 8),
                  Text(
                    'Your saved affirmations',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                onChanged: ctrl.updateSearch,
                style: AppTypography.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Search favorites...',
                  hintStyle: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.textTertiary,
                  ),
                  fillColor: AppColors.surface,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Favorites list
            Expanded(
              child: Builder(
                builder: (context) {
                  final favorites = ctrl.filteredFavorites;

                  if (favorites.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border_rounded,
                            size: 64,
                            color: AppColors.surfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            ctrl.searchQuery.isNotEmpty
                                ? 'No matching favorites'
                                : 'No favorites yet',
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap the heart icon on any affirmation\nto save it here',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textTertiary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final affirmation = favorites[index];
                      final category = ctrl.getCategoryFor(
                        affirmation.categoryId,
                      );

                      return Dismissible(
                            key: Key(affirmation.id),
                            direction: DismissDirection.endToStart,
                            onDismissed:
                                (_) => ctrl.removeFromFavorites(affirmation.id),
                            background: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: AppColors.error.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 24),
                              child: const Icon(
                                Icons.delete_rounded,
                                color: AppColors.error,
                              ),
                            ),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (category != null)
                                    Text(
                                      category.name.toUpperCase(),
                                      style: AppTypography.labelSmall.copyWith(
                                        color: AppColors.accent,
                                        letterSpacing: 1.2,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  const SizedBox(height: 8),
                                  Text(
                                    affirmation.text,
                                    style: AppTypography.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                          )
                          .animate(delay: (index * 50).ms)
                          .fadeIn()
                          .slideX(begin: 0.1);
                    },
                  );
                },
              ),
            ),
          ],
        );

        if (isEmbedded) return SafeArea(child: content);
        return Scaffold(backgroundColor: AppColors.background, body: content);
      },
    );
  }
}
