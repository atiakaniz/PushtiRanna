import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/recipe_controller.dart';
import '../models/recipe_model.dart';
import '../routes/app_routes.dart';

/// Admin view for managing the persisted recipe library. Reachable from the
/// Home drawer. Lets you add new recipes and edit/delete existing ones.
class AdminRecipesScreen extends StatelessWidget {
  const AdminRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RecipeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage recipes'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: controller.loadRecipes,
          ),
        ],
      ),
      body: Obx(() {
        final recipes = controller.recipes.toList()
          ..sort((a, b) => a.id.compareTo(b.id));
        if (recipes.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'No recipes yet. Tap + to add one.',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return ListView.separated(
          itemCount: recipes.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) => _RecipeAdminTile(recipe: recipes[i]),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add recipe'),
        onPressed: () => Get.toNamed(AppRoutes.RECIPE_EDITOR),
      ),
    );
  }
}

class _RecipeAdminTile extends StatelessWidget {
  const _RecipeAdminTile({required this.recipe});
  final RecipeModel recipe;

  Future<void> _confirmDelete(BuildContext context) async {
    final ok = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete recipe?'),
        content: Text('"${recipe.title}" will be removed from your library.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await Get.find<RecipeController>().deleteRecipe(recipe.id);
      Get.snackbar(
        'Deleted',
        '${recipe.title} removed.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.restaurant_menu)),
      title: Text(recipe.title),
      subtitle: Text(
        '${recipe.banglaTitle}\n'
        '${recipe.category}  •  ${recipe.calories} kcal  •  ${recipe.time} min',
      ),
      isThreeLine: true,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit),
            onPressed: () =>
                Get.toNamed(AppRoutes.RECIPE_EDITOR, arguments: recipe),
          ),
          IconButton(
            tooltip: 'Delete',
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
    );
  }
}