import 'package:get/get.dart';
import '../models/recipe_model.dart';

class FavoriteController extends GetxController {
  var favoriteRecipes = <RecipeModel>[].obs;

  bool isFavorite(RecipeModel recipe) {
    return favoriteRecipes.any((item) => item.id == recipe.id);
  }

  void toggleFavorite(RecipeModel recipe) {
    if (isFavorite(recipe)) {
      favoriteRecipes.removeWhere(
            (item) => item.id == recipe.id,
      );

      Get.snackbar(
        "Favorite",
        "${recipe.title} removed from favorites",
      );
    } else {
      favoriteRecipes.add(recipe);

      Get.snackbar(
        "Favorite",
        "${recipe.title} added to favorites",
      );
    }

    print("TOTAL FAVORITES: ${favoriteRecipes.length}");
  }
}