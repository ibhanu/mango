import 'package:flutter/material.dart';
import 'package:mango/core/constants/app_constants.dart';
import 'package:mango/core/theme/app_colors.dart';
import 'package:mango/core/theme/app_typography.dart';
import 'package:mango/core/utils/haptics.dart';

/// Gradient container widget with thematic accent
class GradientContainer extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final double? width;
  final double? height;

  const GradientContainer({
    super.key,
    required this.child,
    this.gradient,
    this.borderRadius,
    this.padding,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(AppConstants.paddingM),
      decoration: BoxDecoration(
        gradient: gradient ?? AppColors.accentGradient,
        borderRadius:
            borderRadius ?? BorderRadius.circular(AppConstants.radiusL),
      ),
      child: child,
    );
  }
}

/// Custom app button with gradient option
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isOutlined;
  final bool hasGradient;
  final bool isLoading;
  final IconData? icon;
  final double? width;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isOutlined = false,
    this.hasGradient = false,
    this.isLoading = false,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    if (hasGradient) {
      return SizedBox(
        width: width ?? double.infinity,
        height: 56,
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.accentGradient,
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap:
                  isLoading
                      ? null
                      : () {
                        AppHaptics.light();
                        onPressed();
                      },
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
              child: Center(
                child:
                    isLoading
                        ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(
                              AppColors.background,
                            ),
                          ),
                        )
                        : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (icon != null) ...[
                              Icon(icon, color: AppColors.background),
                              const SizedBox(width: 8),
                            ],
                            Text(
                              label,
                              style: AppTypography.button.copyWith(
                                color: AppColors.background,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
              ),
            ),
          ),
        ),
      );
    }

    if (isOutlined) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        child: SizedBox(
          width: width ?? double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed:
                isLoading
                    ? null
                    : () {
                      AppHaptics.light();
                      onPressed();
                    },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.accent, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
              ),
            ),
            child:
                isLoading
                    ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (icon != null) ...[
                            Icon(icon),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            label,
                            style: AppTypography.button.copyWith(
                              color: AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                    ),
          ),
        ),
      );
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed:
            isLoading
                ? null
                : () {
                  AppHaptics.light();
                  onPressed();
                },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
          ),
        ),
        child:
            isLoading
                ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(AppColors.background),
                  ),
                )
                : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[Icon(icon), const SizedBox(width: 8)],
                    Text(label, style: AppTypography.button),
                  ],
                ),
      ),
    );
  }
}

/// Category chip widget
class CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.shortAnimation,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingM,
          vertical: AppConstants.paddingS,
        ),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.accent.withValues(alpha: 0.15)
                  : AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusRound),
          border: Border.all(
            color: isSelected ? AppColors.accent : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppColors.accent : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTypography.labelLarge.copyWith(
                color: isSelected ? AppColors.accent : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Animated favorite button
class FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onTap;
  final double size;

  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onTap,
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.shortAnimation,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              isFavorite
                  ? AppColors.error.withValues(alpha: 0.1)
                  : AppColors.surfaceVariant.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: AnimatedSwitcher(
          duration: AppConstants.shortAnimation,
          transitionBuilder:
              (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
          child: Icon(
            isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            key: ValueKey(isFavorite),
            size: size,
            color: isFavorite ? AppColors.error : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

/// Streak display widget
class StreakBadge extends StatelessWidget {
  final int streak;

  const StreakBadge({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingM,
        vertical: AppConstants.paddingS,
      ),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(AppConstants.radiusRound),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_fire_department_rounded,
            size: 18,
            color: AppColors.background,
          ),
          const SizedBox(width: 4),
          Text(
            '$streak',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.background,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
