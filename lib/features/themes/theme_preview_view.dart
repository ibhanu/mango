import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mango/core/theme/app_colors.dart';
import 'package:mango/core/theme/app_typography.dart';
import 'package:mango/features/themes/themes_controller.dart';
import 'package:mango/models/app_theme_model.dart';

/// Full-screen theme preview with apply option
class ThemePreviewView extends StatelessWidget {
  const ThemePreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemeData theme = Get.arguments as AppThemeData;

    return GetBuilder<ThemesController>(
      init: ThemesController(),
      builder: (ctrl) {
        final isSelected = ctrl.selectedThemeId == theme.id;

        return Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              // Background
              _buildBackground(theme),

              // Overlay
              Container(
                color: (theme.overlayColor ?? Colors.black).withValues(
                  alpha: theme.overlayOpacity,
                ),
              ),

              // Content
              SafeArea(
                child: Column(
                  children: [
                    // Top bar
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => Get.back(),
                            icon: Icon(
                              Icons.close_rounded,
                              color: theme.textColor,
                              size: 28,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => ctrl.toggleFavorite(theme.id),
                                icon: Icon(
                                  ctrl.isFavorite(theme.id)
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  color:
                                      ctrl.isFavorite(theme.id)
                                          ? AppColors.error
                                          : theme.textColor,
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Preview content
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'I am',
                                style: theme.fontChoice.getTextStyle(
                                  fontSize: 16,
                                  color: theme.textColor.withValues(alpha: 0.7),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Worthy of love\nand success',
                                textAlign: TextAlign.center,
                                style: theme.fontChoice.getTextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w600,
                                  color: theme.textColor,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 32),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.accentColor.withValues(
                                    alpha: 0.2,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  theme.category.label,
                                  style: AppTypography.labelMedium.copyWith(
                                    color: theme.accentColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Bottom action bar
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            (theme.overlayColor ?? Colors.black).withValues(
                              alpha: 0.7,
                            ),
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            theme.name,
                            style: AppTypography.headlineMedium.copyWith(
                              color: theme.textColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            theme.category.label,
                            style: AppTypography.bodyMedium.copyWith(
                              color: theme.textColor.withValues(alpha: 0.7),
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed:
                                  isSelected
                                      ? null
                                      : () async {
                                        await ctrl.selectTheme(theme.id);
                                        Get.back();
                                        Get.snackbar(
                                          'Theme Applied',
                                          '${theme.name} is now your active theme',
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: AppColors.surface,
                                          colorText: AppColors.textPrimary,
                                          margin: const EdgeInsets.all(16),
                                        );
                                      },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    isSelected
                                        ? theme.accentColor.withValues(
                                          alpha: 0.5,
                                        )
                                        : theme.accentColor,
                                foregroundColor: AppColors.background,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                isSelected ? 'Currently Active' : 'Apply Theme',
                                style: AppTypography.button.copyWith(
                                  color: AppColors.background,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          if (theme.isCustom) ...[
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: OutlinedButton(
                                onPressed: () {
                                  Get.toNamed(
                                    '/create-theme',
                                    arguments: theme,
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: theme.textColor.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  'Edit Theme',
                                  style: AppTypography.button.copyWith(
                                    color: theme.textColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBackground(AppThemeData theme) {
    switch (theme.backgroundType) {
      case ThemeBackgroundType.image:
        if (theme.isLocalImage) {
          return Image.file(
            File(theme.imageUrl!),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          );
        }
        return CachedNetworkImage(
          imageUrl: theme.imageUrl!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorWidget: (context, url, error) {
            return Container(color: AppColors.background);
          },
        );
      case ThemeBackgroundType.solidColor:
        return Container(color: theme.solidColor);
      case ThemeBackgroundType.gradient:
        return Container(decoration: BoxDecoration(gradient: theme.gradient));
    }
  }
}
