class Recipe {
  final String id;
  final String title;
  final String category;
  final List<String> ingredients;
  final String instructions;
  final String url;

  Recipe({
    required this.id,
    required this.title,
    required this.category,
    required this.ingredients,
    required this.instructions,
    required this.url,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      ingredients: List<String>.from(json['ingredients']),
      instructions: json['instructions'],
      url: json['url'],
    );
  }
}
