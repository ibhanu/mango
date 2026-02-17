import 'package:get/get.dart';
import 'package:mango/core/di/service_locator.dart';
import 'package:mango/core/routes/app_routes.dart';
import 'package:mango/repository/affirmation_repository.dart';

/// Controller for splash screen
class SplashController extends GetxController {
  final AffirmationRepository _repository = getIt<AffirmationRepository>();

  bool isLoading = true;

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Simulate splash delay for animation
    await Future.delayed(const Duration(milliseconds: 2000));

    // Update streak
    await _repository.updateStreak();

    isLoading = false;

    // Navigate based on first launch status
    if (_repository.isFirstLaunch) {
      Get.offAllNamed(AppRoutes.onboarding);
    } else {
      Get.offAllNamed(AppRoutes.home);
    }
  }
}
