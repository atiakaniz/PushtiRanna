import 'package:get/get.dart';
import '../data/recipe_data.dart';
import '../models/recipe_model.dart';

class RecipeController extends GetxController {
  var recipes = <RecipeModel>[].obs;
  var searchText = ''.obs;

  var selectedCategory = "All".obs;

  @override
  void onInit() {
    super.onInit();
    loadRecipes();
  }

  void loadRecipes() {
    recipes.value = RecipeData.recipes;
  }

  // Category Filter
  void filterByCategory(String category) {
    selectedCategory.value = category;

    if (selectedCategory.value == "All") {
      recipes.value = RecipeData.recipes;
    } else {
      recipes.value = RecipeData.recipes
          .where((recipe) => recipe.category == selectedCategory.value)
          .toList();
    }
  }

  // Search inside current category
  void searchRecipe(String text) {
    searchText.value = text;

    List<RecipeModel> filteredRecipes;

    if (selectedCategory == "All") {
      filteredRecipes = RecipeData.recipes;
    } else {
      filteredRecipes = RecipeData.recipes
          .where((recipe) => recipe.category == selectedCategory)
          .toList();
    }

    if (text.isEmpty) {
      recipes.value = filteredRecipes;
    } else {
      recipes.value = filteredRecipes
          .where(
            (recipe) => recipe.title
            .toLowerCase()
            .contains(text.toLowerCase()),
      )
          .toList();
    }
  }
}