import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/category.dart';
import '../models/recipe.dart';

class ApiClient {
  final String _baseUrl = "https://api.edamam.com/api/recipes/v2";
  final String _appId = "your_app_id"; // Remplacez par votre App ID
  final String _appKey = "your_app_key"; // Remplacez par votre App Key

  Future<List<Category>> fetchCategories() async {
    // Edamam n'a pas d'endpoint spécifique pour les catégories,
    // mais elles peuvent être définies en local.
    const healthLabels = [
      "Gluten-Free",
      "Keto",
      "Vegetarian",
      "Vegan",
      "Paleo"
    ];
    const dietLabels = ["Low-Carb", "High-Protein", "Balanced"];
    return [
      ...healthLabels.map((label) => Category(name: label, type: "health")),
      ...dietLabels.map((label) => Category(name: label, type: "diet")),
    ];
  }

  Future<List<Recipe>> fetchRecipes({String query = "", String category = ""}) async {
    final url =
        '$_baseUrl?type=public&q=$query&app_id=$_appId&app_key=$_appKey&health=$category';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final hits = jsonData['hits'] as List;

      return hits.map((hit) => Recipe.fromJson(hit['recipe'])).toList();
    } else {
      throw Exception("Failed to load recipes");
    }
  }

  Future<Recipe> fetchRecipeDetails(String recipeUri) async {
    final encodedUri = Uri.encodeComponent(recipeUri);
    final url = '$_baseUrl/$encodedUri?type=public&app_id=$_appId&app_key=$_appKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return Recipe.fromJson(jsonData['recipe']);
    } else {
      throw Exception("Failed to load recipe details");
    }
  }
}
