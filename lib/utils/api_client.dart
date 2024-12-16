import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class ApiClient {
  static const String _baseUrl = "https://www.themealdb.com/api/json/v1/1/";

  // Recherche par ingrédient
  static Future<List<Meal>> searchByIngredient(String ingredient) async {
    final response = await http.get(Uri.parse('$_baseUrl/filter.php?i=$ingredient'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final meals = data['meals'] as List<dynamic>;

      // Convertir les résultats en une liste de Meal
      return meals.map((meal) => Meal.fromJson(meal)).toList();
    } else {
      throw Exception("Erreur lors du chargement des données");
    }
  }

  // Détails d'une recette par ID
  static Future<Meal> getMealDetails(String idMeal) async {
    final response = await http.get(Uri.parse('$_baseUrl/lookup.php?i=$idMeal'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final meal = data['meals'][0]; // Prendre le premier élément
      return Meal.fromJson(meal);
    } else {
      throw Exception("Erreur lors de la récupération des détails de la recette");
    }
  }
}
