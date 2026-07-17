import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/favorite_controller.dart';
import '../widgets/recipe_card.dart';
import '../routes/app_routes.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoriteController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('favorites'.tr),
      ),
      body: Obx(() {
        if (controller.favoriteRecipes.isEmpty) {
          return  Center(
            child: Text('no_favorites'.tr),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: controller.favoriteRecipes.length,
          itemBuilder: (context, index) {
            final recipe = controller.favoriteRecipes[index];

            return RecipeCard(
              recipe: recipe,
              onTap: () {
                Get.toNamed(AppRoutes.DETAIL, arguments: recipe);
              },
            );
          },
        );
      }),
    );
  }
}