class Recipe {
  final String label; // Nom de la recette
  final String image; // URL de l'image
  final List<String> ingredients;
  final double calories;
  final List<String> healthLabels;
  final List<String> dietLabels;

  Recipe({
    required this.label,
    required this.image,
    required this.ingredients,
    required this.calories,
    required this.healthLabels,
    required this.dietLabels,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      label: json['label'] as String,
      image: json['image'] as String,
      ingredients: (json['ingredientLines'] as List).map((e) => e as String).toList(),
      calories: json['calories'] as double,
      healthLabels: (json['healthLabels'] as List).map((e) => e as String).toList(),
      dietLabels: (json['dietLabels'] as List).map((e) => e as String).toList(),
    );
  }
}
