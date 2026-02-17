import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mango/core/theme/app_colors.dart';
import 'package:mango/core/theme/app_typography.dart';
import 'package:mango/models/affirmation.dart';
import 'package:mango/models/app_theme_model.dart';
import 'package:mango/models/category.dart';

/// A widget designed to be captured as an image for sharing.
/// It replicates the HomeView aesthetic with branding added.
class ShareableAffirmationWidget extends StatelessWidget {
  final Affirmation affirmation;
  final AffirmationCategory? category;
  final AppThemeData theme;

  const ShareableAffirmationWidget({
    super.key,
    required this.affirmation,
    this.category,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1080, // High resolution for social media
      height: 1920, // 9:16 Aspect ratio
      decoration: BoxDecoration(
        color: theme.solidColor ?? AppColors.background,
        gradient:
            theme.backgroundType == ThemeBackgroundType.gradient
                ? theme.gradient
                : null,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image if applicable
          if (theme.backgroundType == ThemeBackgroundType.image &&
              theme.imageUrl != null)
            _buildBackgroundImage(),

          // Theme Overlay
          Container(
            color: (theme.overlayColor ?? Colors.black).withValues(
              alpha: theme.overlayOpacity,
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Decorative Line
                Container(
                  width: 120,
                  height: 2,
                  color: Colors.white.withValues(alpha: 0.3),
                ),

                const SizedBox(height: 100),

                // Affirmation Text
                Text(
                  affirmation.text,
                  textAlign: TextAlign.center,
                  style: theme.fontChoice.getTextStyle(
                    fontSize: 84, // Larger for sharing
                    fontWeight: FontWeight.w500,
                    color: theme.textColor,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          // Branding Pill at the Bottom
          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🥭', style: TextStyle(fontSize: 32)),
                    const SizedBox(width: 16),
                    Text(
                      'MANGO AFFIRMATIONS',
                      style: AppTypography.labelLarge.copyWith(
                        color: Colors.white,
                        fontSize: 24,
                        letterSpacing: 4.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    if (theme.isLocalImage) {
      final file = File(theme.imageUrl!);
      if (file.existsSync()) {
        return Image.file(file, fit: BoxFit.cover);
      }
    }
    return CachedNetworkImage(
      imageUrl: theme.imageUrl!,
      fit: BoxFit.cover,
      errorWidget: (_, __, ___) => Container(color: AppColors.background),
    );
  }
}
