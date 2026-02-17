import 'package:get/get.dart';
import 'package:mango/core/di/service_locator.dart';
import 'package:mango/models/affirmation.dart';
import 'package:mango/models/category.dart';
import 'package:mango/repository/affirmation_repository.dart';

/// Controller for favorites screen
class FavoritesController extends GetxController {
  final AffirmationRepository _repository = getIt<AffirmationRepository>();

  // Favorite affirmations
  List<Affirmation> favorites = [];

  // Search query
  String searchQuery = '';

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  /// Load favorite affirmations
  void loadFavorites() {
    favorites = _repository.getFavorites();
  }

  /// Get filtered favorites based on search
  List<Affirmation> get filteredFavorites {
    if (searchQuery.isEmpty) {
      return favorites;
    }

    return favorites
        .where((a) => a.text.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  /// Get category for an affirmation
  AffirmationCategory? getCategoryFor(String categoryId) {
    return AppCategories.getById(categoryId);
  }

  /// Remove from favorites
  Future<void> removeFromFavorites(String affirmationId) async {
    await _repository.toggleFavorite(affirmationId);
    loadFavorites();
    update();
  }

  /// Update search query
  void updateSearch(String query) {
    searchQuery = query;
    update();
  }
}
