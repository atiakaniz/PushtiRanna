class RecipeModel {
  final String id;
  final String title;
  final String banglaTitle;
  final String image;
  final String category;
  final int calories;
  final int time;
  final List<String> ingredients;
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