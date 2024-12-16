import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/country.dart';
import '../models/recipe.dart';

class ApiClient {
  static const String _baseUrl = "https://www.themealdb.com/api/json/v1/1/";

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('${_baseUrl}categories.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final categories = data['categories'] as List<dynamic>;

      return categories.map((category) => Category.fromJson(category)).toList();
    } else {
      throw Exception("Erreur lors du chargement des catégories");
    }
  }

  Future<List<Country>> fetchCountries() async {
    final response = await http.get(Uri.parse('${_baseUrl}list.php?a=list'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final countries = data['meals'] as List<dynamic>;

      return countries.map((country) => Country.fromJson(country)).toList();
    } else {
      throw Exception("Erreur lors du chargement des pays");
    }
  }


  // Recherche par ingrédient
  static Future<List<Recipe>> searchByIngredient(String ingredient) async {
    final response = await http.get(Uri.parse('$_baseUrl/filter.php?i=$ingredient'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final meals = data['meals'] as List<dynamic>;

      // Convertir les résultats en une liste de Meal
      return meals.map((meal) => Recipe.fromJson(meal)).toList();
    } else {
      throw Exception("Erreur lors du chargement des données");
    }
  }

  // Détails d'une recette par ID
  static Future<Recipe> getMealDetails(String idMeal) async {
    final response = await http.get(Uri.parse('$_baseUrl/lookup.php?i=$idMeal'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final meal = data['meals'][0]; // Prendre le premier élément
      return Recipe.fromJson(meal);
    } else {
      throw Exception("Erreur lors de la récupération des détails de la recette");
    }
  }
}
