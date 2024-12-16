import './recipe.dart';

class Category {
  final String id;
  final String name;
  final List<Recipe> recipes;

  Category({
    required this.id,
    required this.name,
    required this.recipes,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    var list = json['recipes'] as List;
    List<Recipe> recipesList = list.map((i) => Recipe.fromJson(i)).toList();
    return Category(
      id: json['id'],
      name: json['name'],
      recipes: recipesList,
    );
  }
}
