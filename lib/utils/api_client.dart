import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/recipe.dart';

class ApiClient {
  final String baseUrl = 'https://publicdomainrecipes.com'; // URL de base

  // Méthode pour récupérer toutes les catégories
  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories.json')); // Exemple de JSON avec les catégories

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Category.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // Méthode pour récupérer les recettes d'une catégorie
  Future<List<Recipe>> fetchRecipesByCategory(String categoryId) async {
    final response = await http.get(Uri.parse('$baseUrl/category/$categoryId.json')); // Exemple de JSON pour une catégorie spécifique

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Recipe.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }
}
