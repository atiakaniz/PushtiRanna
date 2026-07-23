import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/recipe_controller.dart';
import '../controllers/phone_auth_controller.dart';
import '../widgets/recipe_card.dart';
import '../routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RecipeController controller = Get.find<RecipeController>();

  final PhoneAuthController _phone = Get.find();

  Worker? _revokedWorker;
  Timer? _subscriptionPoll;

  @override
  void initState() {
    super.initState();
    // If a server-side check fires while the user is on the Home screen
    // (e.g. resume after they unsubscribed from the landing page), send
    // them back to the gate so they can resubscribe.
    _revokedWorker = ever<int>(_phone.subscriptionRevokedAt, (_) {
      if (!mounted) return;
      Get.offAllNamed(AppRoutes.GATE);
    });

    // Belt-and-braces: even if the user keeps the app in the foreground
    // for a long stretch (so the AppLifecycleState.resumed hook never
    // fires), poll the server every 30s. If bdapps says the subscription
    // is gone, _phone.subscriptionRevokedAt bumps and the worker above
    // routes us back to the gate.
    _subscriptionPoll = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _phone.checkSubscription(),
    );
  }

  @override
  void dispose() {
    _revokedWorker?.dispose();
    _subscriptionPoll?.cancel();
    super.dispose();
  }

  Widget _buildChip(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Obx(
            () => ChoiceChip(
          label: Text(category),
          selected:
          controller.selectedCategory.value == category,
          onSelected: (_) {
            controller.filterByCategory(category);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // ================= DRAWER =================
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [

            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF2E7D32),
              ),
              accountName: Text(
                _phone.currentPhone.value.isEmpty
                    ? "PushtiRanna User"
                    : _phone.currentPhone.value,
              ),
              accountEmail: Text(
                _phone.currentPhone.value.isEmpty
                    ? "Guest User"
                    : "Phone: ${_phone.currentPhone.value}",
              ),
              currentAccountPicture: const CircleAvatar(
                child: Icon(
                  Icons.person,
                  size: 40,
                ),
              ),
            ),
            const Divider(),

            ExpansionTile(
              leading: const Icon(Icons.restaurant_menu),
              title: const Text("Recipe Categories"),
              children: [

                ListTile(
                  leading: const Icon(Icons.breakfast_dining),
                  title: const Text("Breakfast"),
                  onTap: () {
                    controller.filterByCategory("Breakfast");
                    Get.back();
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.lunch_dining),
                  title: const Text("Lunch"),
                  onTap: () {
                    controller.filterByCategory("Lunch");
                    Get.back();
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.dinner_dining),
                  title: const Text("Dinner"),
                  onTap: () {
                    controller.filterByCategory("Dinner");
                    Get.back();
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.local_florist),
                  title: const Text("Salad"),
                  onTap: () {
                    controller.filterByCategory("Salad");
                    Get.back();
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.soup_kitchen),
                  title: const Text("Soup"),
                  onTap: () {
                    controller.filterByCategory("Soup");
                    Get.back();
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.set_meal),
                  title: const Text("Healthy Non-Veg"),
                  onTap: () {
                    controller.filterByCategory("Healthy Non-Veg");
                    Get.back();
                  },
                ),
              ],
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text("Favorites"),
              onTap: () {
                Get.toNamed(AppRoutes.FAVORITE);
              },
            ),

            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                Get.toNamed(AppRoutes.SETTINGS);
              },
            ),
          ],
        ),
      ),

      // ================= APP BAR =================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF2E7D32),
        title: Row(
          children: [
            const Icon(Icons.eco),
            const SizedBox(width: 8),
            Text('app_name'.tr),
          ],
        ),
      ),

      // ================= FAVORITE BUTTON =================
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2E7D32),
        onPressed: () {
          Get.toNamed(AppRoutes.FAVORITE);
        },
        child: const Icon(Icons.favorite),
      ),

      // ================= BODY =================
      body: Column(
        children: [

          // Search
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              onChanged: controller.searchRecipe,
              decoration: InputDecoration(
                hintText: 'search_hint'.tr,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Category Chips
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                _buildChip("All"),
                _buildChip("Breakfast"),
                _buildChip("Lunch"),
                _buildChip("Dinner"),
                _buildChip("Salad"),
                _buildChip("Soup"),
                _buildChip("Healthy Non-Veg"),
              ],
            ),
          ),


          // Category Title
          Obx(
                () => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 5,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  controller.selectedCategory.value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          Obx(
                () => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${controller.recipes.length} Recipes",
                  style: const TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),

          // Recipe Grid
          Expanded(
            child: Obx(() {

              if (controller.recipes.isEmpty) {
                return const Center(
                  child: Text(
                    "No recipes found",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                );
              }

              return GridView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(10),

                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),

                itemCount: controller.recipes.length,

                itemBuilder: (context, index) {

                  final recipe =
                  controller.recipes[index];

                  return RecipeCard(
                    recipe: recipe,
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.DETAIL,
                        arguments: recipe,
                      );
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),

      // ================= BOTTOM NAV =================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorites",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],

        onTap: (index) {

          if (index == 1) {
            Get.toNamed(
              AppRoutes.FAVORITE,
            );
          }

          if (index == 2) {
            Get.toNamed(
              AppRoutes.SETTINGS,
            );
          }
        },
      ),
    );
  }
}