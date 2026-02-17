import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:mango/core/constants/app_constants.dart';
import 'package:mango/core/di/service_locator.dart';
import 'package:mango/core/theme/app_colors.dart';
import 'package:mango/core/theme/app_typography.dart';
import 'package:mango/core/widgets/mango_time_picker.dart';
import 'package:mango/features/onboarding/onboarding_controller.dart';
import 'package:mango/services/mascot_service.dart';
import 'package:mango/widgets/common/widgets.dart';

/// Onboarding flow with 3 steps
class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingController>(
      init: OnboardingController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                // Skip button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: controller.skipOnboarding,
                        child: Text(
                          'Skip',
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Page indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(7, (index) {
                    final isActive = controller.currentPage == index;
                    return AnimatedContainer(
                      duration: AppConstants.mediumAnimation,
                      width: isActive ? 32 : 8,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color:
                            isActive
                                ? AppColors.accent
                                : AppColors.surfaceVariant.withValues(
                                  alpha: 0.3,
                                ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 32),

                // Pages
                Expanded(
                  child: PageView(
                    controller: controller.pageController,
                    onPageChanged: controller.onPageChanged,
                    children: [
                      const _WelcomePage(),
                      _NamePage(controller: controller),
                      _PursuitPage(controller: controller),
                      _PartnershipPage(controller: controller),
                      _CategoriesPage(controller: controller),
                      _FrequencyPage(controller: controller),
                      _CommitmentPage(controller: controller),
                    ],
                  ),
                ),

                // Navigation buttons
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final totalWidth = constraints.maxWidth;
                      final showBackButton = controller.currentPage > 0;
                      final targetBackRatio = showBackButton ? 0.33 : 0.0;

                      return TweenAnimationBuilder<double>(
                        duration: AppConstants.mediumAnimation,
                        curve: Curves.easeInOut,
                        tween: Tween<double>(end: targetBackRatio),
                        builder: (context, backRatio, child) {
                          final spacing = backRatio > 0.01 ? 16.0 : 0.0;
                          final backWidth = (totalWidth - spacing) * backRatio;
                          final continueWidth =
                              (totalWidth - spacing) * (1 - backRatio);

                          return Row(
                            children: [
                              if (backRatio > 0.01)
                                SizedBox(
                                  width: backWidth,
                                  child: AnimatedOpacity(
                                    duration: AppConstants.shortAnimation,
                                    opacity:
                                        backRatio > 0.1 ? 1.0 : backRatio * 10,
                                    child: AppButton(
                                      label: 'Back',
                                      onPressed: controller.previousPage,
                                      isOutlined: true,
                                      width: backWidth,
                                    ),
                                  ),
                                ),
                              if (backRatio > 0.01) SizedBox(width: spacing),
                              SizedBox(
                                width: continueWidth,
                                child: AppButton(
                                  label:
                                      controller.currentPage == 6
                                          ? 'Enter Mango'
                                          : 'Continue',
                                  onPressed:
                                      controller.currentPage == 6
                                          ? controller.completeOnboarding
                                          : controller.nextPage,
                                  hasGradient: true,
                                  width: continueWidth,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Welcome page (Step 1)
class _WelcomePage extends StatelessWidget {
  const _WelcomePage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Image.asset(
                      getIt<MascotService>().mascotAsset,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.05, 1.05),
                duration: const Duration(seconds: 2),
                curve: Curves.easeInOut,
              ),

          const SizedBox(height: 48),

          Text(
                'Your Mind,\nArchitected.',
                style: AppTypography.displayMedium.copyWith(height: 1.1),
                textAlign: TextAlign.center,
              )
              .animate()
              .fadeIn(duration: 800.ms)
              .slideY(begin: 0.3, curve: Curves.easeOutBack),

          const SizedBox(height: 24),

          Text(
            'Personalize your journey to self-mastery through the power of intention.',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ).animate(delay: 400.ms).fadeIn(duration: 800.ms),
        ],
      ),
    );
  }
}

/// Name input page (Step 2)
class _NamePage extends StatelessWidget {
  final OnboardingController controller;
  const _NamePage({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Text(
            'How should we\naddress you?',
            style: AppTypography.displaySmall.copyWith(fontFamily: 'serif'),
            textAlign: TextAlign.center,
          ).animate().fadeIn().slideY(begin: 0.2),

          const SizedBox(height: 64),

          TextField(
                onChanged: controller.setUserName,
                style: AppTypography.headlineMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontFamily: 'serif',
                ),
                textAlign: TextAlign.center,
                cursorColor: AppColors.accent,
                decoration: InputDecoration(
                  hintText: 'Your name',
                  hintStyle: AppTypography.headlineMedium.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.2),
                    fontFamily: 'serif',
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(
                      color: Colors.white12,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(
                      color: AppColors.accent,
                      width: 1.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 24,
                  ),
                ),
              )
              .animate(delay: const Duration(milliseconds: 300))
              .fadeIn()
              .slideY(begin: 0.1),

          const SizedBox(height: 24),
          Text(
            'Your name helps us create a more personal bond.',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ).animate(delay: const Duration(milliseconds: 600)).fadeIn(),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

/// Pursuit page (Step 3)
class _PursuitPage extends StatelessWidget {
  final OnboardingController controller;
  const _PursuitPage({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'What is your\nmain pursuit?',
            style: AppTypography.displaySmall.copyWith(fontFamily: 'serif'),
            textAlign: TextAlign.center,
          ).animate().fadeIn().slideY(begin: 0.2),
          const SizedBox(height: 48),
          _ContextSelector(
            options: const [
              'Career',
              'Academic',
              'Creative',
              'Health',
              'Business',
            ],
            selected: controller.occupation,
            onSelect: controller.setOccupation,
          ).animate(delay: const Duration(milliseconds: 200)).fadeIn(),
        ],
      ),
    );
  }
}

/// Partnership page (Step 4)
class _PartnershipPage extends StatelessWidget {
  final OnboardingController controller;
  const _PartnershipPage({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'How is your\nlife partnership?',
            style: AppTypography.displaySmall.copyWith(fontFamily: 'serif'),
            textAlign: TextAlign.center,
          ).animate().fadeIn().slideY(begin: 0.2),
          const SizedBox(height: 48),
          _ContextSelector(
            options: const [
              'Single',
              'Relationship',
              'Married',
              'Focused on Self',
            ],
            selected: controller.relationshipStatus,
            onSelect: controller.setRelationship,
          ).animate(delay: const Duration(milliseconds: 200)).fadeIn(),
        ],
      ),
    );
  }
}

class _ContextSelector extends StatelessWidget {
  final List<String> options;
  final String selected;
  final Function(String) onSelect;

  const _ContextSelector({
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children:
          options.map((option) {
            final isSelected = selected == option;
            return GestureDetector(
              onTap: () => onSelect(option),
              child: AnimatedContainer(
                duration: AppConstants.shortAnimation,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accent : AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color:
                        isSelected
                            ? Colors.white24
                            : Colors.white.withValues(alpha: 0.05),
                  ),
                  boxShadow:
                      isSelected
                          ? [
                            BoxShadow(
                              color: AppColors.accent.withValues(alpha: 0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ]
                          : [],
                ),
                child: Text(
                  option,
                  style: AppTypography.bodyLarge.copyWith(
                    color:
                        isSelected
                            ? AppColors.background
                            : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}

/// Categories selection page (Step 4)
class _CategoriesPage extends StatelessWidget {
  final OnboardingController controller;

  const _CategoriesPage({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Text(
            'Vibrational Match',
            style: AppTypography.displaySmall,
            textAlign: TextAlign.center,
          ).animate().fadeIn().slideY(begin: 0.2, end: 0),

          const SizedBox(height: 12),

          Text(
            'Select the energies you wish to invite today',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ).animate(delay: 100.ms).fadeIn(),

          const SizedBox(height: 32),

          Expanded(
            child: GetBuilder<OnboardingController>(
              builder:
                  (ctrl) => GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.1,
                        ),
                    itemCount: ctrl.categories.length,
                    itemBuilder: (context, index) {
                      final category = ctrl.categories[index];
                      final isSelected = ctrl.isCategorySelected(category.id);

                      return GestureDetector(
                            onTap: () => controller.toggleCategory(category.id),
                            child: AnimatedContainer(
                              duration: AppConstants.shortAnimation,
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? AppColors.accent
                                        : AppColors.surface.withValues(
                                          alpha: 0.5,
                                        ),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color:
                                      isSelected
                                          ? Colors.white24
                                          : Colors.white.withValues(
                                            alpha: 0.05,
                                          ),
                                  width: 1.5,
                                ),
                                boxShadow:
                                    isSelected
                                        ? [
                                          BoxShadow(
                                            color: AppColors.accent.withValues(
                                              alpha: 0.2,
                                            ),
                                            blurRadius: 20,
                                            offset: const Offset(0, 8),
                                          ),
                                        ]
                                        : [],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    category.icon,
                                    size: 36,
                                    color:
                                        isSelected
                                            ? AppColors.background
                                            : AppColors.accent,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    category.name,
                                    style: AppTypography.titleSmall.copyWith(
                                      color:
                                          isSelected
                                              ? AppColors.background
                                              : AppColors.textPrimary,
                                      fontWeight:
                                          isSelected
                                              ? FontWeight.w800
                                              : FontWeight.w600,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .animate(delay: (index * 50).ms)
                          .fadeIn()
                          .slideY(begin: 0.1);
                    },
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Frequency Page (Step 5)
class _FrequencyPage extends StatelessWidget {
  final OnboardingController controller;
  const _FrequencyPage({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Mental Recalibration',
            style: AppTypography.displaySmall,
            textAlign: TextAlign.center,
          ).animate().fadeIn().slideY(begin: 0.2),

          const SizedBox(height: 12),

          Text(
            'How often should we gently interrupt your day with positivity?',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ).animate(delay: 100.ms).fadeIn(),

          const SizedBox(height: 48),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                [1, 3, 5, 8].map((freq) {
                  final isSelected = controller.notificationFrequency == freq;
                  return GestureDetector(
                    onTap: () => controller.setFrequency(freq),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: AppConstants.shortAnimation,
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? AppColors.accent
                                    : AppColors.surface,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  isSelected
                                      ? Colors.white24
                                      : Colors.transparent,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '$freq',
                              style: AppTypography.titleLarge.copyWith(
                                color:
                                    isSelected
                                        ? AppColors.background
                                        : AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          freq == 1 ? 'TIME' : 'TIMES',
                          style: AppTypography.labelSmall.copyWith(
                            fontSize: 8,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ).animate(delay: 300.ms).fadeIn().scale(),

          const SizedBox(height: 48),

          _TimePickerTile(
            label: 'Starting at',
            time: controller.notificationTime,
            onTap: () async {
              final picked = await MangoTimePicker.show(
                context,
                initialTime: controller.notificationTime,
              );
              if (picked != null) {
                controller.updateNotificationTime(picked);
              }
            },
          ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.1),
        ],
      ),
    );
  }
}

class _TimePickerTile extends StatelessWidget {
  final String label;
  final TimeOfDay time;
  final VoidCallback onTap;

  const _TimePickerTile({
    required this.label,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: AppTypography.labelSmall.copyWith(letterSpacing: 2),
                ),
                const SizedBox(height: 4),
                Text(
                  time.format(context),
                  style: AppTypography.headlineSmall.copyWith(
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(
              Icons.access_time_filled_rounded,
              color: AppColors.accent,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}

/// Commitment Page (Step 6)
class _CommitmentPage extends StatelessWidget {
  final OnboardingController controller;
  const _CommitmentPage({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.favorite_rounded,
                  color: AppColors.accent,
                  size: 64,
                ),
                const SizedBox(height: 24),
                Text(
                  'The Mango Pledge',
                  style: AppTypography.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'I commit to dedicating a few moments each day to nurture my inner dialogue, for my mind is the fertile ground from which my reality grows.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyLarge.copyWith(
                    height: 1.6,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn().scale(
            duration: 800.ms,
            curve: Curves.easeOutBack,
          ),

          const SizedBox(height: 48),

          GestureDetector(
            onTap: () => controller.setCommitted(!controller.isCommitted),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: AppConstants.shortAnimation,
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color:
                        controller.isCommitted
                            ? AppColors.accent
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color:
                          controller.isCommitted
                              ? AppColors.accent
                              : Colors.white24,
                      width: 2,
                    ),
                  ),
                  child:
                      controller.isCommitted
                          ? const Icon(
                            Icons.check_rounded,
                            color: AppColors.background,
                            size: 24,
                          )
                          : null,
                ),
                const SizedBox(width: 16),
                Text(
                  'I commit to myself',
                  style: AppTypography.titleMedium.copyWith(
                    color:
                        controller.isCommitted
                            ? Colors.white
                            : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ).animate(delay: const Duration(seconds: 1)).fadeIn(),
        ],
      ),
    );
  }
}
