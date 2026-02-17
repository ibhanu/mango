import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:mango/core/theme/app_colors.dart';
import 'package:mango/core/theme/app_typography.dart';
import 'package:mango/core/utils/haptics.dart';
import 'package:mango/features/focus/focus_controller.dart';
import 'package:mango/features/home/home_controller.dart';

/// Screen to choose "What do you want to focus on?"
class FocusView extends StatelessWidget {
  final bool isEmbedded;

  const FocusView({super.key, this.isEmbedded = false});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FocusController>(
      init: FocusController(),
      builder: (ctrl) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              SafeArea(
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
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    size: 28,
                                  ),
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
                                if (ctrl.isMixMode)
                                  TextButton(
                                    onPressed: () {
                                      AppHaptics.medium();
                                      ctrl.toggleMixMode();
                                    },
                                    child: Text(
                                      'Done',
                                      style: AppTypography.titleMedium.copyWith(
                                        color: AppColors.accentLight,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Text(
                              ctrl.isMixMode
                                  ? 'Select what to mix'
                                  : 'What do you want to focus on?',
                              style: AppTypography.displaySmall.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (!ctrl.isMixMode)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              AppHaptics.medium();
                              ctrl.toggleMixMode();
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                color: AppColors.accentLight.withValues(
                                  alpha: 0.9,
                                ),
                                borderRadius: BorderRadius.circular(40),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.accentLight.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  'Make your own mix',
                                  style: AppTypography.titleMedium.copyWith(
                                    color: AppColors.background,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    const SliverToBoxAdapter(child: SizedBox(height: 16)),

                    // Sections
                    ...ctrl.sections.asMap().entries.map((entry) {
                      final sectionIndex = entry.key;
                      final section = entry.value;

                      return SliverMainAxisGroup(
                        slivers: [
                          // Section Header
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 24,
                                right: 24,
                                top: 32,
                                bottom: 16,
                              ),
                              child: Text(
                                section.title,
                                style: AppTypography.titleMedium.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                          // Section Grid
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            sliver: SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 1.1,
                                  ),
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                final category = section.categories[index];
                                final isSelected = ctrl.isSelected(category.id);

                                return GestureDetector(
                                      onTap: () {
                                        AppHaptics.selection();
                                        ctrl.toggleCategory(category.id);
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              isSelected
                                                  ? category.color.withValues(
                                                    alpha:
                                                        ctrl.isMixMode
                                                            ? 0.25
                                                            : 0.15,
                                                  )
                                                  : AppColors.surface,
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                          border:
                                              isSelected
                                                  ? Border.all(
                                                    color: category.color,
                                                    width: 2.5,
                                                  )
                                                  : Border.all(
                                                    color: Colors.white
                                                        .withValues(
                                                          alpha: 0.05,
                                                        ),
                                                    width: 1,
                                                  ),
                                        ),
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(
                                                    8,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        isSelected
                                                            ? category.color
                                                            : category.color
                                                                .withValues(
                                                                  alpha: 0.1,
                                                                ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    category.icon,
                                                    size: 20,
                                                    color:
                                                        isSelected
                                                            ? Colors.white
                                                            : category.color,
                                                  ),
                                                ),
                                                if (ctrl.isMixMode &&
                                                    isSelected)
                                                  const Icon(
                                                    Icons.check_circle,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                              ],
                                            ),
                                            Text(
                                              category.name,
                                              style: AppTypography.titleSmall
                                                  .copyWith(
                                                    color:
                                                        isSelected
                                                            ? AppColors
                                                                .textPrimary
                                                            : AppColors
                                                                .textSecondary,
                                                    fontWeight:
                                                        isSelected
                                                            ? FontWeight.w700
                                                            : FontWeight.w500,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    .animate()
                                    .fadeIn(
                                      delay:
                                          (sectionIndex * 100 + index * 50).ms,
                                    )
                                    .scale(begin: const Offset(0.95, 0.95));
                              }, childCount: section.categories.length),
                            ),
                          ),
                        ],
                      );
                    }),

                    const SliverToBoxAdapter(child: SizedBox(height: 120)),
                  ],
                ),
              ),

              // Bottom gradient to make the bar pop
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 100,
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppColors.background.withValues(alpha: 0.8),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
