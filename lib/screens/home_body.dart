import 'package:get/get.dart';
import '../data/recipe_data.dart';
import '../models/recipe_model.dart';
class RecipeController
    extends GetxController {
  var recipes = <RecipeModel>[].obs;
  var selectedCategory = 'All'.obs;
  @override
  void onInit() {
    super.onInit();
    recipes.value = RecipeData.recipes;
    }
  void setCategory(String category) {
    selectedCategory.value = category;
    if (category == 'All')
    { recipes.value = RecipeData.recipes;
    } else { recipes.value = RecipeData.recipes
        .where((r) => r.category == category)
        .toList(); } }
  List<RecipeModel> get filteredRecipes => recipes;
}