import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/recipe_data.dart';
import '../models/recipe_model.dart';

/// Favorites backed by Hive. We store `bool` flags keyed by recipe.id
/// in a Hive box; the in-memory `favoriteRecipes` list is rebuilt from it.
class FavoriteController extends GetxController {
  static const _boxName = 'favorites';

  final RxList<RecipeModel> favoriteRecipes = <RecipeModel>[].obs;

  Box<bool> get _box => Hive.box<bool>(_boxName);

  RecipeModel? _lookup(String id) {
    final recipeBox = Hive.box<RecipeModel>('recipes');
    final cached = recipeBox.get(id);
    if (cached != null) return cached;
    // Fallback to in-memory seed if the box is empty (e.g. first-run race).
    for (final r in RecipeData.recipes) {
      if (r.id == id) return r;
    }
    return null;
  }

  bool isFavorite(RecipeModel recipe) => _box.get(recipe.id) ?? false;

  Future<void> toggleFavorite(RecipeModel recipe) async {
    if (isFavorite(recipe)) {
      await _box.delete(recipe.id);
      favoriteRecipes.removeWhere((r) => r.id == recipe.id);
      Get.snackbar(
        'Favorite',
        '${recipe.title} removed from favorites',
      );
    } else {
      await _box.put(recipe.id, true);
      favoriteRecipes.add(recipe);
      Get.snackbar(
        'Favorite',
        '${recipe.title} added to favorites',
      );
    }
  }

  /// Refresh the in-memory list from the persisted Hive box.
  void loadFavorites() {
    favoriteRecipes.clear();
    for (final id in _box.keys) {
      final recipe = _lookup(id.toString());
      if (recipe != null) favoriteRecipes.add(recipe);
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }
}