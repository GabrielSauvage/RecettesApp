import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe.dart';

class RecipeRepository {
  static const String _baseUrl = "https://www.themealdb.com/api/json/v1/1/";

  Future<List<Recipe>> fetchRecipesByCategory(String category) async {
    final response = await http.get(Uri.parse('${_baseUrl}filter.php?c=$category'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final meals = data['meals'] as List<dynamic>;

      return meals.map((meal) => Recipe.fromJson(meal)).toList();
    } else {
      throw Exception("Erreur lors du chargement des recettes");
    }
  }

  Future<List<Recipe>> fetchRecipesByCountry(String country) async {
    final response = await http.get(Uri.parse('${_baseUrl}filter.php?a=$country'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final meals = data['meals'] as List<dynamic>;

      return meals.map((meal) => Recipe.fromJson(meal)).toList();
    } else {
      throw Exception("Erreur lors du chargement des recettes");
    }
  }

  Future<Recipe> getMealDetails(String idMeal) async {
    final response = await http.get(Uri.parse('${_baseUrl}lookup.php?i=$idMeal'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final meal = data['meals'][0]; // Prendre le premier élément
      return Recipe.fromJson(meal);
    } else {
      throw Exception("Erreur lors de la récupération des détails de la recette");
    }
  }

  Future<List<Recipe>> fetchFavoriteRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final List<Recipe> favoriteRecipes = [];

    for (String key in keys) {
      if (prefs.getBool(key) == true) {
        final recipe = await getMealDetails(key);
        favoriteRecipes.add(recipe);
      }
    }

    return favoriteRecipes;
  }

}