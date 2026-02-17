import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:mango/core/di/service_locator.dart';
import 'package:mango/core/theme/app_colors.dart';
import 'package:mango/core/utils/haptics.dart';
import 'package:mango/features/focus/focus_view.dart';
import 'package:mango/features/home/home_controller.dart';
import 'package:mango/features/home/widgets/shareable_affirmation_widget.dart';
import 'package:mango/features/settings/settings_view.dart';
import 'package:mango/features/themes/themes_view.dart';
import 'package:mango/models/app_theme_model.dart';
import 'package:mango/repository/theme_repository.dart';
import 'package:mango/services/mascot_service.dart';

/// Main home screen with affirmation display and floating bottom bar
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (ctrl) {
        // Map navIndex:
        // 0: Home (_AffirmationTab)
        // 1: Focus (FocusView)
        // 2: Themes (ThemesView)
        // 3: Settings (SettingsView)

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              // Main Content
              IndexedStack(
                index: ctrl.navIndex,
                children: [
                  _AffirmationTab(controller: ctrl),
                  const FocusView(isEmbedded: true),
                  const ThemesView(isEmbedded: true),
                  const SettingsView(isEmbedded: true),
                ],
              ),

              // Hidden RepaintBoundary for Sharing
              // We position it off-screen but keep it in the tree
              if (ctrl.currentAffirmation != null)
                Positioned(
                  left: -5000,
                  child: RepaintBoundary(
                    key: ctrl.boundaryKey,
                    child: ShareableAffirmationWidget(
                      affirmation: ctrl.currentAffirmation!,
                      category: ctrl.currentCategory,
                      theme: getIt<ThemeRepository>().getSelectedTheme(),
                    ),
                  ),
                ),

              // Floating Bottom Navigation (Separate Circular Buttons)
              if (ctrl.navIndex == 0)
                Positioned(
                  bottom: 40,
                  left: 24,
                  right: 24,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _ActionButton(
                        icon: Icons.grid_view_rounded,
                        onTap: (ctx) => ctrl.onNavTap(1), // Focus
                      ),
                      _ActionButton(
                        icon: Icons.layers_outlined,
                        onTap: (ctx) => ctrl.onNavTap(2), // Themes
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
}

// _CustomBottomBar removed

// _PracticeButton removed

// _NavItem removed

class _AffirmationTab extends StatelessWidget {
  final HomeController controller;

  const _AffirmationTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeRepository>().getSelectedTheme();

    return Stack(
      children: [
        // Dynamic Theme Background with Parallax
        _ThemeBackground(theme: theme, controller: controller),

        SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        AppHaptics.light();
                        controller.onNavTap(3); // Profile
                      },
                      child: GetBuilder<HomeController>(
                        builder: (_) {
                          final mascotService = getIt<MascotService>();
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF051139),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.2,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                  image: DecorationImage(
                                    image: AssetImage(
                                      mascotService.mascotAsset,
                                    ),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                child:
                                    mascotService.hasShimmer
                                        ? const SizedBox.shrink()
                                            .animate(onPlay: (c) => c.repeat())
                                            .shimmer(
                                              duration: 2000.ms,
                                              color: Colors.white30,
                                            )
                                        : null,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                mascotService.evolutionName,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.settings_outlined,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () {
                        AppHaptics.light();
                        controller.onNavTap(3);
                      },
                    ),
                  ],
                ),
              ),

              Expanded(
                child: PageView.builder(
                  scrollDirection: Axis.vertical,
                  controller: controller.pageController,
                  itemCount: controller.affirmations.length,
                  onPageChanged: controller.onPageChanged,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = controller.affirmations[index];

                    return AnimatedBuilder(
                      animation: controller.pageController,
                      builder: (context, child) {
                        double value = 0.0;
                        if (controller.pageController.hasClients &&
                            controller
                                .pageController
                                .position
                                .hasContentDimensions) {
                          value = controller.pageController.page! - index;
                        } else {
                          value = (controller.currentIndex - index).toDouble();
                        }

                        // Determine the visual transition (Stack Effect)
                        final scale = 1.0 - (value.abs() * 0.15);
                        final opacity = 1.0 - (value.abs() * 0.5);
                        final rotation = value * 0.1;
                        final shift = value * 100.0;

                        return Transform(
                          transform:
                              Matrix4.identity()
                                ..setEntry(3, 2, 0.001) // perspective
                                ..translate(0.0, shift, 0.0)
                                ..scale(scale.clamp(0.8, 1.0))
                                ..rotateZ(rotation),
                          alignment: Alignment.center,
                          child: Opacity(
                            opacity: opacity.clamp(0.0, 1.0),
                            child: child,
                          ),
                        );
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Decorative element
                              Container(
                                width: 40,
                                height: 1,
                                color: Colors.white.withValues(alpha: 0.3),
                              ),

                              const SizedBox(height: 32),

                              Text(
                                item.text,
                                textAlign: TextAlign.center,
                                style: theme.fontChoice.getTextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w500,
                                  color: theme.textColor,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 60),

                              // Actions
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _ActionButton(
                                    icon: Icons.ios_share_rounded,
                                    onTap: (ctx) {
                                      final box =
                                          ctx.findRenderObject() as RenderBox?;
                                      final offset =
                                          box?.localToGlobal(Offset.zero) ??
                                          Offset.zero;
                                      final rect =
                                          box != null
                                              ? (offset & box.size)
                                              : null;
                                      controller.shareAffirmation(
                                        sharePositionOrigin: rect,
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 40),
                                  _ActionButton(
                                    icon:
                                        item.isFavorite == true
                                            ? Icons.favorite_rounded
                                            : Icons.favorite_border_rounded,
                                    onTap: (ctx) {
                                      AppHaptics.medium();
                                      controller.toggleFavorite();
                                    },
                                    isActive: item.isFavorite == true,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Swipe Indicator
              const _SwipeIndicator(),

              const SizedBox(height: 140), // Spacer for bottom buttons
            ],
          ),
        ),
      ],
    );
  }
}

// _MeshBackground removed as it was unreferenced

/// Dynamic theme background that renders based on selected theme
class _ThemeBackground extends StatelessWidget {
  final AppThemeData theme;
  final HomeController controller;

  const _ThemeBackground({required this.theme, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      id: 'parallax',
      builder: (ctrl) {
        return Stack(
          fit: StackFit.expand,
          children: [
            // Background based on type
            Transform(
              transform:
                  Matrix4.identity()..translate(ctrl.parallaxX, ctrl.parallaxY),
              child: _buildBackground(),
            ),

            // Overlay for text readability
            Container(
              color: (theme.overlayColor ?? Colors.black).withValues(
                alpha: theme.overlayOpacity,
              ),
            ),

            // Subtle animated effect for image/gradient themes
            if (theme.backgroundType != ThemeBackgroundType.solidColor)
              Positioned.fill(
                child: Opacity(
                  opacity: 0.05,
                  child: Transform(
                    transform:
                        Matrix4.identity()..translate(
                          ctrl.parallaxX * 1.5,
                          ctrl.parallaxY * 1.5,
                        ),
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://www.transparenttextures.com/patterns/stardust.png',
                      repeat: ImageRepeat.repeat,
                      fit: BoxFit.none,
                      errorWidget: (_, __, ___) => const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildBackground() {
    switch (theme.backgroundType) {
      case ThemeBackgroundType.image:
        if (theme.isLocalImage) {
          return Image.file(
            File(theme.imageUrl ?? ''),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder:
                (_, __, ___) => Container(color: AppColors.background),
          );
        }
        return CachedNetworkImage(
          imageUrl: theme.imageUrl ?? '',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorWidget: (_, __, ___) => Container(color: AppColors.background),
          placeholder: (context, url) => Container(color: AppColors.background),
        );
      case ThemeBackgroundType.solidColor:
        return Container(color: theme.solidColor ?? AppColors.background);
      case ThemeBackgroundType.gradient:
        return Container(decoration: BoxDecoration(gradient: theme.gradient));
    }
  }
}

// _GlowBlob removed as it was unreferenced

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final void Function(BuildContext) onTap;
  final bool isActive;

  const _ActionButton({
    required this.icon,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppHaptics.light();
        onTap(context);
      },
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Icon(
              icon,
              color: isActive ? Colors.redAccent : Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}

class _SwipeIndicator extends StatelessWidget {
  const _SwipeIndicator();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
              Icons.keyboard_arrow_up_rounded,
              color: Colors.white.withValues(alpha: 0.25),
              size: 20,
            )
            .animate(onPlay: (ctrl) => ctrl.repeat())
            .moveY(
              begin: 3,
              end: -3,
              duration: 2000.ms,
              curve: Curves.easeInOut,
            )
            .fadeIn(duration: 2000.ms),
      ],
    ).animate().fadeIn(delay: 2000.ms);
  }
}
