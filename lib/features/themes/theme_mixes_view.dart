import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mango/core/routes/app_routes.dart';
import 'package:mango/core/theme/app_colors.dart';
import 'package:mango/core/theme/app_typography.dart';
import 'package:mango/features/themes/themes_controller.dart';

/// Full screen grid of all themes organized by category
class ThemeMixesView extends StatelessWidget {
  const ThemeMixesView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemesController>(
      init: ThemesController(),
      builder: (ctrl) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary,
              ),
              onPressed: () => Get.back(),
            ),
            title: Text('All Themes', style: AppTypography.titleLarge),
            centerTitle: true,
            actions: [
              TextButton(
                onPressed: () => Get.toNamed(AppRoutes.createTheme),
                child: Text(
                  'Create',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.accent,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: ctrl.allThemes.length,
            itemBuilder: (context, index) {
              final theme = ctrl.allThemes[index];
              final isSelected = ctrl.selectedThemeId == theme.id;

              return GestureDetector(
                onTap:
                    () => Get.toNamed(AppRoutes.themePreview, arguments: theme),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: theme.solidColor,
                    gradient: theme.gradient,
                    image:
                        theme.imageUrl != null
                            ? DecorationImage(
                              image:
                                  theme.isLocalImage
                                      ? FileImage(File(theme.imageUrl!))
                                          as ImageProvider
                                      : CachedNetworkImageProvider(
                                        theme.imageUrl!,
                                      ),
                              fit: BoxFit.cover,
                            )
                            : null,
                    border:
                        isSelected
                            ? Border.all(color: AppColors.accent, width: 3)
                            : null,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
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
                                size: 14,
                                color: AppColors.background,
                              ),
                            ),
                          ),
                        Positioned(
                          bottom: 16,
                          left: 12,
                          right: 12,
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
            },
          ),
        );
      },
    );
  }
}
