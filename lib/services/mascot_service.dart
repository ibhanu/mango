import 'package:mango/core/di/service_locator.dart';
import 'package:mango/repository/affirmation_repository.dart';

/// Service to handle mascot evolution logic based on streaks
class MascotService {
  final AffirmationRepository _repository = getIt<AffirmationRepository>();

  /// Get the current streak from repository
  int get streak => _repository.dailyStreak;

  /// Get the mascot asset path based on current streak
  String get mascotAsset {
    if (streak >= 26) {
      return 'assets/images/mango_mascot_golden.png';
    } else if (streak >= 11) {
      return 'assets/images/mango_mascot_ripe.png';
    } else if (streak >= 4) {
      return 'assets/images/mango_mascot_sprout.png';
    } else {
      return 'assets/images/mango_mascot.png';
    }
  }

  /// Get the evolution name
  String get evolutionName {
    if (streak >= 26) {
      return 'Golden Aura';
    } else if (streak >= 11) {
      return 'Ripe Mango';
    } else if (streak >= 4) {
      return 'Sprout';
    } else {
      return 'Seedling';
    }
  }

  /// Check if mascot has shimmer effect (Golden Aura)
  bool get hasShimmer => streak >= 26;
}
