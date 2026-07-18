import 'package:hive/hive.dart';

part 'recipe_model.g.dart';

@HiveType(typeId: 1)
class RecipeModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String banglaTitle;

  @HiveField(3)
  final String image;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final int calories;

  @HiveField(6)
  final int time;

  @HiveField(7)
  final List<String> ingredients;

  @HiveField(8)
  final List<String> steps;

  RecipeModel({
    required this.id,
    required this.title,
    required this.banglaTitle,
    required this.image,
    required this.category,
    required this.calories,
    required this.time,
    required this.ingredients,
    required this.steps,
  });
}