import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/recipe_model.dart';
import '../controllers/favorite_controller.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RecipeModel recipe = Get.arguments;
    final FavoriteController favoriteController =
    Get.find<FavoriteController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
        actions: [
          Obx(
                () => IconButton(
              icon: Icon(
                favoriteController.isFavorite(recipe)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: () {
                favoriteController.toggleFavorite(recipe);
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Recipe Image
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                recipe.image,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 15),

            // English Title
            Text(
              recipe.title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            // Bangla Title
            Text(
              recipe.banglaTitle,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 15),

            // Calories & Time
            Row(
              children: [

                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.local_fire_department,
                            color: Colors.orange,
                          ),
                          const SizedBox(height: 5),
                          Text("${recipe.calories} kcal"),
                        ],
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 5),
                          Text("${recipe.time} min"),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Divider(),

            // Ingredients
            const Text(
              "Ingredients",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 10),

            ...recipe.ingredients.map(
                  (item) => ListTile(
                leading: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                title: Text(item),
              ),
            ),

            const SizedBox(height: 10),

            const Divider(),

            // Cooking Steps
            const Text(
              "Cooking Steps",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 10),

            Column(
              children: List.generate(
                recipe.steps.length,
                    (index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    title: Text(
                      recipe.steps[index],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            const Divider(),

            // Nutrition Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "Nutrition Information",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Calories: ${recipe.calories} kcal",
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      "Protein: Moderate",
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      "Fiber: High",
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      "Fat: Low",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}