class Recipe {
  final String id;
  final String title;
  final String imageUrl;

  Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['idMeal'],
      title: json['strMeal'],
      imageUrl: json['strMealThumb'],
    );
  }
}