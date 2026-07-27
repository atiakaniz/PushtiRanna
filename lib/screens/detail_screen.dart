import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/favorite_controller.dart';
import '../controllers/phone_auth_controller.dart';
import '../models/recipe_model.dart';

/// Recipe detail page.
///
/// Accepts the recipe through the constructor instead of reaching into
/// [Get.arguments] so we never crash on a missing/wrong-type argument.
/// The favorite heart is wired through [FavoriteController] which is
/// registered permanently in `main.dart`.
///
/// Soft-lock: when the server reports the user's subscription is still in
/// `INITIAL CHARGING PENDING` (operator has not yet confirmed the first
/// charge — typically because the user has no balance), we let the user
/// open the detail screen so they can see what's there, but cover the
/// recipe body with a friendly overlay explaining they need to top up
/// before the recipe unlocks. The favorite heart still works so they can
/// save recipes for later.
class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.recipe});

  final RecipeModel recipe;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late final PhoneAuthController _phone = Get.find();

  @override
  Widget build(BuildContext context) {
    // Safe-find the favorite controller. If for some reason the permanent
    // registration in main.dart hasn't run yet (e.g. during hot-restart
    // race), fall back to a local instance so the page still renders.
    final FavoriteController favoriteController =
        Get.isRegistered<FavoriteController>()
            ? Get.find<FavoriteController>()
            : Get.put(FavoriteController(), permanent: true);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.title),
        actions: [
          IconButton(
            icon: Obx(() {
              // Observe favoriteRecipes so the heart updates when toggled.
              favoriteController.favoriteRecipes.length;
              return Icon(
                favoriteController.isFavorite(widget.recipe)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.red,
              );
            }),
            onPressed: () => favoriteController.toggleFavorite(widget.recipe),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Underlying recipe body. Always rendered so the user can see
          // the title and ingredients behind the soft-lock, and so the
          // widget tree doesn't rebuild when the lock toggles.
          _RecipeBody(recipe: widget.recipe),
          // Soft-lock overlay. Watches subscriptionStatus so it lifts
          // automatically as soon as the operator confirms the first
          // charge and the user's hasFullAccess flips back to true.
          Obx(() {
            if (_phone.hasFullAccess) {
              return const SizedBox.shrink();
            }
            return _ChargingPendingOverlay(
              statusText: _phone.subscriptionStatus.value,
            );
          }),
        ],
      ),
    );
  }
}

class _RecipeBody extends StatelessWidget {
  const _RecipeBody({required this.recipe});

  final RecipeModel recipe;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                  title: Text(recipe.steps[index]),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Nutrition Information",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text("Calories: ${recipe.calories} kcal"),
                  const SizedBox(height: 5),
                  const Text("Protein: Moderate"),
                  const SizedBox(height: 5),
                  const Text("Fiber: High"),
                  const SizedBox(height: 5),
                  const Text("Fat: Low"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

/// Frosted overlay shown while the server still reports the subscription
/// as `INITIAL CHARGING PENDING`. Lets the user see the recipe behind it
/// but blocks reading the ingredients/steps/nutrition, with a clear call
/// to top up their balance.
class _ChargingPendingOverlay extends StatelessWidget {
  const _ChargingPendingOverlay({required this.statusText});

  final String? statusText;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ClipRect(
        child: BackdropFilter(
          filter: const ColorFilter.mode(
            Color(0xCC0F1117),
            BlendMode.srcOver,
          ),
          child: Container(
            color: const Color(0xDD0F1117),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: const Color(0x331FE5C5),
                      borderRadius: BorderRadius.circular(44),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet,
                      color: Color(0xFF1FE5C5),
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Top up to unlock',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Your first subscription charge is still pending. '
                    'Please recharge your mobile balance so the operator '
                    'can confirm the payment, then come back to read the '
                    'full recipe.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFB6BCC9),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  if (statusText != null && statusText!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x22FFB020),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0x55FFB020),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        statusText!,
                        style: const TextStyle(
                          color: Color(0xFFFFB020),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1FE5C5),
                      foregroundColor: const Color(0xFF06231E),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Back to recipes',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
