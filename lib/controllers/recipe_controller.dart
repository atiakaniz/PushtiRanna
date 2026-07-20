import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/recipe_model.dart';

/// Source of truth for the recipe list.
///
/// Reads from the Hive `recipes` box. The first-launch seed in `main.dart`
/// copies the bundled recipes into the box, so anything we add/edit/delete
/// from the admin screen survives across app restarts.
class RecipeController extends GetxController {
  static const _boxName = 'recipes';

  Box<RecipeModel> get _box => Hive.box<RecipeModel>(_boxName);

  final RxList<RecipeModel> recipes = <RecipeModel>[].obs;
  final RxString searchText = ''.obs;
  final RxString selectedCategory = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    loadRecipes();
  }

  /// Pull every recipe currently persisted in Hive.
  void loadRecipes() {
    recipes.assignAll(_box.values);
    if (!recipes.any((r) => r.category == selectedCategory.value) &&
        selectedCategory.value != 'All') {
      selectedCategory.value = 'All';
    }
  }

  // ---------- Mutations ----------

  Future<void> upsertRecipe(RecipeModel recipe) async {
    await _box.put(recipe.id, recipe);
    final index = recipes.indexWhere((r) => r.id == recipe.id);
    if (index >= 0) {
      recipes[index] = recipe;
    } else {
      recipes.add(recipe);
    }
    _reapplyFilters();
  }

  Future<void> deleteRecipe(String id) async {
    await _box.delete(id);
    recipes.removeWhere((r) => r.id == id);
    _reapplyFilters();
  }

  RecipeModel? findById(String id) => _box.get(id);

  // ---------- Filters ----------

  void filterByCategory(String category) {
    selectedCategory.value = category;
    _reapplyFilters();
  }

  void searchRecipe(String text) {
    searchText.value = text;
    _reapplyFilters();
  }

  void _reapplyFilters() {
    Iterable<RecipeModel> source = _box.values;

    if (selectedCategory.value != 'All') {
      source = source.where((r) => r.category == selectedCategory.value);
    }
    if (searchText.value.isNotEmpty) {
      final q = searchText.value.toLowerCase();
      source = source.where((r) => r.title.toLowerCase().contains(q));
    }

    recipes.assignAll(source);
  }

  /// Distinct categories present in the box, plus 'All' at the front.
  List<String> availableCategories() {
    final set = <String>{};
    for (final r in _box.values) {
      if (r.category.trim().isNotEmpty) set.add(r.category);
    }
    final cats = set.toList()..sort();
    return ['All', ...cats];
  }
}