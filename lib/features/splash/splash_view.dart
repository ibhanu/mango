import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:mango/core/theme/app_colors.dart';
import 'package:mango/core/theme/app_typography.dart';
import 'package:mango/features/splash/splash_controller.dart';

/// Animated splash screen
class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: SplashController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1A1A1A),
                  AppColors.background,
                  AppColors.background,
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated logo
                  Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: AppColors.accentGradient,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withValues(alpha: 0.4),
                              blurRadius: 40,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Image.asset(
                            'assets/images/mango_mascot.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                      .animate()
                      .scale(
                        begin: const Offset(0.5, 0.5),
                        end: const Offset(1, 1),
                        duration: 600.ms,
                        curve: Curves.elasticOut,
                      )
                      .fadeIn(duration: 400.ms),

                  const SizedBox(height: 32),

                  // App name
                  Text(
                        'Mango',
                        style: AppTypography.displayLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                      .animate(delay: 300.ms)
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.3, end: 0),

                  const SizedBox(height: 8),

                  // Tagline
                  Text(
                    'Nurture Your Mind',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.accent,
                    ),
                  ).animate(delay: 500.ms).fadeIn(duration: 400.ms),

                  const SizedBox(height: 60),

                  // Loading indicator
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: const CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation(AppColors.accent),
                    ),
                  ).animate(delay: 700.ms).fadeIn(duration: 300.ms),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
